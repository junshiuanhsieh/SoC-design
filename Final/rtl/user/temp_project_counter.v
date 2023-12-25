`default_nettype wire

module user_proj_example #(
    parameter BITS = 32,
    parameter DELAYS = 10
)(
`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
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

    // IRQ
    output [2:0] irq
);

    wire clk;
    wire rst, rst_n;
    assign clk   = wb_clk_i;
    assign rst_n = !rst;

    // 1st wishbone access (from cpu)
    wire [31:0] addr_1;
    wire        rw_1;
    wire        valid_in_1;
    wire [31:0] data_in_1;
    wire        valid_out_1;
    wire [31:0] data_out_1;
    wire        o_ack_1;
    assign      addr_1 = wbs_adr_i;
    assign      rw_1 = wbs_we_i;
    assign      valid_in_1 = (wbs_stb_i) && (wbs_cyc_i) && (wbs_sel_i == 4'b1111);
    assign      data_in_1 = wbs_dat_i;
    assign      wbs_dat_o = (1'b1) ? data_out_1;   // todo: decoder to send correct wbs_dat_o back
    assign      wbs_ack_o = (1'b1) ? o_ack_1;

    // 2nd wishbone access (from fir)
    wire [31:0] addr_2;
    wire        rw_2;
    wire        valid_in_2;
    wire [31:0] data_in_2;
    wire        valid_out_2;
    wire [31:0] data_out_2;
    wire        o_ack_2;

    // 3rd wishbone access (from matmul)
    wire [31:0] addr_3;
    wire        rw_3;
    wire        valid_in_3;
    wire [31:0] data_in_3;
    wire        valid_out_3;
    wire [31:0] data_out_3;
    wire        o_ack_3;

    // 4th withbone access (from quicksort)
    wire [31:0] addr_4;
    wire        rw_4;
    wire        valid_in_4;
    wire [31:0] data_in_4;
    wire        valid_out_4;
    wire [31:0] data_out_4;
    wire        o_ack_4;

    // dma of fir
    dma_fir user_dma_fir(
        .addr(addr_2),
        .rw(rw_2),
        .valid_in(valid_in_2),
        .data_in(data_in_2),
        .valid_out(valid_out_2),
        .data_out(data_out_2)
    );

    // dma of matmul
    dma_mm user_dma_mm(
        .addr(addr_3),
        .rw(rw_3),
        .valid_in(valid_3),
        .data_in(data_in_3),
        .valid_out(valid_out_3),
        .data_out(data_out_3)
    );

    // dma of quicksort
    dma_qs user_dma_qs(
        .addr(addr_4),
        .rw(rw_4),
        .valid_in(valid_4),
        .data_in(data_in_4),
        .valid_out(valid_out_4),
        .data_out(data_out_4)
    );

    // arbiter
    arbiter user_arbiter(
        .clk(clk),
        .rst(rst),

        .addr_1(addr_1),
        .rw_1(rw_1),
        .valid_in_1(valid_in_1),
        .data_in_1(data_in_1),
        .valid_out_1(valid_out_1),
        .data_out_1(data_out_1),

        .addr_2(addr_2),
        .rw_2(rw_2),
        .valid_in_2(valid_in_2),
        .data_in_2(data_in_2),
        .valid_out_2(valid_out_2),
        .data_out_2(data_out_2),

        .addr_3(addr_3),
        .rw_3(rw_3),
        .valid_in_3(valid_in_3),
        .data_in_3(data_in_3),
        .valid_out_3(valid_out_3),
        .data_out_3(data_out_3),

        .addr_4(addr_4),
        .rw_4(rw_4),
        .valid_in_4(valid_in_4),
        .data_in_4(data_in_4),
        .valid_out_4(valid_out_4),
        .data_out_4(data_out_4)
    );

endmodule

`default_nettype wire