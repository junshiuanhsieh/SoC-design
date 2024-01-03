module arbiter (
    input           clk,
    input           rst,

    input  [31:0]   addr_1,
    input           rw_1,
    input           in_valid_1,
    input  [31:0]   in_data_1,
    output          out_valid_1,
    output [31:0]   out_data_1,

    input  [31:0]   addr_2,
    input           rw_2,
    input           in_valid_2,
    input  [31:0]   in_data_2,
    output          out_valid_2,
    output [31:0]   out_data_2,

    input  [31:0]   addr_3,
    input           rw_3,
    input           in_valid_3,
    input  [31:0]   in_data_3,
    output          out_valid_3,
    output [31:0]   out_data_3,

    input  [31:0]   addr_4,
    input           rw_4,
    input           in_valid_4,
    input  [31:0]   in_data_4,
    output          out_valid_4,
    output [31:0]   out_data_4
);

reg         out_valid_1_r, out_valid_1_w;
reg  [31:0] out_data_1_r, out_data_1_w;
reg         in_valid_1_r;
assign      out_valid_1 = out_valid_1_r;
assign      out_data_1 = out_data_1_r;

reg         out_valid_2_r, out_valid_2_w;
reg  [31:0] out_data_2_r, out_data_2_w;
reg         in_valid_2_r;
assign      out_valid_2 = out_valid_2_r;
assign      out_data_2 = out_data_2_r;

reg         out_valid_3_r, out_valid_3_w;
reg  [31:0] out_data_3_r, out_data_3_w;
reg         in_valid_3_r;
assign      out_valid_3 = out_valid_3_r;
assign      out_data_3 = out_data_3_r;

reg         out_valid_4_r, out_valid_4_w;
reg  [31:0] out_data_4_r, out_data_4_w;
reg         in_valid_4_r;
assign      out_valid_4 = out_valid_4_r;
assign      out_data_4 = out_data_4_r;

reg  [31:0] addr_r, addr_w;
reg         rw_r, rw_w;
reg  [31:0] in_data_r, in_data_w;
reg         in_valid_r, in_valid_w;
wire [31:0] out_data;
wire        out_valid;

wire        sdram_cle;
wire        sdram_cs;
wire        sdram_cas;
wire        sdram_ras;
wire        sdram_we;
wire        sdram_dqm;
wire  [1:0] sdram_ba;
wire [12:0] sdram_a;
wire [31:0] d2c_data;
wire [31:0] c2d_data;
wire  [3:0] bram_mask;
assign      bram_mask = {4{rw_r}};

sdram_controller user_sdram_controller (
    .clk(clk),
    .rst(rst),
    
    .sdram_cle(sdram_cle),
    .sdram_cs(sdram_cs),
    .sdram_cas(sdram_cas),
    .sdram_ras(sdram_ras),
    .sdram_we(sdram_we),
    .sdram_dqm(sdram_dqm),
    .sdram_ba(sdram_ba),
    .sdram_a(sdram_a),
    .sdram_dqi(d2c_data),
    .sdram_dqo(c2d_data),

    .user_addr(addr_r[22:0]),
    .rw(rw_r),
    .data_in(in_data_r),
    .data_out(out_data),
    .busy(busy),
    .in_valid(in_valid_r),
    .out_valid(out_valid)
);

sdr user_bram (
    .Rst_n(!rst),
    .Clk(clk),
    .Cke(sdram_cle),
    .Cs_n(sdram_cs),
    .Ras_n(sdram_ras),
    .Cas_n(sdram_cas),
    .We_n(sdram_we),
    .Addr(sdram_a),
    .Ba(sdram_ba),
    .Dqm(bram_mask),
    .Dqi(c2d_data),
    .Dqo(d2c_data)
);

wire [3:0] sense_signal;
reg  [3:0] sense_signal_r;
assign sense_signal[0] = (in_valid_1) && (!out_valid_1);
assign sense_signal[1] = (in_valid_2) && (!out_valid_2);
assign sense_signal[2] = (in_valid_3) && (!out_valid_3);
assign sense_signal[3] = (in_valid_4) && (!out_valid_4);

wire [3:0] pos_edge;
assign pos_edge[0] = (sense_signal_r[0] == 0) && (sense_signal[0] == 1);
assign pos_edge[1] = (sense_signal_r[1] == 0) && (sense_signal[1] == 1);
assign pos_edge[2] = (sense_signal_r[2] == 0) && (sense_signal[2] == 1);
assign pos_edge[3] = (sense_signal_r[3] == 0) && (sense_signal[3] == 1);

parameter IDLE = 3'd0;
parameter WRITE = 3'd1;
parameter READ = 3'd2;
parameter WAIT = 3'd3;

reg [3:0]  state_r, state_w;
reg [3:0]  req_type_r, req_type_w;
reg [31:0] req_addr_r[0:3], req_addr_w[0:3];
reg [31:0] req_data_r[0:3], req_data_w[0:3];
reg [2:0]  req_index_r[0:3], req_index_w[0:3];
reg [2:0]  req_cnt_r, req_cnt_w;
integer    i;

always @(*) begin
    // deal with the requests from 4 DMAs and then save them in arrays
    req_type_w = req_type_r;
    for (i=0; i<4; i=i+1) req_addr_w[i] = req_addr_r[i];
    for (i=0; i<4; i=i+1) req_data_w[i] = req_data_r[i];
    for (i=0; i<4; i=i+1) req_index_w[i] = req_index_r[i];
    req_cnt_w = req_cnt_r;

    if (pos_edge[0]) begin
        req_type_w[req_cnt_w] = rw_1;
        req_addr_w[req_cnt_w] = addr_1;
        req_data_w[req_cnt_w] = in_data_1;
        req_index_w[req_cnt_w] = 1;
        req_cnt_w = req_cnt_w + 1;
    end
    if (pos_edge[1]) begin
        req_type_w[req_cnt_w] = rw_2;
        req_addr_w[req_cnt_w] = addr_2;
        req_data_w[req_cnt_w] = in_data_2;
        req_index_w[req_cnt_w] = 2;
        req_cnt_w = req_cnt_w + 1;
    end
    if (pos_edge[2]) begin
        req_type_w[req_cnt_w] = rw_3;
        req_addr_w[req_cnt_w] = addr_3;
        req_data_w[req_cnt_w] = in_data_3;
        req_index_w[req_cnt_w] = 3;
        req_cnt_w = req_cnt_w + 1;
    end
    if (pos_edge[3]) begin
        req_type_w[req_cnt_w] = rw_4;
        req_addr_w[req_cnt_w] = addr_4;
        req_data_w[req_cnt_w] = in_data_4;
        req_index_w[req_cnt_w] = 4;
        req_cnt_w = req_cnt_w + 1;
    end

    // FSM, connect with DRAM
    state_w = state_r;
    rw_w = rw_r;
    addr_w = addr_r;
    in_data_w = in_data_r;
    in_valid_w = in_valid_r;
    out_valid_1_w = 0;
    out_valid_2_w = 0;
    out_valid_3_w = 0;
    out_valid_4_w = 0;
    out_data_1_w = out_data_1_r;
    out_data_2_w = out_data_2_r;
    out_data_3_w = out_data_3_r;
    out_data_4_w = out_data_4_r;

    case (state_r)
        IDLE: begin
            if (req_index_r[0] != 0) begin
                state_w = req_type_r[0] ? WRITE : READ;
                rw_w = req_type_r[0];
                addr_w = req_addr_r[0];
                in_data_w = req_data_r[0];
                in_valid_w = 1;
            end
        end
        WRITE: begin
            if (in_valid_r == 1 && busy == 0) begin
                case (req_index_r[0])
                    3'd1: out_valid_1_w = 1;
                    3'd2: out_valid_2_w = 1;
                    3'd3: out_valid_3_w = 1;
                    3'd4: out_valid_4_w = 1;
                endcase

                state_w = IDLE;
                in_valid_w = 0;
                req_cnt_w = req_cnt_w - 1;
                for (i=0; i<4; i=i+1) begin
                    req_type_w[i] = (i==3) ? 0 : req_type_w[i+1];
                    req_addr_w[i] = (i==3) ? 0 : req_addr_w[i+1];
                    req_data_w[i] = (i==3) ? 0 : req_data_w[i+1];
                    req_index_w[i] = (i==3) ? 0 : req_index_w[i+1];
                end
            end
        end
        READ: begin
            if (in_valid_r == 1 && busy == 0) in_valid_w = 0;
            if (out_valid == 1) begin
                case (req_index_r[0])
                    3'd1: begin
                        out_valid_1_w = 1;
                        out_data_1_w = out_data;
                    end
                    3'd2: begin
                        out_valid_2_w = 1;
                        out_data_2_w = out_data;
                    end
                    3'd3: begin
                        out_valid_3_w = 1;
                        out_data_3_w = out_data;
                    end
                    3'd4: begin
                        out_valid_4_w = 1;
                        out_data_4_w = out_data;
                    end
                endcase

                state_w = IDLE;
                req_cnt_w = req_cnt_w - 1;
                for (i=0; i<3; i=i+1) begin
                    req_type_w[i] = (i==3) ? 0 : req_type_w[i+1];
                    req_addr_w[i] = (i==3) ? 0 : req_addr_w[i+1];
                    req_data_w[i] = (i==3) ? 0 : req_data_w[i+1];
                    req_index_w[i] = (i==3) ? 0 : req_index_w[i+1];
                end
            end
        end
        WAIT: begin
            state_w = IDLE;
        end
    endcase
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        req_type_r <= 0;
        for (i=0; i<4; i=i+1) req_addr_r[i] <= 0;
        for (i=0; i<4; i=i+1) req_data_r[i] <= 0;
        for (i=0; i<4; i=i+1) req_index_r[i] <= 0;
        req_cnt_r <= 0;

        state_r <= IDLE;
        rw_r <= 0;
        addr_r <= 0;
        in_data_r <= 0;
        in_valid_r <= 0;
        out_valid_1_r <= 0;
        out_valid_2_r <= 0;
        out_valid_3_r <= 0;
        out_valid_4_r <= 0;
        out_data_1_r <= 0;
        out_data_2_r <= 0;
        out_data_3_r <= 0;
        out_data_4_r <= 0;
        for (i=0; i<4; i=i+1) sense_signal_r[i] <= 0;
    end
    else begin
        req_type_r <= req_type_w;
        for (i=0; i<4; i=i+1) req_addr_r[i] <= req_addr_w[i];
        for (i=0; i<4; i=i+1) req_data_r[i] <= req_data_w[i];
        for (i=0; i<4; i=i+1) req_index_r[i] <= req_index_w[i];
        req_cnt_r <= req_cnt_w;

        state_r <= state_w;
        rw_r <= rw_w;
        addr_r <= addr_w;
        in_data_r <= in_data_w;
        in_valid_r <= in_valid_w;
        out_valid_1_r <= out_valid_1_w;
        out_valid_2_r <= out_valid_2_w;
        out_valid_3_r <= out_valid_3_w;
        out_valid_4_r <= out_valid_4_w;
        out_data_1_r <= out_data_1_w;
        out_data_2_r <= out_data_2_w;
        out_data_3_r <= out_data_3_w;
        out_data_4_r <= out_data_4_w;
        for (i=0; i<4; i=i+1) sense_signal_r[i] <= sense_signal[i];
    end
end

endmodule
