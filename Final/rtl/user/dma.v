`timescale 1ns / 1ps
//`define MPRJ_IO_PADS 32
module dma #(  
    parameter pADDR_WIDTH = 32,
    parameter pDATA_WIDTH = 32,
    parameter anse_Num    = 11,
    parameter DATA_SIZE   = 11,
    parameter ANS_SIZE    = 11
) (  
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

    // wb for arbiter
    output  wire [(pADDR_WIDTH-1):0] addr,
    output  wire                     rw,
    output  wire                     out_valid,
    output  wire [(pDATA_WIDTH-1):0] out_data,
    input   wire                     in_valid,
    input   wire [(pDATA_WIDTH-1):0] in_data,

    input   wire                     axis_clk,
    input   wire                     axis_rst_n

); 


    // bram for ans RAM
wire [3:0]               ans_WE;
wire                     ans_EN;
wire [(pDATA_WIDTH-1):0] ans_Di;
wire [(12-1):0] ans_A;
wire [(pDATA_WIDTH-1):0] ans_Do;

    // bram for data RAM
wire [3:0]               data_WE;
wire                     data_EN;
wire [(pDATA_WIDTH-1):0] data_Di;
wire [(12-1):0] data_A;
wire [(pDATA_WIDTH-1):0] data_Do;

wire [11:0] data_ram_addr;
assign data_ram_addr = (state_axi_stream_r > 0)? data_A_w - 12'd4 : data_A - 12'd4;

bram11 #(.SIZE(ANS_SIZE)
) ans_ram (
    .clk(axis_clk),
    .we(|ans_WE),
    .re(ans_EN),
    .waddr(ans_A - 12'd4),
    .raddr(ans_A - 12'd4),
    .wdi(ans_Di),
    .rdo(ans_Do)
);

bram11 #(.SIZE(DATA_SIZE)
) data_ram (
    .clk(axis_clk),
    .we(|data_WE),
    .re(data_EN),
    .waddr(data_ram_addr),
    .raddr(data_ram_addr),
    .wdi(data_Di),
    .rdo(data_Do)
);



// reg                         wready_r, wready_w;
reg                         rvalid_r, rvalid_w;
reg  [(pDATA_WIDTH-1):0]    rdata_r, rdata_w;
// reg                         ss_tready_r, ss_tready_w;
reg                         sm_tvalid_r, sm_tvalid_w;
reg  [(pDATA_WIDTH-1):0]    sm_tdata_r, sm_tdata_w;
reg                         sm_tlast_r, sm_tlast_w;
reg  [3:0]                  ans_WE_r, ans_WE_w;
reg  [(pDATA_WIDTH-1):0]    ans_Di_r, ans_Di_w;
reg  [(pADDR_WIDTH-1):0]    ans_A_r, ans_A_w;
reg  [3:0]                  data_WE_r, data_WE_w;
reg  [(pDATA_WIDTH-1):0]    data_Di_r, data_Di_w;
reg  [(pADDR_WIDTH-1):0]    data_A_r, data_A_w;


reg                        ap_idle_w, ap_idle_r;

assign awready      = 1; // (awvalid && wvalid) ? 1 : 0;
assign wready       = 1; // awready;
assign arready      = 1; // (state_r == IDLE || !araddr[6]) ? 1 : 0; //state_r == IDLE ? 1 : araddr[6] ? 0 : 1;
assign rvalid       = rvalid_r;
assign rdata        = rdata_r;
assign ss_tready    = 1; // ss_tready_r;
assign sm_tvalid    = sm_tvalid_r;
assign sm_tdata     = sm_tdata_r;
assign sm_tlast     = sm_tlast_r;
assign ans_WE       = ans_WE_r;
assign ans_EN       = 1;
assign ans_Di       = ans_Di_r;
assign ans_A        = ans_A_r;
assign data_WE      = data_WE_r;
assign data_EN      = 1;
assign data_Di      = data_Di_r;
assign data_A       = data_A_r;

// axi_lite_read from CPU
parameter DATA_LEN = 32;
parameter ADDR_LEN = 32;
reg [15 : 0] data_len_w, data_len_r, ans_len_w, ans_len_r;
reg [(pADDR_WIDTH-1) : 0] data_addr_w, data_addr_r, ans_addr_w, ans_addr_r;
reg ap_start_w, ap_start_r, ap_done_w, ap_done_r;
reg wb_read_start_w, wb_read_start_r;

// AP        0x30000a00
// DATA_LEN  0x30000a10
// ANS_LEN   0x30000a14
// DATA_ADDR 0x30000a20
// ANS_ADDR  0x30000a24

always @(*) begin
    rvalid_w        = 0;
    rdata_w         = rdata_r;
    // ans_WE_w        = 0;
    // ans_Di_w        = ans_Di_r;
    ap_start_w      = ap_start_r; // state_r == IDLE ? ap_start_r : 0;
    ap_done_w       = ap_done_r; // state_r == DONE ? 1 : ap_done_r;
    data_len_w      = data_len_r; 
    ans_len_w       = ans_len_r;
    data_addr_w     = data_addr_r;
    ans_addr_w      = ans_addr_r;
    ap_idle_w       = ap_idle_r;
    wb_read_start_w = 0;

    if (state_wb_r == 3'd4) ap_done_w = 1;
    // COEF write
    if((awvalid && wvalid)) begin
        if(awaddr[7:4] == 4'h0) begin
            if(wdata[0]) ap_start_w = 1;
        end
        else if(awaddr[7:4] == 4'h1) begin
            if (awaddr[2]) ans_len_w = wdata;
            else data_len_w = wdata;
        end
        else begin
            if (awaddr[2]) ans_addr_w = wdata;
            else begin 
                data_addr_w = wdata;
                wb_read_start_w = 1;
                data_A_w = 0;
                ap_idle_w = 0;
            end
        end
    end
    // COEF read
    else if(arvalid) begin
        if(araddr[7:4] == 4'h0) begin
            rvalid_w = 1'b1;
            rdata_w = {ap_idle_r, ap_done_r, ap_start_r};
            ap_done_w = 0;
        end
    end

end


reg [(pADDR_WIDTH-1):0] addr_w, addr_r;
reg rw_w, rw_r;
reg out_valid_w, out_valid_r;
reg [(pDATA_WIDTH-1):0] out_data_w, out_data_r;
reg [(pADDR_WIDTH-1):0] counter_data_len_w, counter_data_len_r, counter_axi_stream_wdata_len_w, counter_axi_stream_wdata_len_r;
reg [2:0] state_wb_w, state_wb_r, state_axi_stream_w, state_axi_stream_r;
reg end_read_fir_w, end_read_fir_r;

assign addr = addr_r;
assign rw = rw_r;
assign out_valid = out_valid_r;
assign out_data = out_data_r;

always @(*) begin 
    addr_w      = addr_r;
    out_valid_w = 0; // out_valid_r;
    out_data_w  = out_data_r;
    data_WE_w = 0;
    data_Di_w = data_Di_r;
    data_A_w  = data_A_r;
    ans_WE_w = 0;
    ans_Di_w = ans_Di_r;
    ans_A_w  = ans_A_r;
    rw_w = 0;
    counter_data_len_w = counter_data_len_r;
    state_wb_w = state_wb_r;
    state_axi_stream_w = state_axi_stream_r;
    sm_tvalid_w = (sm_tvalid_r && !sm_tready) ? sm_tvalid_r : 0;
    sm_tdata_w = sm_tdata_r;
    counter_axi_stream_wdata_len_w = counter_axi_stream_wdata_len_r;
    sm_tlast_w = sm_tlast_r;
    end_read_fir_w = end_read_fir_r;
    
    // wb to arbiter

    case(state_wb_r)
        3'd0 : begin 
            if (wb_read_start_r) begin 
                addr_w = data_addr_r;
                rw_w = 0;
                out_valid_w = 1;
                //wb_read_start_w = 0;
                //state_wb_w = 1;
            end
            if (in_valid) begin 
                data_WE_w = 4'b1111;
                data_Di_w = in_data;
                data_A_w  = data_A_r + 4; //TODO : initial next
                counter_data_len_w = counter_data_len_r + 1; //TODO : in_valid只會拉高一個cycle嗎
                if (counter_data_len_r == data_len_r - 1) begin 
                    state_wb_w = 3'd1;
                end
                else begin 
                    addr_w = addr_r + 4;
                    rw_w = 0;
                    out_valid_w = 1;
                end
            end
        end
        3'd1 : begin 
            if (end_read_fir_r) begin 
                ans_A_w = 4; //TODO : initial
                state_wb_w = 3'd2;
                counter_data_len_w = 0;
                addr_w = ans_addr_r - 4;
            end
        end
        3'd2 : begin 
            // wait for bram read delay
            state_wb_w = 3'd3;
        end
        3'd3 : begin 
            if (in_valid || (ans_A_r == 4)) begin // TODO : condition? how fast will the in_valid be pulled up since out_valid?
                rw_w = 1;
                ans_A_w = ans_A_r + 4; //TODO : next
                addr_w = addr_r + 4;
                out_valid_w = 1;
                out_data_w = ans_Do;
                counter_data_len_w = counter_data_len_r + 1; 
                if (counter_data_len_r == ans_len_r - 1) begin 
                    state_wb_w = 3'd4;
                end
                else state_wb_w = 3'd2;
            end
        end
        3'd4 : begin 
            state_wb_w = state_wb_r;
        end 
    endcase

    // axi_stream_write to FIR

    case(state_axi_stream_w)
        3'd0 : begin 
            if (counter_data_len_r == data_len_r && state_wb_r == 3'd1) begin 
                //sm_tvalid_w = 1;
                data_A_w = 4; //TODO
                state_axi_stream_w = 3'd1;
            end
        end
        3'd1 : begin 
            // wait for bram read delay
            state_axi_stream_w = 3'd2;
            //sm_tvalid_w = 1; 
        end
        3'd2 : begin
            
            if (sm_tready) begin 
            	data_A_w = data_A_r + 4; //TODO
		 sm_tvalid_w = 1; 
                sm_tdata_w = data_Do;
                
                counter_axi_stream_wdata_len_w = counter_axi_stream_wdata_len_r + 1;
                //sm_tvalid_w = 0;
                if (counter_axi_stream_wdata_len_r == data_len_r - 1) begin 
                    state_axi_stream_w = 3'd3;
                    sm_tlast_w = 1;
                    //sm_tvalid_w = 1; 
                end 
                else state_axi_stream_w = 3'd2;
            end
        end
        3'd3 : begin 
            state_axi_stream_w = state_axi_stream_r;
            //sm_tvalid_w = 0; 
        end

    endcase

    // axi_stream_read from FIR
    
    if (ss_tvalid && !end_read_fir_r) begin 
        ans_WE_w = 4'b1111;
        ans_Di_w = ss_tdata;
        ans_A_w = ans_A_r + 4; //TODO NEXT ADDR + 4 ?
        if(ans_A_r == (ans_len_r - 1) * 4) begin 
            end_read_fir_w = 1;
        end
    end
   

end




always @(posedge axis_clk or negedge axis_rst_n) begin
    if(!axis_rst_n) begin
        rvalid_r        <= 0;
        rdata_r         <= 0;

        sm_tvalid_r     <= 0;
        sm_tdata_r      <= 0;
        sm_tlast_r      <= 0;
        ans_WE_r        <= 0;
        ans_Di_r        <= 0;
        ans_A_r         <= 0;
        data_WE_r       <= 0;
        data_Di_r       <= 0;
        data_A_r        <= 0;

        data_len_r      <= 0;
        ans_len_r       <= 0;
        ap_start_r      <= 0;
        ap_done_r       <= 0;
        ap_idle_r	 <= 1;
        
        data_addr_r     <= 0;
        ans_addr_r      <= 0;
        wb_read_start_r <= 0;
        addr_r          <= 0;
        rw_r            <= 0;
        out_valid_r     <= 0;
        out_data_r      <= 0;
        counter_data_len_r <= 0;
        counter_axi_stream_wdata_len_r <= 0;
        state_wb_r <= 0;
        state_axi_stream_r <= 0;
        end_read_fir_r <= 0;
    end
    else begin
        rvalid_r        <= rvalid_w;
        rdata_r         <= rdata_w;

        sm_tvalid_r     <= sm_tvalid_w;
        sm_tdata_r      <= sm_tdata_w;
        sm_tlast_r      <= sm_tlast_w;
        ans_WE_r        <= ans_WE_w;
        ans_Di_r        <= ans_Di_w;
        ans_A_r         <= ans_A_w;
        data_WE_r       <= data_WE_w;
        data_Di_r       <= data_Di_w;
        data_A_r        <= data_A_w;
       
        data_len_r      <= data_len_w;
        ans_len_r      <= ans_len_w;

        ap_start_r      <= ap_start_w;
        ap_done_r       <= ap_done_w;
        ap_idle_r	 <= ap_idle_w;
        
        data_addr_r     <= data_addr_w;
        ans_addr_r      <= ans_addr_w;
        wb_read_start_r <= wb_read_start_w;
        addr_r          <= addr_w;
        rw_r            <= rw_w;
        out_valid_r     <= out_valid_w;
        out_data_r      <= out_data_w;
        counter_data_len_r <= counter_data_len_w;
        counter_axi_stream_wdata_len_r <= counter_axi_stream_wdata_len_w;
        state_wb_r <= state_wb_w;
        state_axi_stream_r <= state_axi_stream_w;
        end_read_fir_r <= end_read_fir_w;
    end
end

endmodule
