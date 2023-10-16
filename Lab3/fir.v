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
    input   wire                     axis_rst_n,
    output  wire test
);
assign test = arready_w;
parameter IDLE  = 0;
parameter READ  = 1;
parameter CAL   = 2;
parameter DONE  = 3;
 
reg                         awready_r, awready_w;
reg                         wready_r, wready_w;
reg                         arready_r, arready_w;
reg                         rvalid_r, rvalid_w;
reg  [(pDATA_WIDTH-1):0]    rdata_r, rdata_w;
reg                         ss_tready_r, ss_tready_w;
reg                         sm_tvalid_r, sm_tvalid_w;
reg  [(pDATA_WIDTH-1):0]    sm_tdata_r, sm_tdata_w;
reg                         sm_tlast_r, sm_tlast_w;
reg  [3:0]                  tap_WE_r, tap_WE_w;
reg                         tap_EN_r, tap_EN_w;
reg  [(pDATA_WIDTH-1):0]    tap_Di_r, tap_Di_w;
reg  [(pADDR_WIDTH-1):0]    tap_A_r, tap_A_w;
reg  [3:0]                  data_WE_r, data_WE_w;
reg                         data_EN_r, data_EN_w;
reg  [(pDATA_WIDTH-1):0]    data_Di_r, data_Di_w;
reg  [(pADDR_WIDTH-1):0]    data_A_r, data_A_w;
reg  [2:0]                  state_r, state_w;
reg  [15:0]                 data_len_r, data_len_w;
reg                         ap_start_r, ap_start_w;
reg                         ap_idle_r, ap_idle_w;
reg                         ap_done_r, ap_done_w;
reg  [(pADDR_WIDTH-1):0]    awaddr_last_r, awaddr_last_w;
reg  [(pDATA_WIDTH-1):0]    wdata_last_r, wdata_last_w;
reg                         data_cnt_r, data_cnt_w;
reg  [3:0]                  data_pnt_r, data_pnt_w;
reg                         awaddr_get_r, awaddr_get_w;
reg                         wdata_get_r, wdata_get_w;
reg  [(pDATA_WIDTH-1):0]    sum_r, sum_w;
reg                         last_r, last_w;
reg                         done_p1_r, done_p1_w;
//delay
reg                         tap_read_d1, tap_read_d2;
reg  [(pDATA_WIDTH-1):0]    tap_Do_d1, data_Do_d1, ss_tdata_d1;
reg                         ss_tready_d1;

wire                        tap_read;

assign tap_read     = arready && arvalid && |(araddr[6:5]);
assign awready      = (ap_idle_r && state_r != DONE) ? 1 : 0; //awready_r;
assign wready       = (ap_idle_r && state_r != DONE) ? 1 : 0; //wready_r;
assign arready      = arready_r;
assign rvalid       = rvalid_r;
assign rdata        = rdata_r;
assign ss_tready    = ss_tready_r;
assign sm_tvalid    = sm_tvalid_r;
assign sm_tdata     = sm_tdata_r;
assign sm_tlast     = sm_tlast_r;
assign tap_WE       = tap_WE_r;
assign tap_EN       = 1; //tap_EN_r;
assign tap_Di       = tap_Di_r;
assign tap_A        = tap_A_r;
assign data_WE      = data_WE_r;
assign data_EN      = 1; //data_EN_r;
assign data_Di      = data_Di_r;
assign data_A       = data_A_r;


reg  [(pADDR_WIDTH-1):0]    awaddr_now;
reg  [(pDATA_WIDTH-1):0]    wdata_now;
reg                         awvalid_ready;
reg                         wvalid_ready;


always @(*) begin
    awready_w       = awready_r;
    wready_w        = wready_r;
    arready_w       = state_r == IDLE ? 1 : arready_r;
    rvalid_w        = 0;
    rdata_w         = rdata_r;
    ss_tready_w     = 0;
    sm_tvalid_w     = 0;
    sm_tdata_w      = sm_tdata_r;
    sm_tlast_w      = sm_tlast_r;
    data_WE_w       = 0;
    data_Di_w       = data_Di_r;
    data_A_w        = data_A_r;
    state_w         = state_r;
    data_cnt_w      = data_cnt_r;
    data_pnt_w      = data_pnt_r;
    tap_WE_w        = 0;
    tap_Di_w        = tap_Di_r;
    tap_A_w         = tap_A_r;
    ap_start_w      = state_r == IDLE ? ap_start_r : 0;
    ap_idle_w       = state_r == DONE ? 1 : ap_start_r ? 0 : ap_idle_r;
    ap_done_w       = done_p1_r ? 1 : ap_done_r;
    awaddr_last_w   = awaddr_last_r;
    wdata_last_w    = wdata_last_r;
    data_len_w      = data_len_r;
    awaddr_get_w    = awaddr_get_r;
    wdata_get_w     = wdata_get_r;
    sum_w           = sum_r;
    done_p1_w       = done_p1_r;
    last_w          = (ss_tlast && ss_tready) ? 1 : last_r;
    // wire
    awaddr_now      = awaddr_last_r;
    wdata_now       = wdata_last_r;
    awvalid_ready   = awvalid && awready;
    wvalid_ready    = wvalid && wready;
    
    // COEF write
    if(awaddr_get_r && wdata_get_r) begin
        awaddr_get_w = 0;
        wdata_get_w = 0;
    end
    if(awvalid_ready) begin
        awaddr_last_w = awaddr;
        awaddr_get_w = 1;//~awaddr_get_r;
        awaddr_now = awaddr;
    end
    if(wvalid_ready) begin
        wdata_last_w = wdata;
        wdata_get_w = 1;//~wdata_get_r;
        wdata_now = wdata;
    end
    if(awaddr_get_w && wdata_get_w) begin
        if(awaddr_now[6:0] == 7'h0) begin
            if(wdata_now[0]) ap_start_w = 1;
        end
        else if(awaddr_now[6:0] == 7'h10) begin
            data_len_w = wdata_now;
        end
        else begin
            tap_WE_w = 4'b1111;
            tap_A_w  = {awaddr_now[7:5]-1'b1, awaddr_now[4:0]}; // - 0x20
            tap_Di_w = wdata_now;
            // data ram set to 0
            /*
            data_A_w = tap_A_w;
            data_Di_w = 0;
            data_WE_w = 4'b1111;
            */
        end
    end
    // COEF read
    else if(arvalid && arready) begin
        arready_w = 0;
        if(araddr[6:0] == 7'h0) begin
            rvalid_w = 1'b1;
            rdata_w = {ap_idle_r, ap_done_r, ap_start_r};
            ap_done_w = 0;
        end
        else if(araddr[6:0] == 7'h10) begin
            rvalid_w = 1'b1;
            rdata_w = data_len_r;
        end
        else tap_A_w = {araddr[7:5]-1'b1, araddr[4:0]};
    end
    if(tap_read_d2) begin
        rvalid_w = 1'b1;
        rdata_w = tap_Do;
    end
    if(rvalid_r) begin
        if(rready) arready_w = 1;
        else begin
            rvalid_w = 1'b1;
            rdata_w = rdata_r;
        end
    end

    case(state_r)
        IDLE: begin
            data_A_w = data_A_r + 4;
            data_Di_w = 0;
            data_WE_w = 4'b1111;
            if(data_A_r == 6'h28) begin
                data_A_w = data_A_r;
                if(ap_start_r) begin
                    state_w = READ;
                    ss_tready_w = 1;
                end
            end
        end
        READ: begin
            //data_cnt_w = 1;
            if(ss_tready && !ss_tvalid && !last_r) begin
                ss_tready_w = 1;
            end
            else begin
                tap_A_w = 0;
                data_A_w = data_pnt_r << 2;
                data_Di_w = ss_tdata;
                data_WE_w = 4'b1111;
                state_w = CAL;
                if(data_cnt_r) begin
                    sm_tdata_w = sum_r;
                    sm_tvalid_w = 1;
                end
                if(last_r) begin
                    state_w = DONE;
                    done_p1_w = 1;
                end
            end
        end
        CAL: begin
            if(data_cnt_r && sm_tvalid_r && !sm_tready) begin
                sm_tvalid_w = 1;
            end
            else begin
                
                data_cnt_w = 1;
                data_A_w = data_A_r - 3'd4;
                tap_A_w = tap_A_r + 3'd4;
                if(data_A_r[5:0] == 6'h0) data_A_w = 6'h28;
                if(tap_A_r[5:0] == 6'h28) begin
                    state_w = READ;
                    ss_tready_w = 1;
                    tap_A_w = 0;
                    data_pnt_w = data_pnt_r + 1;
                    if(data_pnt_r == Tape_Num-1) data_pnt_w = 0;
                end

                if(tap_A_r[5:0] == 6'h0) sum_w = 0;
                else sum_w = sum_r + (tap_Do * (tap_A_r[5:0] == 6'h4 ? data_Di : data_Do));
            end
        end
        DONE: begin
            done_p1_w = 0;
            state_w = IDLE;
            last_w = 0;
            data_cnt_w = 0;
            data_pnt_w = 0;
            data_A_w = 0;
        end
    endcase
    
end

always @(posedge axis_clk or negedge axis_rst_n) begin
    if(!axis_rst_n) begin
        awready_r       <= 0;
        wready_r        <= 0;
        arready_r       <= 0;
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
        ap_idle_r       <= 1;
        ap_done_r       <= 0;
        awaddr_last_r   <= 0;
        wdata_last_r    <= 0;
        data_cnt_r      <= 0;
        data_pnt_r      <= 0;
        awaddr_get_r    <= 0;
        wdata_get_r     <= 0;
        sum_r           <= 0;
        done_p1_r       <= 0;
        last_r          <= 0;
        tap_read_d1     <= 0;
        tap_read_d2     <= 0;
        tap_Do_d1       <= 0;
        data_Do_d1      <= 0;
        ss_tdata_d1     <= 0;
        ss_tready_d1    <= 0;
    end
    else begin
        awready_r       <= awready_w;
        wready_r        <= wready_w;
        arready_r       <= arready_w;
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
        ap_idle_r       <= ap_idle_w;
        ap_done_r       <= ap_done_w;
        awaddr_last_r   <= awaddr_last_w;
        wdata_last_r    <= wdata_last_w;
        data_cnt_r      <= data_cnt_w;
        data_pnt_r      <= data_pnt_w;
        awaddr_get_r    <= awaddr_get_w;
        wdata_get_r     <= wdata_get_w;
        sum_r           <= sum_w;
        done_p1_r       <= done_p1_w;
        last_r          <= last_w;
        tap_read_d1     <= tap_read;
        tap_read_d2     <= tap_read_d1;
        tap_Do_d1       <= tap_Do;
        data_Do_d1      <= data_Do;
        ss_tdata_d1     <= ss_tdata;
        ss_tready_d1    <= ss_tready_r;
    end
end

endmodule
