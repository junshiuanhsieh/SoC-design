`timescale 1ns / 1ps
module matmul #(  
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
reg [3:0]  counter_a_r, counter_a_w;
reg [6:0]  counter_b_r, counter_b_w;
reg [4:0]  counter_o_r, counter_o_w;
reg [(pDATA_WIDTH-1):0] data_a_r[0:15], data_a_w[0:15];
reg [(pDATA_WIDTH-1):0] data_b_r, data_b_w;
reg [(pDATA_WIDTH-1):0] mul_r, mul_w;
reg [3:0]  out_addr_r, out_addr_w;
reg [(pDATA_WIDTH-1):0] out_data_r[0:15], out_data_w[0:15];
integer    i;

// axi-stream write 
reg    buf_full_r, buf_full_w;
reg [(pDATA_WIDTH-1):0] buf_data_r, buf_data_w;
reg    ss_tready_r, ss_tready_w;
assign ss_tready = ss_tready_r;

// simple read
reg    o_valid_r, o_valid_w;
reg [(pDATA_WIDTH-1):0] o_data_r, o_data_w;
assign sm_tvalid = o_valid_r;
assign sm_tdata = o_data_r; /////////////////////////////

always @(*) begin
    ss_tready_w = ((state_r == READ && counter_a_r != 4'b1111) || (state_r == CALC && buf_full_r == 0 && ss_tready_r == 0)) ? 1'b1 : 1'b0;
    buf_data_w = (ss_tready_r && ss_tvalid) ? ss_tdata : buf_data_r;
    buf_full_w = (ss_tready_r && ss_tvalid) ? 1'b1 : (state_r == CALC && counter_b_r[1:0] == 2'b00) ? 1'b0 : buf_full_r;
end

always @(*) begin
    state_w = state_r;
    counter_a_w = counter_a_r;
    counter_b_w = counter_b_r;
    counter_o_w = counter_o_r;
    for (i=0; i<16; i=i+1) data_a_w[i] = data_a_r[i];
    data_b_w = data_b_r;
    mul_w = mul_r;
    out_addr_w = out_addr_r;
    for (i=0; i<16; i=i+1) out_data_w[i] = out_data_r[i];
    o_valid_w = 0;
    o_data_w = o_data_r;

    case (state_r)
        IDLE: begin // wait for ap_start signal from CPU to start
            if (ap_start) begin
                state_w = READ;
                counter_a_w = 0;
                counter_b_w = 0;
                counter_o_w = 0;
                for (i=0; i<16; i=i+1) out_data_w[i] = 0;
            end
        end
        READ: begin // read matrix A from axi-stream write buffer 
            if (buf_full_r) begin
                counter_a_w = counter_a_r + 1;
                data_a_w[counter_a_r] = buf_data_r;
            end
            if (counter_a_r == 15) begin
                counter_a_w = 0;
                state_w = CALC;
            end
        end
        CALC: begin // read matrix B and do calculation at the same time
            case (counter_b_r[1:0]) 
                2'b00: begin
                    counter_b_w = counter_b_r + 1;
                    data_b_w = buf_data_r;
                    //mul_w = data_a_r[{counter_b_r[1:0], counter_b_r[5:4]}] * buf_data_r;
                    out_addr_w = {counter_b_r[1:0], counter_b_r[3:2]};
                    //out_data_w[out_addr_r] = out_data_r[out_addr_r] + mul_r;
                    if (counter_b_r[6]) begin
                        state_w = SEND;
                    end
                end
                2'b01, 2'b10, 2'b11: begin
                    counter_b_w = counter_b_r + 1;
                    //mul_w = data_a_r[{counter_b_r[1:0], counter_b_r[5:4]}] * data_b_r;
                    out_addr_w = {counter_b_r[1:0], counter_b_r[3:2]};
                    //out_data_w[out_addr_r] = out_data_r[out_addr_r] + mul_r;
                end
            endcase
            mul_w = data_a_r[{counter_b_r[1:0], counter_b_r[5:4]}] * (counter_b_r[1:0] ? data_b_r : buf_data_r);
            out_data_w[out_addr_r] = out_data_r[out_addr_r] + mul_r;
        end
        SEND: begin // send back the output matrix to DMA
            counter_o_w = counter_o_r + 1;
            o_valid_w = 1;
            o_data_w = out_data_r[counter_o_r];
            if (counter_o_r == 4'b1111) begin
                state_w = IDLE;
            end
        end
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        ss_tready_r <= 0;
        buf_full_r <= 0;
        buf_data_w <= 0;

        state_r <= IDLE;
        counter_a_r <= 0;
        counter_b_r <= 0;
        counter_o_r <= 0;
        for (i=0; i<16; i=i+1) data_a_r[i] <= 0;
        data_b_r <= 0;
        mul_r <= 0;
        out_addr_r <= 0;
        for (i=0; i<16; i=i+1) out_data_r[i] <= 0;

        o_valid_r <= 0;
        o_data_r <= 0;
    end
    else begin
        ss_tready_r <= ss_tready_w;
        buf_full_r <= buf_full_w;
        buf_data_r <= buf_data_w;

        state_r <= state_w;
        counter_a_r <= counter_a_w;
        counter_b_r <= counter_b_w;
        counter_o_r <= counter_o_w;
        for (i=0; i<16; i=i+1) data_a_r[i] <= data_a_w[i];
        data_b_r <= data_b_w;
        mul_r <= mul_w;
        out_addr_r <= out_addr_w;
        for (i=0; i<16; i=i+1) out_data_r[i] <= out_data_w[i];

        o_valid_r <= o_valid_w;
        o_data_r <= o_data_w;
    end
end


endmodule
