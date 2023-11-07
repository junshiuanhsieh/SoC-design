`timescale 1ns / 1ps
//`define MPRJ_IO_PADS 32
module wb_to_axi (  
    input           wb_clk_i,
    input           wb_rst_i,
    input           wbs_stb_i,
    input           wbs_cyc_i,
    input           wbs_we_i,
    input   [3:0]   wbs_sel_i,
    input  [31:0]   wbs_dat_i,
    input  [31:0]   wbs_adr_i,
    output          wbs_ack_o,
    output [31:0]   wbs_dat_o,
    input  [127:0]  la_data_in,
    output [127:0]  la_data_out,
    input  [127:0]  la_oenb,
    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb,
    output  [2:0]   irq
);
 

// axi_lite_write signals 
wire        awready, awvalid, wready, wvalid;
wire [11:0] awaddr;
wire [31:0] wdata;
reg         awvalid_r, awvalid_w, wvalid_r, wvalid_w;
reg  [11:0] awaddr_r, awaddr_w;
reg  [31:0] wdata_r, wdata_w;
assign      awvalid = awvalid_r;
assign      wvalid = wvalid_r;
assign      awaddr = awaddr_r;
assign      wdata = wdata_r;

// axi_lite_read signals
wire        arready, arvalid, rready, rvalid;
wire [11:0] araddr;
wire [31:0] rdata;
reg         arvalid_r, arvalid_w, rready_r, rready_w;
reg  [11:0] araddr_r, araddr_w;
assign      arvalid = arvalid_r;
assign      rready = rready_r;
assign      araddr = araddr_r; 

// axi_stream_write signals
wire        ss_tready, ss_tvalid;
wire [31:0] ss_tdata;
reg         ss_tvalid_r, ss_tvalid_w;
reg  [31:0] ss_tdata_r, ss_tdata_w;
assign      ss_tvalid = ss_tvalid_r;
assign      ss_tdata = ss_tdata_r;

// axi_stream_read signals
wire        sm_tready, sm_tvalid;
wire [31:0] sm_tdata;
reg         sm_tready_r, sm_tready_w;
assign      sm_tready = sm_tready_r;   

// tap_ram
wire [3:0]  tap_WE;
wire        tap_EN;
wire [11:0] tap_A;
wire [31:0] tap_Di, tap_Do;
bram11 tap_ram(
    .clk(wb_clk_i),
    .we(|tap_WE),
    .re(tap_EN),
    .waddr(tap_A),
    .raddr(tap_A),
    .wdi(tap_Di),
    .rdo(tap_Do)
);

// data_ram
wire [3:0]  data_WE;
wire        data_EN;
wire [11:0] data_A;
wire [31:0] data_Di, data_Do;
bram11 data_ram(
    .clk(wb_clk_i),
    .we(|data_WE),
    .re(data_EN),
    .waddr(data_A),
    .raddr(data_A),
    .wdi(data_Di),
    .rdo(data_Do)
);

// fir_module
fir inst_fir(
    .awready(awready),
    .wready(wready),
    .awvalid(awvalid),
    .awaddr(awaddr),
    .wvalid(wvalid),
    .wdata(wdata),
    .arready(arready),
    .rready(rready),
    .arvalid(arvalid),
    .araddr(araddr),
    .rvalid(rvalid),
    .rdata(rdata),    
    .ss_tvalid(ss_tvalid), 
    .ss_tdata(ss_tdata), 
    .ss_tlast(), 
    .ss_tready(ss_tready), 
    .sm_tready(sm_tready), 
    .sm_tvalid(sm_tvalid), 
    .sm_tdata(sm_tdata), 
    .sm_tlast(), 
    
    .tap_WE(tap_WE),
    .tap_EN(tap_EN),
    .tap_Di(tap_Di),
    .tap_A(tap_A),
    .tap_Do(tap_Do),
    
    .data_WE(data_WE),
    .data_EN(data_EN),
    .data_Di(data_Di),
    .data_A(data_A),
    .data_Do(data_Do),

    .axis_clk(wb_clk_i),
    .axis_rst_n(~wb_rst_i)
);

wire       wb_axi_lite, wb_axi_stream;
wire       wb_write, wb_read;
wire       wb_axi_lite_write, wb_axi_lite_read, wb_axi_stream_write, wb_axi_stream_read;
assign     wb_axi_lite   = (wbs_adr_i[31:20] == 12'h300) && (wbs_adr_i[7:4] != 4'h8);
assign     wb_axi_stream = (wbs_adr_i[31:20] == 12'h300) && (wbs_adr_i[7:4] == 4'h8);
assign     wb_write = (wbs_cyc_i) && (wbs_stb_i) &&  (wbs_we_i) && (wbs_sel_i[3:0] == 4'b1111); 
assign     wb_read  = (wbs_cyc_i) && (wbs_stb_i) && (~wbs_we_i) && (wbs_sel_i[3:0] == 4'b1111);
assign     wb_axi_lite_write = (wb_axi_lite) && (wb_write);
assign     wb_axi_lite_read  = (wb_axi_lite) &&  (wb_read);
assign     wb_axi_stream_write = (wb_axi_stream) && (wb_write);
assign     wb_axi_stream_read  = (wb_axi_stream) &&  (wb_read);

reg        wbs_ack_o_r, wbs_ack_o_w;
reg [31:0] wbs_dat_o_r, wbs_dat_o_w;
assign     wbs_ack_o = wbs_ack_o_r;
assign     wbs_dat_o = wbs_dat_o_r;

// axi_lite_write FSM
parameter  ALW_IDLE = 4'd0;
parameter  ALW_SEND = 4'd1;
parameter  ALW_WAIT = 4'd2;
reg  [3:0] alw_state_r, alw_state_w;
reg        alw_ack_o_r, alw_ack_o_w;
always @(*) begin
    alw_state_w = alw_state_r;
    awvalid_w = 0;
    wvalid_w = 0;
    awaddr_w = awaddr_r;
    wdata_w = wdata_r;
    alw_ack_o_w = 0;
    case (alw_state_r)
        ALW_IDLE: begin
            if (wb_axi_lite_write) begin
                alw_state_w = ALW_SEND;
                awvalid_w = 1;
                wvalid_w = 1;
                awaddr_w = wbs_adr_i[11:0];
                wdata_w = wbs_dat_i[31:0];
            end
        end
        ALW_SEND: begin
            awvalid_w = 1;
            wvalid_w = 1;
            if (awvalid && awready && wvalid && wready) begin
                awvalid_w = 0;
                wvalid_w = 0;
                alw_state_w = ALW_WAIT;
                alw_ack_o_w = 1;
            end
        end
        ALW_WAIT: begin
            if (wbs_ack_o) begin
            	alw_state_w = ALW_IDLE;
            end
        end
    endcase
end

// axi_lite_read FSM
parameter  ALR_IDLE = 4'd0;
parameter  ALR_ADDR = 4'd1;
parameter  ALR_DATA = 4'd2;
parameter  ALR_WAIT = 4'd3;
reg  [3:0] alr_state_r, alr_state_w;
reg        alr_ack_o_r, alr_ack_o_w;
reg [31:0] alr_dat_o_r, alr_dat_o_w;
always @(*) begin
    alr_state_w = alr_state_r;
    arvalid_w = 0;
    araddr_w = araddr_r;
    rready_w = 0;
    alr_ack_o_w = 0;
    alr_dat_o_w = alr_dat_o_r;
    case (alr_state_r)
        ALR_IDLE: begin
            if (wb_axi_lite_read) begin
                alr_state_w = ALR_ADDR;
                arvalid_w = 1;
                araddr_w = wbs_adr_i[11:0];
            end
        end
        ALR_ADDR: begin
            arvalid_w = 1;
            if (arvalid && arready) begin
                arvalid_w = 0;
                alr_state_w = ALR_DATA;
                rready_w = 1;
            end
        end
        ALR_DATA: begin
            rready_w = 1;
            if (rready && rvalid) begin
                rready_w = 0;
                alr_ack_o_w = 1;
                alr_dat_o_w = rdata[31:0];
                alr_state_w = ALR_WAIT;
            end 
        end
        ALR_WAIT: begin
            if (wbs_ack_o) begin
            	alr_state_w = ALR_IDLE;
            end
        end
    endcase
end

// axi_stream_write FSM
parameter  ASW_IDLE = 4'd0;
parameter  ASW_SEND = 4'd1;
parameter  ASW_WAIT = 4'd2;
reg  [3:0] asw_state_r, asw_state_w;
reg        asw_ack_o_r, asw_ack_o_w;
always @(*) begin
    asw_state_w = asw_state_r;
    ss_tvalid_w = 0;
    ss_tdata_w = ss_tdata_r;
    asw_ack_o_w = 0;
    case (asw_state_r)
        ASW_IDLE: begin
            if (wb_axi_stream_write) begin
                asw_state_w = ASW_SEND;
                ss_tvalid_w = 1;
                ss_tdata_w = wbs_dat_i[31:0];
            end
        end
        ASW_SEND: begin
            ss_tvalid_w = 1;
            if (ss_tready && ss_tvalid) begin
                ss_tvalid_w = 0;
                asw_state_w = ASW_WAIT;
                asw_ack_o_w = 1;
            end
        end
        ASW_WAIT: begin
            if (wbs_ack_o) begin
            	asw_state_w = ASW_IDLE;
            end
        end
    endcase
end

// axi_stream_read FSM
parameter  ASR_IDLE = 4'd0;
parameter  ASR_DATA = 4'd1;
parameter  ASR_WAIT = 4'd2;
reg  [3:0] asr_state_r, asr_state_w;
reg        asr_ack_o_r, asr_ack_o_w;
reg [31:0] asr_dat_o_r, asr_dat_o_w;
always @(*) begin
    asr_state_w = asr_state_r;
    sm_tready_w = 0;
    asr_ack_o_w = 0;
    asr_dat_o_w = asr_dat_o_r;
    case (asr_state_r)
        ASR_IDLE: begin
            if (wb_axi_stream_read) begin
                asr_state_w = ASR_DATA;
                sm_tready_w = 1;
            end
        end
        ASR_DATA: begin
            sm_tready_w = 1;
            if (sm_tready && sm_tvalid) begin
                sm_tready_w = 0;
                asr_state_w = ASR_WAIT;
                asr_ack_o_w = 1;
                asr_dat_o_w = sm_tdata[31:0];
            end
        end
        ASR_WAIT: begin
            if (wbs_ack_o) begin
                asr_state_w = ASR_IDLE;
            end
        end
    endcase
end

// output signals
always @(*) begin
    wbs_ack_o_w = (alw_ack_o_r || alr_ack_o_r || asw_ack_o_r || asr_ack_o_r);
    wbs_dat_o_w = (alr_ack_o_r) ? alr_dat_o_r : asr_dat_o_r;
end



always @(posedge wb_clk_i or posedge wb_rst_i) begin
    if (wb_rst_i) begin
        alr_state_r <= ALR_IDLE;
        arvalid_r <= 0;
        araddr_r <= 0;
        rready_r <= 0;
        alr_ack_o_r <= 0;
        alr_dat_o_r <= 0;
        
        alw_state_r <= ALW_IDLE;
        awvalid_r <= 0;
        wvalid_r <= 0;
        awaddr_r <= 0;
        wdata_r <= 0;
        alw_ack_o_r <= 0;

        asw_state_r <= ASW_IDLE;
        ss_tvalid_r <= 0;
        ss_tdata_r <= 0;
        asw_ack_o_r <= 0;

        asr_state_r <= ASR_IDLE;
        sm_tready_r <= 0;
        asr_ack_o_r <= 0;
        asr_dat_o_r <= 0;

        wbs_ack_o_r <= 0;
        wbs_dat_o_r <= 0;
    end
    else begin
        alr_state_r <= alr_state_w;
        arvalid_r <= arvalid_w;
        araddr_r <= araddr_w;
        rready_r <= rready_w;
        alr_ack_o_r <= alr_ack_o_w;
        alr_dat_o_r <= alr_dat_o_w;

        alw_state_r <= alw_state_w;
        awvalid_r <= awvalid_w;
        wvalid_r <= wvalid_w;
        awaddr_r <= awaddr_w;
        wdata_r <= wdata_w;
        alw_ack_o_r <= alw_ack_o_w;

        asw_state_r <= asw_state_w;
        ss_tvalid_r <= ss_tvalid_w;
        ss_tdata_r <= ss_tdata_w;
        asw_ack_o_r <= asw_ack_o_w;

        asr_state_r <= asr_state_w;
        sm_tready_r <= sm_tready_w;
        asr_ack_o_r <= asr_ack_o_w;
        asr_dat_o_r <= asr_dat_o_w;

        wbs_ack_o_r <= wbs_ack_o_w;
        wbs_dat_o_r <= wbs_dat_o_w;
    end
end

endmodule
