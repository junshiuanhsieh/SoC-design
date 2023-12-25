// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype wire
/*
 *-------------------------------------------------------------
 *
 * user_project_wrapper
 *
 * This wrapper enumerates all of the pins available to the
 * user for the user project.
 *
 * An example user project is provided in this wrapper.  The
 * example should be removed and replaced with the actual
 * user project.
 *
 *-------------------------------------------------------------
 */

module user_project_wrapper #(
    parameter BITS = 32
) (
`ifdef USE_POWER_PINS
    inout vdda1,	// User area 1 3.3V supply
    inout vdda2,	// User area 2 3.3V supply
    inout vssa1,	// User area 1 analog ground
    inout vssa2,	// User area 2 analog ground
    inout vccd1,	// User area 1 1.8V supply
    inout vccd2,	// User area 2 1.8v supply
    inout vssd1,	// User area 1 digital ground
    inout vssd2,	// User area 2 digital ground
`endif

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,
    input wb_rst_i,
    input wbs_stb_i,
    input wbs_cyc_i,
    input wbs_we_i,
    input [3:0] wbs_sel_i,
    input [31:0] wbs_dat_i,
    input [31:0] wbs_adr_i,
    output wbs_ack_o,
    output [31:0] wbs_dat_o,

    // Logic Analyzer Signals
    input  [127:0] la_data_in,
    output [127:0] la_data_out,
    input  [127:0] la_oenb,

    // IOs
    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb,

    // Analog (direct connection to GPIO pad---use with caution)
    // Note that analog I/O is not available on the 7 lowest-numbered
    // GPIO pads, and so the analog_io indexing is offset from the
    // GPIO indexing by 7 (also upper 2 GPIOs do not have analog_io).
    inout [`MPRJ_IO_PADS-10:0] analog_io,

    // Independent clock (on independent integer divider)
    input   user_clock2,

    // User maskable interrupt signals
    output [2:0] user_irq
);



wire addr3 = (wbs_adr_i[31:28] == 4'd3);
wire 		wbs_ack_mprj, wbs_ack_uart, wbs_ack_fir;
wire [31:0]	wbs_dat_mprj, wbs_dat_uart, wbs_dat_fir;
wire [127:0]	la_data_mprj, la_data_uart, la_data_fir;
wire [2:0]	irq_mprj, irq_uart, irq_fir;
wire [`MPRJ_IO_PADS-1:0] io_out_mprj, io_out_uart, io_out_fir;
wire [`MPRJ_IO_PADS-1:0] io_oeb_mprj, io_oeb_uart, io_oeb_fir;

assign wbs_ack_o = (wbs_cyc_i && wbs_stb_i) ? out_valid_1 || wbs_ack_uart || wbs_ack_fir : 0;
assign wbs_dat_o = wbs_adr_i[27] ? out_data_1 : (wbs_adr_i[9:8]==0) ? wbs_dat_uart : wbs_dat_fir;
// assign      wbs_dat_o = (1'b1) ? data_out_1;   // todo: decoder to send correct wbs_dat_o back
// assign      wbs_ack_o = (1'b1) ? o_ack_1;
assign user_irq = irq_uart;   //wbs_adr_i[27] ? irq_mprj : irq_uart; 
assign la_data_out = wbs_adr_i[27] ? la_data_mprj : la_data_uart;
assign io_out = io_out_uart;
assign io_oeb = io_oeb_uart;

/*--------------------------------------*/
/* User project is instantiated  here   */
/*--------------------------------------*/

// 3800_0000
/*
user_proj_example mprj (
`ifdef USE_POWER_PINS
	.vccd1(vccd1),	// User area 1 1.8V power
	.vssd1(vssd1),	// User area 1 digital ground
`endif

    .wb_clk_i(wb_clk_i),
    .wb_rst_i(wb_rst_i),

    // MGMT SoC Wishbone Slave

    .wbs_cyc_i(wbs_cyc_i),
    .wbs_stb_i(wbs_stb_i && addr3 && wbs_adr_i[27]),
    .wbs_we_i(wbs_we_i),
    .wbs_sel_i(wbs_sel_i),
    .wbs_adr_i(wbs_adr_i),
    .wbs_dat_i(wbs_dat_i),
    .wbs_ack_o(wbs_ack_mprj),
    .wbs_dat_o(wbs_dat_mprj),

    // Logic Analyzer

    .la_data_in(la_data_in),
    .la_data_out(la_data_mprj),
    .la_oenb (la_oenb),

    // IO Pads

    .io_in (io_in),
    .io_out(io_out_mprj),
    .io_oeb(io_oeb_mprj),

    // IRQ
    .irq(irq_mprj)
);
*/

// 3000_0000
uart uart (
`ifdef USE_POWER_PINS
	.vccd1(vccd1),	// User area 1 1.8V power
	.vssd1(vssd1),	// User area 1 digital ground
`endif
    .wb_clk_i(wb_clk_i),
    .wb_rst_i(wb_rst_i),

    // MGMT SoC Wishbone Slave

    .wbs_stb_i(wbs_stb_i && addr3 && !wbs_adr_i[27] && wbs_adr_i[9:8]==0),
    .wbs_cyc_i(wbs_cyc_i),
    .wbs_we_i(wbs_we_i),
    .wbs_sel_i(wbs_sel_i),
    .wbs_dat_i(wbs_dat_i),
    .wbs_adr_i(wbs_adr_i),
    .wbs_ack_o(wbs_ack_uart),
    .wbs_dat_o(wbs_dat_uart),

    // IO ports
    .io_in  (io_in      ),
    .io_out (io_out_uart),
    .io_oeb (io_oeb_uart),

    // irq
    .user_irq (irq_uart)
);


// axi_lite_write signals 
wire        awready_fir, awready_mm, awready_qs, awready_dma_fir, awready_dma_mm, awready_dma_qs; // i
wire        wready_fir, wready_mm, wready_qs, wready_dma_fir, wready_dma_mm, wready_dma_qs; // i
wire        awvalid, wvalid;
wire [31:0] awaddr;
wire [31:0] wdata;

// axi_lite_read signals
wire        arready_fir, arready_mm, arready_qs, arready_dma_fir, arready_dma_mm, arready_dma_qs; // i
wire        rvalid_fir, rvalid_mm, rvalid_qs, rvalid_dma_fir, rvalid_dma_mm, rvalid_dma_qs; // i
wire        arvalid, rready;
wire [31:0] araddr;
wire [31:0] rdata_fir, rdata_mm, rdata_qs, rdata_dma_fir, rdata_dma_mm, rdata_dma_qs; // i

// axi_stream_write signals
wire        ss_tready_fir, ss_tready_mm, ss_tready_qs; // i
wire        ss_tvalid_fir, ss_tvalid_mm, ss_tvalid_qs;
wire [31:0] ss_tdata_fir, ss_tdata_mm, ss_tdata_qs;
wire [31:0] ss_tdata;


// axi_stream_read signals
wire        sm_tready_fir, sm_tready_mm, sm_tready_qs;
wire        sm_tvalid_fir, sm_tvalid_mm, sm_tvalid_qs; // i
wire [31:0] sm_tdata_fir, sm_tdata_mm, sm_tdata_qs; // i


reg         awready, wready;
reg         arready, rvalid;
reg  [31:0] rdata;
reg         ss_tready, sm_tvalid;
reg  [31:0] sm_tdata;

always @(*) begin
    case(wbs_adr_i[11:8])
        4'd1: begin // fir
            awready   = awready_fir;
            wready    = wready_fir;
            arready   = arready_fir;
            rvalid    = rvalid_fir;
            rdata     = rdata_fir;
            ss_tready = ss_tready_fir;
            sm_tvalid = sm_tvalid_fir;
            sm_tdata  = sm_tdata_fir;
        end
        4'd2: begin // mm
            awready   = awready_mm;
            wready    = wready_mm;
            arready   = arready_mm;
            rvalid    = rvalid_mm;
            rdata     = rdata_mm;
            ss_tready = ss_tready_mm;
            sm_tvalid = sm_tvalid_mm;
            sm_tdata  = sm_tdata_mm;
        end
        4'd3: begin // qs
            awready   = awready_qs;
            wready    = wready_qs;
            arready   = arready_qs;
            rvalid    = rvalid_qs;
            rdata     = rdata_qs;
            ss_tready = ss_tready_qs;
            sm_tvalid = sm_tvalid_qs;
            sm_tdata  = sm_tdata_qs;
        end
        4'hA: begin // dma_fir
            awready   = awready_dma_fir;
            wready    = wready_dma_fir;
            arready   = arready_dma_fir;
            rvalid    = rvalid_dma_fir;
            rdata     = rdata_dma_fir;
            //ss_tready = ss_tready_dma_fir;
            //sm_tvalid = sm_tvalid_dma_fir;
            //sm_tdata  = sm_tdata_dma_fir;
        end
        default: begin // fir
            awready   = 0;
            wready    = 0;
            arready   = 0;
            rvalid    = 0;
            rdata     = 0;
            ss_tready = 0;
            sm_tvalid = 0;
            sm_tdata  = 0;
        end
    endcase
end


wire start = (wbs_cyc_i && wbs_stb_i && wbs_we_i) && addr3 && (!wbs_adr_i[27:10]) && (!wbs_adr_i[7:0]) && wbs_dat_i[0];


wb_to_axi wb_to_axi(  
    .wb_clk_i(wb_clk_i),
    .wb_rst_i(wb_rst_i),
    .wbs_stb_i(wbs_stb_i),
    .wbs_cyc_i(wbs_cyc_i && addr3 && !wbs_adr_i[27:12] && wbs_adr_i[11:8]),
    .wbs_we_i(wbs_we_i),
    .wbs_sel_i(wbs_sel_i),
    .wbs_dat_i(wbs_dat_i),
    .wbs_adr_i(wbs_adr_i),
    .wbs_ack_o(wbs_ack_fir),
    .wbs_dat_o(wbs_dat_fir),
    
    .awready(awready), // i
    .wready(wready), // i
    .awvalid(awvalid),
    .awaddr(awaddr[11:0]),
    .wvalid(wvalid),
    .wdata(wdata),
    .arready(arready), // i
    .rready(rready),
    .arvalid(arvalid),
    .araddr(araddr[11:0]),
    .rvalid(rvalid), // i
    .rdata(rdata), // i
    .ss_tvalid(ss_tvalid), 
    .ss_tdata(ss_tdata), 
    .ss_tready(ss_tready), // i
    .sm_tready(sm_tready), 
    .sm_tvalid(sm_tvalid),  // i
    .sm_tdata(sm_tdata) // i
);


 
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
// 3800_0100
fir inst_fir(
    .awready(awready_fir),
    .wready(wready_fir),
    .awvalid(awvalid && wbs_adr_i[11:8]==4'h1),
    .awaddr(awaddr[11:0]),
    .wvalid(wvalid && wbs_adr_i[11:8]==4'h1),
    .wdata(wdata),
    .arready(arready_fir),
    .rready(rready && wbs_adr_i[11:8]==4'h1),
    .arvalid(arvalid && wbs_adr_i[11:8]==4'h1),
    .araddr(araddr[11:0]),
    .rvalid(rvalid_fir),
    .rdata(rdata_fir),    
    .ss_tvalid(ss_tvalid_fir), 
    .ss_tdata(ss_tdata_fir), 
    .ss_tlast(), 
    .ss_tready(ss_tready_fir), 
    .sm_tready(sm_tready_fir), 
    .sm_tvalid(sm_tvalid_fir), 
    .sm_tdata(sm_tdata_fir), 
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

// 3800_0200
matmul inst_mm(
    .clk(wb_clk_i),
    .rst_n(~wb_rst_i),
    .ap_start(start),
    
    .ss_tvalid(ss_tvalid_mm), 
    .ss_tdata(ss_tdata_mm), 
    .ss_tlast(), 
    .ss_tready(ss_tready_mm),
     
    .sm_tready(sm_tready_mm), 
    .sm_tvalid(sm_tvalid_mm), 
    .sm_tdata(sm_tdata_mm), 
    .sm_tlast()
);

// 3800_0300
sort inst_qs(
    .clk(wb_clk_i),
    .rst_n(~wb_rst_i),
    .ap_start(start),
    
    .ss_tvalid(ss_tvalid_qs), 
    .ss_tdata(ss_tdata_qs), 
    .ss_tlast(), 
    .ss_tready(ss_tready_qs),
     
    .sm_tready(sm_tready_qs), 
    .sm_tvalid(sm_tvalid_qs), 
    .sm_tdata(sm_tdata_qs), 
    .sm_tlast()
);

// 1st wishbone access (from cpu)
wire [31:0] addr_1;
wire        rw_1;
wire        in_valid_1;
wire [31:0] in_data_1;
wire        out_valid_1;
wire [31:0] out_data_1;
assign      addr_1 = wbs_adr_i;
assign      rw_1 = wbs_we_i;
assign      in_valid_1 = (wbs_stb_i) && (wbs_cyc_i) && (wbs_sel_i == 4'b1111);
assign      in_data_1 = wbs_dat_i;

// 2nd wishbone access (from fir)
wire [31:0] addr_2;
wire        rw_2;
wire        in_valid_2;
wire [31:0] in_data_2;
wire        out_valid_2;
wire [31:0] out_data_2;

// 3rd wishbone access (from matmul)
wire [31:0] addr_3;
wire        rw_3;
wire        in_valid_3;
wire [31:0] in_data_3;
wire        out_valid_3;
wire [31:0] out_data_3;

// 4th withbone access (from quicksort)
wire [31:0] addr_4;
wire        rw_4;
wire        in_valid_4;
wire [31:0] in_data_4;
wire        out_valid_4;
wire [31:0] out_data_4;

// dma of fir
dma user_dma_fir(
    .awready(awready_dma_fir),
    .wready(wready_dma_fir),
    .awvalid(awvalid && awaddr[11:8] == 4'hA),
    .awaddr(awaddr),
    .wvalid(wvalid && awaddr[11:8] == 4'hA),
    .wdata(wdata),
    
    .arready(arready_dma_fir),
    .rready(rready && araddr[11:8] == 4'hA),
    .arvalid(arvalid && araddr[11:8] == 4'hA),
    .araddr(araddr),
    .rvalid(rvalid_dma_fir),
    .rdata(rdata_dma_fir),
    
    .ss_tvalid(sm_tvalid_fir),
    .ss_tdata(sm_tdata_fir),
    .ss_tlast(),
    .ss_tready(sm_tready_fir),
    
    .sm_tready(ss_tready_fir),
    .sm_tvalid(ss_tvalid_fir),
    .sm_tdata(ss_tdata_fir),
    .sm_tlast(),
    
    .addr(addr_2),
    .rw(rw_2),
    .in_valid(in_valid_2),
    .in_data(in_data_2),
    .out_valid(out_valid_2),
    .out_data(out_data_2),
    
    .axis_clk(wb_clk_i),
    .axis_rst_n(~wb_rst_i)
);

// dma of matmul
dma user_dma_mm(
    .awready(awready_dma_mm),
    .wready(wready_dma_mm),
    .awvalid(awvalid),
    .awaddr(awaddr),
    .wvalid(wvalid),
    .wdata(wdata),
    
    .arready(arready_dma_mm),
    .rready(rready),
    .arvalid(arvalid),
    .araddr(araddr),
    .rvalid(rvalid_dma_mm),
    .rdata(rdata_mm),
    
    .ss_tvalid(sm_tvalid_mm),
    .ss_tdata(sm_tdata_mm),
    .ss_tlast(),
    .ss_tready(sm_tready_mm),
    
    .sm_tready(ss_tready_mm),
    .sm_tvalid(ss_tvalid_mm),
    .sm_tdata(ss_tdata_mm),
    .sm_tlast(),
    
    .addr(addr_3),
    .rw(rw_3),
    .in_valid(in_valid_3),
    .in_data(in_data_3),
    .out_valid(out_valid_3),
    .out_data(out_data_3),
    
    .axis_clk(wb_clk_i),
    .axis_rst_n(~wb_rst_i)
);

// dma of quicksort
dma user_dma_qs(
    .awready(awready_dma_qs),
    .wready(wready_dma_qs),
    .awvalid(awvalid),
    .awaddr(awaddr),
    .wvalid(wvalid),
    .wdata(wdata),
    
    .arready(arready_dma_qs),
    .rready(rready),
    .arvalid(arvalid),
    .araddr(araddr),
    .rvalid(rvalid_dma_qs),
    .rdata(rdata_dma_qs),
    
    .ss_tvalid(sm_tvalid_qs),
    .ss_tdata(sm_tdata_qs),
    .ss_tlast(),
    .ss_tready(sm_tready_qs),
    
    .sm_tready(ss_tready_qs),
    .sm_tvalid(ss_tvalid_qs),
    .sm_tdata(ss_tdata_qs),
    .sm_tlast(),
    
    .addr(addr_4),
    .rw(rw_4),
    .in_valid(valid_4),
    .in_data(in_data_4),
    .out_valid(out_valid_4),
    .out_data(out_data_4),
    
    .axis_clk(wb_clk_i),
    .axis_rst_n(~wb_rst_i)
);

// arbiter
arbiter user_arbiter(
    .clk(wb_clk_i),
    .rst(wb_rst_i),

    .addr_1(addr_1),
    .rw_1(rw_1),
    .in_valid_1(in_valid_1),
    .in_data_1(in_data_1),
    .out_valid_1(out_valid_1),
    .out_data_1(out_data_1),

    .addr_2(addr_2),
    .rw_2(rw_2),
    .in_valid_2(out_valid_2),
    .in_data_2(out_data_2),
    .out_valid_2(in_valid_2),
    .out_data_2(in_data_2),

    .addr_3(addr_3),
    .rw_3(rw_3),
    .in_valid_3(out_valid_3),
    .in_data_3(out_data_3),
    .out_valid_3(in_valid_3),
    .out_data_3(in_data_3),

    .addr_4(addr_4),
    .rw_4(rw_4),
    .in_valid_4(out_valid_4),
    .in_data_4(out_data_4),
    .out_valid_4(in_valid_4),
    .out_data_4(out_data_4)
);


endmodule	// user_project_wrapper

`default_nettype wire
