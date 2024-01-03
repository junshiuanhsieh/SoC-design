module ctrl(
    input wire        rst_n,
    input wire        clk,
    input wire        i_wb_valid,
    input wire [31:0] i_wb_adr,
    input wire        i_wb_we,
    input wire [31:0] i_wb_dat,
    input wire [3:0]  i_wb_sel,
    output reg        o_wb_ack,
    output reg [31:0] o_wb_dat,
    input wire [7:0]  i_rx,
    input wire        i_irq,
    input wire        i_rx_busy,
    input wire        i_frame_err,
    output reg        o_rx_finish,
    output reg [7:0]  o_tx,
    input wire        i_tx_start_clear,
    input wire        i_tx_busy,
    output reg        o_tx_start
);

// Declare the UART memory mapped registers address
localparam RX_DATA  = 32'h3000_0000;
localparam TX_DATA  = 32'h3000_0004;
localparam STAT_REG = 32'h3000_0008;

reg [31:0] rx_buffer[0:7];
reg [2:0]  rx_buffer_cnt;
reg [31:0] tx_buffer[0:7];
reg [2:0]  tx_buffer_cnt;
reg [7:0]  tx_start_local;
reg        i_wb_valid_r;

always @(posedge clk) begin
    i_wb_valid_r <= i_wb_valid;
end
integer i;

// expand signals for debugging
wire [31:0] rx_buffer0, rx_buffer1, rx_buffer2, rx_buffer3, rx_buffer4, rx_buffer5, rx_buffer6, rx_buffer7;
wire [31:0] tx_buffer0, tx_buffer1, tx_buffer2, tx_buffer3, tx_buffer4, tx_buffer5, tx_buffer6, tx_buffer7;
assign rx_buffer0 = rx_buffer[0];
assign rx_buffer1 = rx_buffer[1];
assign rx_buffer2 = rx_buffer[2];
assign rx_buffer3 = rx_buffer[3];
assign rx_buffer4 = rx_buffer[4];
assign rx_buffer5 = rx_buffer[5];
assign rx_buffer6 = rx_buffer[6];
assign rx_buffer7 = rx_buffer[7];
assign tx_buffer0 = tx_buffer[0];
assign tx_buffer1 = tx_buffer[1];
assign tx_buffer2 = tx_buffer[2];
assign tx_buffer3 = tx_buffer[3];
assign tx_buffer4 = tx_buffer[4];
assign tx_buffer5 = tx_buffer[5];
assign tx_buffer6 = tx_buffer[6];
assign tx_buffer7 = tx_buffer[7];

// manage read buffer
wire    get_read;
wire    finish_read;
assign  get_read = i_irq && !i_frame_err;
assign  finish_read = i_wb_valid && !i_wb_valid_r && !i_wb_we;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (i=0; i<8; i=i+1) rx_buffer[i] <= 32'd0;
        rx_buffer_cnt <= 3'd0;
        o_wb_dat <= 0;
    end 
    else begin
        case ({get_read, finish_read})
            2'b01: begin
                if (i_wb_adr == RX_DATA) begin
                    o_wb_dat <= rx_buffer[0];
                    rx_buffer_cnt <= rx_buffer_cnt - 1;
                    for (i=0; i<8; i=i+1) rx_buffer[i] <= (i==7) ? 0 : rx_buffer[i+1];
                end
                else if (i_wb_adr == STAT_REG) begin
                    o_wb_dat <= rx_buffer_cnt;                
                end
            end
            2'b10: begin
                rx_buffer[rx_buffer_cnt] <= i_rx;
                rx_buffer_cnt <= rx_buffer_cnt + 1;
            end    
            2'b11: begin
                if (i_wb_adr == RX_DATA) begin
                    o_wb_dat <= rx_buffer[0];
                    for (i=0; i<8; i=i+1) rx_buffer[i] <= (i==rx_buffer_cnt) ? i_rx : (i==7) ? 0 : rx_buffer[i+1];
                end
                else begin
                    o_wb_dat <= rx_buffer_cnt;          
                end
            end
        endcase
    end
end

// manage write buffer
wire    get_write, finish_write;
assign  get_write = i_wb_valid && !i_wb_valid_r && i_wb_we && i_wb_adr == TX_DATA;
assign  finish_write = i_tx_start_clear;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (i=0; i<8; i=i+1) tx_buffer[i] <= 0;
        tx_buffer_cnt <= 0;
        tx_start_local = 8'b0;
        o_tx <= 8'b0;
        o_tx_start <= 1'b0;
    end
    else begin
        case ({get_write, finish_write}) // get_write : write buffer receive a new data to write, finish_write : write buffer has finished writing a data
            2'b00: begin
            	o_tx <= tx_buffer[0];
            	o_tx_start <= tx_start_local[0];
            end
            2'b01: begin
                o_tx <= 8'b0;
                o_tx_start <= 1'b0;
                tx_buffer_cnt <= tx_buffer_cnt - 1;
                for (i=0; i<8; i=i+1) begin
                    tx_buffer[i] <= (i==7) ? 0 : tx_buffer[i+1];
                    tx_start_local[i] <= (i==7) ? 0 : tx_start_local[i+1];
                end
            end
            2'b10: begin
                o_tx <= tx_buffer[0];
                o_tx_start <= tx_start_local[0];
                tx_buffer_cnt <= tx_buffer_cnt + 1;
                for (i=0; i<8; i=i+1) begin
                    tx_buffer[i] <= (i==tx_buffer_cnt) ? i_wb_dat : tx_buffer[i];
                    tx_start_local[i] <= (i==tx_buffer_cnt) ? 1'b1 : tx_start_local[i];
                end
            end
            2'b11: begin
                o_tx <= 8'b0;
                o_tx_start <= 1'b0;
                for (i=0; i<8; i=i+1) begin 
                    tx_buffer[i] <= (i==tx_buffer_cnt-1) ? i_wb_dat : (i==7) ? 0 : tx_buffer[i+1];
                    tx_start_local[i] <= (i==tx_buffer_cnt-1) ? 1'b1 : (i==7) ? 1'b0 : tx_start_local[i+1];
                end
            end
    	endcase
    end
end

// o_wb_ack
always@(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        o_wb_ack <= 1'b0;
    end else begin
        if(i_wb_valid)  
            o_wb_ack <= 1'b1;
        else            
            o_wb_ack <= 1'b0;
    end
end

endmodule
