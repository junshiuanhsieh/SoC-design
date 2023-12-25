// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.1 (lin64) Build 3526262 Mon Apr 18 15:47:01 MDT 2022
// Date        : Thu Dec  7 03:07:45 2023
// Host        : ubuntu2004 running 64-bit Ubuntu 20.04.4 LTS
// Command     : write_verilog -force -mode funcsim
//               /home/ubuntu/SoC/lab6/Lab6/vivado/vvd_caravel_fpga/vvd_caravel_fpga.gen/sources_1/bd/design_1/ip/design_1_blk_mem_gen_0_0/design_1_blk_mem_gen_0_0_sim_netlist.v
// Design      : design_1_blk_mem_gen_0_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "design_1_blk_mem_gen_0_0,blk_mem_gen_v8_4_5,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_5,Vivado 2022.1" *) 
(* NotValidForBitStream *)
module design_1_blk_mem_gen_0_0
   (clka,
    rsta,
    ena,
    wea,
    addra,
    dina,
    douta,
    clkb,
    rstb,
    enb,
    web,
    addrb,
    dinb,
    doutb,
    rsta_busy,
    rstb_busy);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE BRAM_CTRL, READ_WRITE_MODE READ_WRITE, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA RST" *) input rsta;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input ena;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [3:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [31:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [31:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [31:0]douta;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTB, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE BRAM_CTRL, READ_WRITE_MODE READ_WRITE, READ_LATENCY 1" *) input clkb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB RST" *) input rstb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB EN" *) input enb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB WE" *) input [3:0]web;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB ADDR" *) input [31:0]addrb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DIN" *) input [31:0]dinb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DOUT" *) output [31:0]doutb;
  output rsta_busy;
  output rstb_busy;

  wire [31:0]addra;
  wire [31:0]addrb;
  wire clka;
  wire clkb;
  wire [31:0]dina;
  wire [31:0]dinb;
  wire [31:0]douta;
  wire [31:0]doutb;
  wire ena;
  wire enb;
  wire rsta;
  wire rsta_busy;
  wire rstb;
  wire rstb_busy;
  wire [3:0]wea;
  wire [3:0]web;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire [31:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [31:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [31:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "32" *) 
  (* C_ADDRB_WIDTH = "32" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "8" *) 
  (* C_COMMON_CLK = "0" *) 
  (* C_COUNT_18K_BRAM = "0" *) 
  (* C_COUNT_36K_BRAM = "2" *) 
  (* C_CTRL_ECC_ALGO = "NONE" *) 
  (* C_DEFAULT_DATA = "0" *) 
  (* C_DISABLE_WARN_BHV_COLL = "0" *) 
  (* C_DISABLE_WARN_BHV_RANGE = "0" *) 
  (* C_ELABORATION_DIR = "./" *) 
  (* C_ENABLE_32BIT_ADDRESS = "1" *) 
  (* C_EN_DEEPSLEEP_PIN = "0" *) 
  (* C_EN_ECC_PIPE = "0" *) 
  (* C_EN_RDADDRA_CHG = "0" *) 
  (* C_EN_RDADDRB_CHG = "0" *) 
  (* C_EN_SAFETY_CKT = "1" *) 
  (* C_EN_SHUTDOWN_PIN = "0" *) 
  (* C_EN_SLEEP_PIN = "0" *) 
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     10.7492 mW" *) 
  (* C_FAMILY = "zynq" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "1" *) 
  (* C_HAS_ENB = "1" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_REGCEA = "0" *) 
  (* C_HAS_REGCEB = "0" *) 
  (* C_HAS_RSTA = "1" *) 
  (* C_HAS_RSTB = "1" *) 
  (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) 
  (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
  (* C_INITA_VAL = "0" *) 
  (* C_INITB_VAL = "0" *) 
  (* C_INIT_FILE = "NONE" *) 
  (* C_INIT_FILE_NAME = "no_coe_file_loaded" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "0" *) 
  (* C_MEM_TYPE = "2" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "2048" *) 
  (* C_READ_DEPTH_B = "2048" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "32" *) 
  (* C_READ_WIDTH_B = "32" *) 
  (* C_RSTRAM_A = "0" *) 
  (* C_RSTRAM_B = "0" *) 
  (* C_RST_PRIORITY_A = "CE" *) 
  (* C_RST_PRIORITY_B = "CE" *) 
  (* C_SIM_COLLISION_CHECK = "ALL" *) 
  (* C_USE_BRAM_BLOCK = "1" *) 
  (* C_USE_BYTE_WEA = "1" *) 
  (* C_USE_BYTE_WEB = "1" *) 
  (* C_USE_DEFAULT_DATA = "0" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_SOFTECC = "0" *) 
  (* C_USE_URAM = "0" *) 
  (* C_WEA_WIDTH = "4" *) 
  (* C_WEB_WIDTH = "4" *) 
  (* C_WRITE_DEPTH_A = "2048" *) 
  (* C_WRITE_DEPTH_B = "2048" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "32" *) 
  (* C_WRITE_WIDTH_B = "32" *) 
  (* C_XDEVICEFAMILY = "zynq" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  design_1_blk_mem_gen_0_0_blk_mem_gen_v8_4_5 U0
       (.addra({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,addra[12:2],1'b0,1'b0}),
        .addrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,addrb[12:2],1'b0,1'b0}),
        .clka(clka),
        .clkb(clkb),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb(dinb),
        .douta(douta),
        .doutb(doutb),
        .eccpipece(1'b0),
        .ena(ena),
        .enb(enb),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[31:0]),
        .regcea(1'b0),
        .regceb(1'b0),
        .rsta(rsta),
        .rsta_busy(rsta_busy),
        .rstb(rstb),
        .rstb_busy(rstb_busy),
        .s_aclk(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[3:0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_dbiterr(NLW_U0_s_axi_dbiterr_UNCONNECTED),
        .s_axi_injectdbiterr(1'b0),
        .s_axi_injectsbiterr(1'b0),
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[31:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[31:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(1'b0),
        .sleep(1'b0),
        .wea(wea),
        .web(web));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2022.1"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
RgPKnWr9n0dGgttm3akiFhAlfB96usOQYxnEmPhGyTGg1AbizYAjGPWLXBWl50n/d0IA71ci4aJB
wt6mtfyNADm3ZReK7D3mKu037BOgxryoEwwf1kiC6q/PllxsdAgEMfQrfHJ3E2AzSpdYjoxVYito
y0JW6CUDcWvWa4WV0EA=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
M0l6KpOGH3jL8eRt3NCD7e2USYnkg5H9GAnE1PKmnjiouFN3Y8kjWA2PZDAQLm9UW+TsC1HeVlzO
WjNCHkjR/6ubCsIcWfpPZWdIuAenlsyq8Y9l6b8vMj8JSbDEOiFF/GHSbKsn22MJdDJKEhHFK6GV
s8gR2vywRFwG69gIRE4qGhVB+WIg8GJrDpDMYH6lCjMkTrjXuKDUcNlJN3NPLuhJ7tsditwf1pr5
moJRmGpJnip/rGm0g4o4A6ev4CtePjoao8C1wFtzHkERX9oenhh7cGjDMejU5IrLv8NxFnLj1FpB
9MuF1beTU20NI5oAn6zLiLiOtXjf0ghU3AN4DA==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
hAsrUfp6Qgjm8yBjNYTEtQmVQmMxzL8TE/3oiQSxSI3+yEkXAbQCXkT9mo+LCdv+fGECOB0istHd
eLtbsiYbxjxNxYkXiUrRE5O+aSxynIray+uF9DJigTEUZu8JJXUbzxK4DDUu1Lm9tpGps4+Prz1m
0gkj13RT/Y/418s2VTw=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
BP/54Wm/GJmb1jy0bxWJJX4aiKyiWPVh4X3VL30BQrmX4PlEsNKzBJH3Qu8IIYERfnFP0ifAgboa
vypMQ5Ed0BrMePGkWIgT6I8hxJCMFpHdkSK7m1giSKyZzFfTOrVqoNFXE+qdzLfY1J5hBWCvouYo
jllavK4N3gF9FLScH2AUWYVMcVth2QPaTAU2NLnAUNH8kgtBjBfc8/KbPPTznD1QNVqvFstzcbTA
hGQ1ETVPvINQ0KqxxAG5PRhtQD4+pC+hr/Tvk+RSvGyBOfy9zE86OXkJiYs9dSFhNiMFmCPL9DBO
se4OxNNC0/7aBtb1mkSEA9YFDYEb9jS7Jasy2A==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
SnzT9DVH3xlEN8nrr2YrlvTO5qj7L22d7WaBcuKyTaiHoIwwFHrC4HQbfs0TAwkdWcOgmJoATPSF
F6qm0KiddbrlERF3MfKUldeGBJtqLdX+zGw7+3JD7S+HB9dIMOFOHy+IiCZp1/Pz8epKpi238cel
rcVoJQKz406wmXDvOo8KsT+XhRLs9BVCrBErPGGXKYDk6NXAp0duOgQE9DbslzMU83M/kUC7uERV
tQW02240peKQFp2elEZC7Tetvgp0TaFTtJiKN45REi8GQUCKGa85JjNIk1qb/+k95TIIP1xrHirc
6iX7qbwnPetv8TVu2NjkZ0WDEK5RXdOXcxBwHA==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2021_07", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
erkR82V0jX8ytva+9MzEs0c75Z7j7TsgxWRLNAUfbbU28i+U9YzuZlSfYU75M0f9jx1gvxtBrfKv
cNHVdkR+i5zfHDZsDwfMEEBhs8wzDCKqe+eex6BBEvlIOesCPXrr2RozQgaQ1PBh/os2Arfu+873
BjsVxFJkbhpzIqlddOo/XZV9Yi+eih7A7pXXEBR6IL7Poo4Ka49MiVQU0xJrDTm+ddOuMPDRRD7g
dsxS/uzdcBcO2myV6g/7YH/C2Ce9s6+UywJN/0JeXSqwA7bsBqqnfFicVAT0lckLopMLiuzK7dsN
EwhFeqoetciFrDIj9+o0xDMWBZhgNP1u68vURA==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
R+BI65BKLT0I9hEtsxGnDyM5XY9gzULeTPOSDXvd3KWOzZJAx6C0xlbyZcFZhAEG/QIK2yd0wAi6
IUWxyF/sx3HsqKjhVi5KxnpuXDBOZVoj811O7JukedFVmDW7OHGtBkuiJ5X5irw7mfsEKRQmF/1i
V6lj9HYHZEjxtDeZjACsLY4y1QxWalSKT4HIMOHznBLL8dLbGMlS+ZmFuFn0gcwZavVl7gTkTtkf
W0gn01A9ru7NKsf+iLX0kj4dgItPu9N2g02M1vWQ9UUQEVvfV7lUc7GY1suibrD8aEkhH9S7lZ7n
bFsT4qxyvzg8ML6v4g4v7N6VuyhEtgFgNd725Q==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
jNUVKiwH68vHsU54idgvKwaVJcoxTUuxfgrQpbpmM/IpesWA3wHsGzYClwAxkKzw3KRnFyQqTWcZ
yj1EQ2CMBxlJ0kyNbZW8OK8pXzeigToZ0U6Aq3Gy+j7wBbhe83wE1Ygn82sK8dHTEulvaRLn/c5r
ispy1s7jMKIvYNzoUuZrgyBQyfaYmdqUia8XlQjFd+VwzhTXKwzvmaqHWyaHjfBKeCooO7+oUxMG
OJg83W54EVe9ronFQ8Wr9EOL8ia7qelCAgyQe/bC0HHCoMAm8apI7sX23iMR/wMiPP5V2bQzycy+
rBX/+SWkqSeIE1FLm+muFPvrE7iLwJaW8d1fzdFFjAZ5aIXArbWNfwbK8S0TczXc9lEzmpb69rwA
UJIrs4alo81qGQ32UFhjuMQjX75O9Od1HWHDj5PFaT/Ja5Ly+bK8Cc3gfO6dCE81m7d+B2JBZ/Hl
tBA19QuOAYwT2EIPOdpaVtCULb33cWODWu3qQFhZMmDzKTb3kwpcr0LL

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
MnzcA2swaxH1LRacKDou0ZmiiMRETbWIdHgeBgyQz7ILronsXLoB/C20WuFNGEVSiL2/51EZ6MXZ
vMHI8fFcMQCJcuTBDBibUMKv6bXI9s8fTbtrBZppbF/R1icG5JYhqmX4aRnv4W/dxJRjI2L35nLN
Y48E9OfgfkD1sr+IRwx8WEKFmUhuk8dLe0VOK7ywe3XEcneYvrz+HhPj16bGmNfMwNnDgZ3gKKZD
hRnys+jzvAX3HyISrErWXhMKrhWMxXeTNFJCqNQ0LWAVHQYwyKnF5xVpyXSuGNSIrva+QXqOrZBG
3VNLirNVtMRiKLfwZeMaqvswkqBDAa53utlAAA==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
d0xXkKtsKM8GvXhDZr16p1+oE3uBtD04BJ76eGGIEj/CFECfHVy9qsJ43oSKjas0+AJr4GFFnVb6
X7gJV6MmX/OboC9ier5joUCGz0mxVzkRZK9a+LPEDcg0K6+cLE36kr+FfxW9Uk2816EHBCMCf5mK
A4eAhSmAb5Nq74F/q0quiG416npbny7faiQ+xmPDfYYiM3UuMKaD4iE8ODlz1w5xThPllWESf3LZ
NTkw6fozyTqZ47vvE21O3dgIGAY1v+C6BwlCK24VwPJa1xs9csY+qTk31j5jjAc1ExlB6QF7t9UH
lk70qdNPWxT87OH7kFT8UvPO1D6BTC3/WkDZfA==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
LYhdzKTvo93uJrAaiP5OfCDuOnu2BSvPnxlv6I7h2n1+xHtj34LNNKzWEgOg9dUV9cYDaHYUjjEt
DKdWcz6mZ61d5qyxAhpv67fc90v7JVgtOAcT94/Yb+AuLxXFcGA6Gic7uoJtUgz6JmTnb22Dxdjc
KuIewDj4IOTfP8XGXKTaF+cNp0CFrQgTAcVSQFyLFxr0I/9h3S+GZLecA7ntEeHEOfCJzPvy0ddi
7MCdQWECLb+fXC0IAn8V95TumcpINiRAX1BHi9IGJ4QoMrb3jOCrPkFhDMTJj2aiImUWdi/l/0QE
d7wcXlgIEYVeoKYUOJ4mqy+zZPUbLNeOPADUDQ==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 59888)
`pragma protect data_block
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
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
