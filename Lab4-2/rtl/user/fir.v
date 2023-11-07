`timescale 1ns / 1ps
module fir 
#(  parameter pADDR_WIDTH = 12,
    parameter pDATA_WIDTH = 32,
    parameter Tape_Num    = 11
)
(
    // AXI Lite write
    output  wire                     awready,
    output  wire                     wready,
    input   wire                     awvalid,
    input   wire [(pADDR_WIDTH-1):0] awaddr,
    input   wire                     wvalid,
    input   wire [(pDATA_WIDTH-1):0] wdata,
    // AXI lite read
    output  wire                     arready,
    input   wire                     rready,
    input   wire                     arvalid,
    input   wire [(pADDR_WIDTH-1):0] araddr,
    output  wire                     rvalid,
    output  wire [(pDATA_WIDTH-1):0] rdata, 
    // AXI stream slave
    input   wire                     ss_tvalid, 
    input   wire [(pDATA_WIDTH-1):0] ss_tdata, 
    input   wire                     ss_tlast, 
    output  wire                     ss_tready, 
    // AXI stream master
    input   wire                     sm_tready, 
    output  wire                     sm_tvalid, 
    output  wire [(pDATA_WIDTH-1):0] sm_tdata, 
    output  wire                     sm_tlast, 
    
    // bram for tap RAM
    output  wire [3:0]               tap_WE,
    output  wire                     tap_EN,
    output  wire [(pDATA_WIDTH-1):0] tap_Di,
    output  wire [(pADDR_WIDTH-1):0] tap_A,
    input   wire [(pDATA_WIDTH-1):0] tap_Do,

    // bram for data RAM
    output  wire [3:0]               data_WE,
    output  wire                     data_EN,
    output  wire [(pDATA_WIDTH-1):0] data_Di,
    output  wire [(pADDR_WIDTH-1):0] data_A,
    input   wire [(pDATA_WIDTH-1):0] data_Do,

    input   wire                     axis_clk,
    input   wire                     axis_rst_n
);

parameter IDLE  = 0;
parameter CAL   = 1;
parameter DONE  = 2;

reg                         wready_r, wready_w;
reg                         rvalid_r, rvalid_w;
reg  [(pDATA_WIDTH-1):0]    rdata_r, rdata_w;
reg                         ss_tready_r, ss_tready_w;
reg                         sm_tvalid_r, sm_tvalid_w;
reg  [(pDATA_WIDTH-1):0]    sm_tdata_r, sm_tdata_w;
reg                         sm_tlast_r, sm_tlast_w;
reg  [3:0]                  tap_WE_r, tap_WE_w;
reg  [(pDATA_WIDTH-1):0]    tap_Di_r, tap_Di_w;
reg  [(pADDR_WIDTH-1):0]    tap_A_r, tap_A_w;
reg  [3:0]                  data_WE_r, data_WE_w;
reg  [(pDATA_WIDTH-1):0]    data_Di_r, data_Di_w;
reg  [(pADDR_WIDTH-1):0]    data_A_r, data_A_w;
reg  [1:0]                  state_r, state_w;
reg  [15:0]                 data_len_r, data_len_w;
reg                         ap_start_r, ap_start_w;
reg                         ap_done_r, ap_done_w;
reg  [9:0]                  data_cnt_r, data_cnt_w;
reg  [(pDATA_WIDTH-1):0]    sum_r, sum_w;
reg  [(pDATA_WIDTH-1):0]    product_r, product_w;
reg  [(pADDR_WIDTH-1):0]    tap_A_idle;
reg  [(pADDR_WIDTH-1):0]    tap_A_cal;

//delay
reg  [(pDATA_WIDTH-1):0]    tap_Do_d1, data_Do_d1_r, data_Do_d1_w;
reg                         ss_tin_d[0:13];
reg                         tap_read_d1, tap_read_d2;
reg  [5:0]                  data_A_last_r, data_A_last_w;
reg                         sm_stop;

wire                        tap_read;
wire                        ap_idle;

assign ap_idle      = state_r == IDLE;
assign tap_read     = arready && arvalid && araddr[6];
assign awready      = (awvalid && wvalid) ? 1 : 0;
assign wready       = awready;
assign arready      = (state_r == IDLE || !araddr[6]) ? 1 : 0; //state_r == IDLE ? 1 : araddr[6] ? 0 : 1;
assign rvalid       = rvalid_r;
assign rdata        = rdata_r;
assign ss_tready    = ss_tready_r;
assign sm_tvalid    = sm_tvalid_r;
assign sm_tdata     = sm_tdata_r;
assign sm_tlast     = sm_tlast_r;
assign tap_WE       = tap_WE_r;
assign tap_EN       = 1;
assign tap_Di       = tap_Di_r;
assign tap_A        = tap_A_r;
assign data_WE      = data_WE_r;
assign data_EN      = 1;
assign data_Di      = data_Di_r;
assign data_A       = data_A_r;

always @(*) begin
    rvalid_w        = 0;
    rdata_w         = rdata_r;
    tap_A_idle      = 0; //tap_A_r;
    tap_WE_w        = 0;
    tap_Di_w        = tap_Di_r;
    ap_start_w      = state_r == IDLE ? ap_start_r : 0;
    ap_done_w       = state_r == DONE ? 1 : ap_done_r;
    data_len_w      = data_len_r;

    // COEF write
    if((awvalid && awready) && (wvalid && wready)) begin
        if(awaddr[6:0] == 7'h0) begin
            if(wdata[0]) ap_start_w = 1;
        end
        else if(awaddr[6:0] == 7'h10) begin
            data_len_w = wdata;
        end
        else begin
            tap_WE_w = 4'b1111;
            tap_A_idle = awaddr[5:0];
            tap_Di_w = wdata;
        end
    end
    // COEF read
    else if(arvalid && arready) begin
        if(araddr[6:0] == 7'h0) begin
            rvalid_w = 1'b1;
            rdata_w = {ap_idle, ap_done_r, ap_start_r};
            ap_done_w = 0;
        end
        else if(araddr[6:0] == 7'h10) begin
            rvalid_w = 1'b1;
            rdata_w = data_len_r;
        end
        else tap_A_idle = araddr[5:0];
    end
    if(tap_read_d2) begin
        rvalid_w = 1'b1;
        rdata_w = tap_Do;
    end
    if(rvalid_r && !rready) rvalid_w = 1'b1;

end

always @(*) begin
    ss_tready_w     = 0;
    sm_tvalid_w     = (sm_tvalid_r && !sm_tready) ? 1 : 0;
    sm_tdata_w      = sm_tdata_r;
    sm_tlast_w      = sm_tlast_r;
    data_WE_w       = 0;
    data_Di_w       = data_Di_r;
    data_A_w        = data_A_r;
    state_w         = state_r;
    data_cnt_w      = data_cnt_r;
    tap_A_cal       = tap_A_r;
    data_A_last_w   = data_A_last_r;
    sm_stop         = (!sm_tready && sm_tvalid) && (ss_tin_d[11] || ss_tin_d[12]) && !(ss_tready && ss_tvalid);
    
    case(state_r)
        IDLE: begin
            data_A_w = data_A_r + 4;
            data_Di_w = 0;
            data_WE_w = 4'b1111;
            if(data_A_r == 6'h28) begin
                data_A_w = data_A_r;
                if(ap_start_r) begin
                    state_w = CAL;
                    ss_tready_w = 1;
                    data_A_w = 0;
                end
            end
        end
        CAL: begin
            if(ss_tready && !ss_tvalid) begin
                ss_tready_w = 1;
            end
            else if(!sm_stop) begin
                data_A_last_w = data_A_r;
                data_A_w = data_A_r[5:0] - 3'd4;
                tap_A_cal = tap_A_r[5:0] + 3'd4;
                if(data_A_r[5:0] == 6'h0) data_A_w = 6'h28;
                if(tap_A_r[5:0] == 6'h28) begin
                    if(data_cnt_r != data_len_r-1) ss_tready_w = 1;
                    tap_A_cal = 0;
                    data_cnt_w = data_cnt_r + 1;
                end
            end

            if(ss_tready && ss_tvalid) begin
                data_WE_w = 4'b1111;
                data_Di_w = ss_tdata;
                tap_A_cal = 0;
                data_A_w = data_A_last_r; 
            end 
            if(ss_tin_d[13]) begin 
                sm_tdata_w = sum_r;
                sm_tvalid_w = 1;
                if(data_cnt_r == data_len_r) state_w = DONE;
            end
        end
        DONE: begin
            state_w = IDLE;
            data_cnt_w = 0;
            data_A_w = 0;
        end
    endcase
end

always @(*) begin
    tap_A_w = (state_r == IDLE && !ap_start_r) ? tap_A_idle : tap_A_cal;
    data_Do_d1_w = tap_A_r[5:0] == 6'h4 ? data_Di : data_Do;
    product_w = tap_Do_d1 * data_Do_d1_r;
    sum_w = ss_tin_d[2] ? 0 : sum_r + product_r; 
end

integer i;
always @(posedge axis_clk or negedge axis_rst_n) begin
    if(!axis_rst_n) begin
        for(i = 0; i < 14; i = i + 1) ss_tin_d[i] <= 0;
    end
    else begin
        ss_tin_d[0] <= sm_stop ? ss_tin_d[0] : ss_tready && ss_tvalid;
        for(i = 1; i < 14; i = i + 1) ss_tin_d[i] <= sm_stop ? ss_tin_d[i] : ss_tin_d[i-1];
    end
end

always @(posedge axis_clk or negedge axis_rst_n) begin
    if(!axis_rst_n) begin
        rvalid_r        <= 0;
        rdata_r         <= 0;
        ss_tready_r     <= 0;
        sm_tvalid_r     <= 0;
        sm_tdata_r      <= 0;
        sm_tlast_r      <= 0;
        tap_WE_r        <= 0;
        tap_Di_r        <= 0;
        tap_A_r         <= 0;
        data_WE_r       <= 0;
        data_Di_r       <= 0;
        data_A_r        <= 0;
        state_r         <= 0;
        data_len_r      <= 0;
        ap_start_r      <= 0;
        ap_done_r       <= 0;
        data_cnt_r      <= 0;
        sum_r           <= 0;
        product_r       <= 0;
        tap_Do_d1       <= 0;
        data_Do_d1_r    <= 0;
        tap_read_d1     <= 0;
        tap_read_d2     <= 0;
        data_A_last_r   <= 0;
    end
    else begin
        rvalid_r        <= rvalid_w;
        rdata_r         <= rdata_w;
        ss_tready_r     <= ss_tready_w;
        sm_tvalid_r     <= sm_tvalid_w;
        sm_tdata_r      <= sm_tdata_w;
        sm_tlast_r      <= sm_tlast_w;
        tap_WE_r        <= tap_WE_w;
        tap_Di_r        <= tap_Di_w;
        tap_A_r         <= tap_A_w;
        data_WE_r       <= data_WE_w;
        data_Di_r       <= data_Di_w;
        data_A_r        <= data_A_w;
        state_r         <= state_w;
        data_len_r      <= data_len_w;
        ap_start_r      <= ap_start_w;
        ap_done_r       <= ap_done_w;
        data_cnt_r      <= data_cnt_w;
        sum_r           <= sum_w;
        product_r       <= product_w;
        tap_Do_d1       <= tap_Do;
        data_Do_d1_r    <= data_Do_d1_w;
        tap_read_d1     <= tap_read;
        tap_read_d2     <= tap_read_d1;
        data_A_last_r   <= data_A_last_w;
    end
end

endmodule
