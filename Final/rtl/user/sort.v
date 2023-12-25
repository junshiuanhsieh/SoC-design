`timescale 1ns / 1ps
module sort #(  
    parameter pADDR_WIDTH = 12,
    parameter pDATA_WIDTH = 32
)(
    // axi global signals
    input                            clk,
    input                            rst_n,
    input                            ap_start,

    // axi-stream write
    input   wire                     ss_tvalid, 
    input   wire [(pDATA_WIDTH-1):0] ss_tdata, 
    input   wire                     ss_tlast, 
    output  wire                     ss_tready, 

    // AXI stream master
    input   wire                     sm_tready, 
    output  wire                     sm_tvalid, 
    output  wire [(pDATA_WIDTH-1):0] sm_tdata, 
    output  wire                     sm_tlast

    // simple read
    //output  wire                     o_valid,
    //output  wire [(pDATA_WIDTH-1):0] o_data
);

parameter IDLE = 3'd0;
parameter READ = 3'd1;
parameter CALC = 3'd2;
parameter SEND = 3'd3;

reg [1:0]  state_r, state_w;  
reg [(pDATA_WIDTH-1):0] in_data_r, in_data_w;
reg [(pDATA_WIDTH-1):0] out_data_r[0:9], out_data_w[0:9];
reg [3:0]  start_r, start_w, end_r, end_w, total_r, total_w;
reg [3:0]  counter_o_r, counter_o_w;
wire [3:0] middle;
integer    i;
assign middle = (start_r + end_r) >> 1;

// axi-stream write 
reg    buf_full_r, buf_full_w;
reg [(pDATA_WIDTH-1):0] buf_data_r, buf_data_w;
reg    ss_tready_r, ss_tready_w;
assign ss_tready = ss_tready_r; ///////

// simple read
reg    o_valid_r, o_valid_w;
reg [(pDATA_WIDTH-1):0] o_data_r, o_data_w;
assign sm_tvalid = o_valid_r;
assign sm_tdata = o_data_r;

always @(*) begin
    if (state_r == IDLE) begin
        ss_tready_w = 0;
        buf_data_w = 0;
        buf_full_w = 0;
    end
    else begin
        ss_tready_w = (ss_tready_r && ss_tvalid) ? 1'b0 : (!buf_full_r) ? 1'b1 : ss_tready_r;
        buf_data_w = (ss_tready_r && ss_tvalid) ? ss_tdata : buf_data_r;
        buf_full_w = (ss_tready_r && ss_tvalid) ? 1'b1 : (state_r == READ) ? 1'b0 : buf_full_r;
    end
end

always @(*) begin
    state_w = state_r;
    in_data_w = in_data_r;
    for (i=0; i<10; i=i+1) out_data_w[i] = out_data_r[i];
    start_w = start_r;
    end_w = end_r;
    total_w = total_r;

    counter_o_w = counter_o_r;
    o_valid_w = 0;
    o_data_w = o_data_r;

    case (state_r)
        IDLE: begin // wait for ap_start signal from CPU to start
            if (ap_start) begin
                state_w = READ;
                for (i=0; i<10; i=i+1) out_data_w[i] = 0;
                counter_o_w = 0;
            end
        end
        READ: begin // read matrix A from axi-stream write buffer 
            if (buf_full_r) begin
                state_w = CALC;
                in_data_w = buf_data_r;
                start_w = 0;
                end_w = total_r;
                total_w = total_r + 1;
            end
        end
        CALC: begin // read matrix B and do calculation at the same time
            if (start_r == end_r) begin
                for (i=0; i<9; i=i+1) begin
                    if (i >= start_r) begin
                        out_data_w[i+1] = out_data_r[i];
                    end
                end
                out_data_w[start_r] = in_data_r;
                if (total_r == 10) state_w = SEND;
                else               state_w = READ;
            end
            else begin
                if (in_data_r > out_data_r[middle]) begin
                    start_w = middle + 1;
                end
                else begin 
                    end_w = middle; 
                end 
            end
        end
        SEND: begin // send back the output matrix to DMA
            o_valid_w = 1;
            o_data_w = out_data_r[counter_o_r];
            if(sm_tready) counter_o_w = counter_o_r + 1;
            if (counter_o_r == 9 && sm_tready) begin
                state_w = IDLE;
            end
        end
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state_r <= IDLE;
        in_data_r <= 0;
        for (i=0; i<10; i=i+1) out_data_r[i] <= 0;
        start_r <= 0;
        end_r <= 0;
        total_r <= 0;

        ss_tready_r <= 0;
        buf_data_r <= 0;
        buf_full_r <= 0;

        counter_o_r <= 0;
        o_valid_r <= 0;
        o_data_r <= 0;
    end
    else begin
        state_r <= state_w;
        in_data_r <= in_data_w;
        for (i=0; i<10; i=i+1) out_data_r[i] <= out_data_w[i];
        start_r <= start_w;
        end_r <= end_w;
        total_r <= total_w;

        ss_tready_r <= ss_tready_w;
        buf_data_r <= buf_data_w;
        buf_full_r <= buf_full_w;

        counter_o_r <= counter_o_w;
        o_valid_r <= o_valid_w;
        o_data_r <= o_data_w;
    end
end


endmodule
