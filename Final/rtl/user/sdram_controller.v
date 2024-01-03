module sdram_controller (
    input           clk,
    input           rst,

    output          sdram_cle,
    output          sdram_cs,
    output          sdram_cas,
    output          sdram_ras,
    output          sdram_we,
    output          sdram_dqm,
    output   [1:0]  sdram_ba,
    output  [12:0]  sdram_a,
    input   [31:0]  sdram_dqi,
    output  [31:0]  sdram_dqo,

    input   [22:0]  user_addr,  
    input           rw,               
    input   [31:0]  data_in,   
    output  [31:0]  data_out,    
    output          busy,              
    input           in_valid,           
    output          out_valid           
);

// SDRAM Timing  
localparam tCASL         = 13'd2;       
localparam tPRE          = 13'd2;       
localparam tACT          = 13'd2;       
localparam tREF          = 13'd6;       
localparam tRef_Counter  = 10'd750;

// Commands for the SDRAM
localparam CMD_UNSELECTED    = 4'b1000;
localparam CMD_NOP           = 4'b0111;
localparam CMD_ACTIVE        = 4'b0011;
localparam CMD_READ          = 4'b0101;
localparam CMD_WRITE         = 4'b0100;
localparam CMD_TERMINATE     = 4'b0110;
localparam CMD_PRECHARGE     = 4'b0010;
localparam CMD_REFRESH       = 4'b0001;
localparam CMD_LOAD_MODE_REG = 4'b0000;

// states for FSM
parameter INIT = 4'd0;
parameter WAIT = 4'd1;
parameter PRECHARGE_INIT = 4'd2;
parameter REFRESH_INIT_1 = 4'd3;
parameter REFRESH_INIT_2 = 4'd4;
parameter LOAD_MODE_REG = 4'd5;
parameter IDLE = 4'd6;
parameter REFRESH = 4'd7;
parameter ACTIVATE = 4'd8;
parameter READ = 4'd9;
parameter READ_RES = 4'd10;
parameter WRITE = 4'd11;
parameter PRECHARGE = 4'd12;

// SDRAM signals
reg        cle_r, cle_w;
reg        dqm_r, dqm_w;
reg  [3:0] cmd_r, cmd_w;
reg  [1:0] ba_r, ba_w;
reg [12:0] a_r, a_w;
reg [31:0] dq_r, dq_w;
reg [31:0] dqi_r, dqi_w;
reg        dq_en_r, dq_en_w;

assign sdram_cle = cle_r;
assign sdram_cs = cmd_r[3];
assign sdram_ras = cmd_r[2];
assign sdram_cas = cmd_r[1];
assign sdram_we = cmd_r[0];
assign sdram_dqm = dqm_r;
assign sdram_ba = ba_r;
assign sdram_a = a_r;
assign sdram_dqo = dq_en_r ? dq_r : 32'hZZZZZZZZ;

// signals
reg  [3:0] state_r, state_w, next_state_r, next_state_w;
reg        ready_r, ready_w;
reg        start_r, start_w;
reg [22:0] addr_r, addr_w;
reg [31:0] data_r, data_w;
reg        rw_r, rw_w;
reg        out_valid_r, out_valid_w;

reg [15:0] delay_cnt_r, delay_cnt_w;
reg  [9:0] refresh_cnt_r, refresh_cnt_w;
reg        refresh_flag_r, refresh_flag_w;

reg  [3:0] row_open_r, row_open_w;
reg [12:0] row_addr_r[3:0], row_addr_w[3:0];
reg  [2:0] precharge_bank_r, precharge_bank_w;

integer    i;

assign data_out = data_r;
assign busy = !ready_r;
assign out_valid = out_valid_r;


// Cache implementation
reg [31:0] cache_r[0:1], cache_w[0:1];
reg [22:0] cache_addr_r[0:1], cache_addr_w[0:1];
reg  [1:0] cache_cnt_r[0:1], cache_cnt_w[0:1]; 
wire [22:0] prefetch_addr;
assign prefetch_addr = addr_w + 4'd8;

// expand signals for deubgging
wire [31:0] cache0, cache1;
wire [22:0] cache_addr0, cache_addr1;
wire  [1:0] cache_cnt0, cache_cnt1;
assign cache0      = cache_r[0];
assign cache1      = cache_r[1];
assign cache_addr0 = cache_addr_r[0];
assign cache_addr1 = cache_addr_r[1];
assign cache_cnt0  = cache_cnt_r[0];
assign cache_cnt1  = cache_cnt_r[1];

always @(*) begin
    // Default values
    cle_w = cle_r;
    dqm_w = 1'b0;
    cmd_w = CMD_NOP;
    ba_w = 2'd0;
    a_w = 13'd0;
    dq_w = dq_r;
    dqi_w = sdram_dqi;
    dq_en_w = 1'b0;
    
    state_w = state_r;
    next_state_w = next_state_r;
    ready_w = ready_r;
    start_w = start_r;
    addr_w = addr_r;
    data_w = data_r;
    rw_w = rw_r;
    out_valid_w = 1'b0;
    
    delay_cnt_w = delay_cnt_r;
    refresh_cnt_w = (refresh_cnt_r > tRef_Counter) ? 10'd0 : (refresh_cnt_r + 1);
    refresh_flag_w = (refresh_cnt_r > tRef_Counter) ? 1'b1 : refresh_flag_r;
    
    row_open_w = row_open_r;
    for (i=0; i<4; i=i+1) row_addr_w[i] = row_addr_r[i];
    precharge_bank_w = precharge_bank_r;
    
    for (i=0; i<2; i=i+1) begin
        cache_w[i] = (cache_cnt_r[i] == 0) ? sdram_dqi : cache_r[i];
        cache_addr_w[i] = cache_addr_r[i];
        cache_cnt_w[i] = (cache_cnt_r[i] == 3 || cache_cnt_r[i] == 0) ? 2'd3 : (cache_cnt_r[i] - 1);
    end
    
    // FSM
    case (state_r)
        //// INIT ////
        INIT: begin
            cle_w = 1'b1;
            a_w = {3'b000, 1'b0, 2'b00, 3'b010, 1'b0, 3'b010};
            state_w = WAIT;
            next_state_w = IDLE;
            ready_w = 1'b1;
            delay_cnt_w = 16'd0;
            refresh_flag_w = 1'b0;
            refresh_cnt_w = 10'b1;            
            row_open_w = 4'b0;
        end
        
        //// WAIT ////
        WAIT: begin
            delay_cnt_w = delay_cnt_r - 1'b1;
            if (delay_cnt_r == 13'd0) begin
                state_w = next_state_r;
            end
        end
        
        //// IDLE ////
        IDLE: begin
            if (ready_r && in_valid) begin
	    	start_w = 1'd1;
	    	addr_w = user_addr;
	    	data_w = data_in;
	    	rw_w = rw;
            end
            if (refresh_flag_r) begin // we need to do a refresh
                ready_w = 1'b0;
                state_w = PRECHARGE;
                next_state_w = REFRESH;
                precharge_bank_w = 3'b100; // all banks
                refresh_flag_w = 1'b0; // clear the refresh flag
            end 
            else if ((ready_r && in_valid) || start_r) begin
                start_w = 1'b0;
                ready_w = 1'b0; 

                if (row_open_r[addr_w[9:8]]) begin // the row is already activated
                    if (row_addr_r[addr_w[9:8]] == addr_w[22:10]) begin // the row is already open
                        if (rw_w) // write
                            state_w = WRITE;
                        else begin // read
                            if (cache_addr_r[addr_w[2]] == addr_w[22:0]) begin // the address is in cache
                                out_valid_w = 1'b1;
                                data_w = cache_r[addr_w[2]];
				     
                                // try to prefetch data if its row is also open     
                                if (row_open_r[prefetch_addr[9:8]]) begin
                                    cmd_w = CMD_READ;
                                    a_w = {2'b0, 1'b0, prefetch_addr[7:0], 2'b0};
                                    ba_w = prefetch_addr[9:8];
                                    cache_addr_w[prefetch_addr[2]] = prefetch_addr;
                                    cache_cnt_w[prefetch_addr[2]] = 2;
                                end
                            end
                            else begin // the address is not in cache                 
                                state_w = READ;
                            end
                        end
                    end 
                    else begin // a different row in the bank is open
                        state_w = PRECHARGE; // precharge open row
                        precharge_bank_w = {1'b0, addr_w[9:8]};
                        next_state_w = ACTIVATE; // open current row
                    end
                end 
                else begin // no rows open
                    state_w = ACTIVATE; // open the row
                end
            end
            else if (!ready_r) begin
                ready_w = 1;
            end
        end
        
        //// REFRRESH ////
        REFRESH: begin
            cmd_w = CMD_REFRESH;
            state_w = WAIT;
            delay_cnt_w = tREF;
            next_state_w = IDLE;
        end
        
        //// ACTIVATE ////
        ACTIVATE: begin
            cmd_w = CMD_ACTIVE;
            a_w = addr_r[22:10];
            ba_w = addr_r[9:8];
            delay_cnt_w = tACT;
            state_w = WAIT;
            next_state_w = (rw_r) ? WRITE : READ;
            row_open_w[addr_r[9:8]] = 1'b1; // row is now open
            row_addr_w[addr_r[9:8]] = addr_r[22:10];
        end
        
        //// READ ////
        READ: begin
            cmd_w = CMD_READ;
            a_w = {2'b0, 1'b0, addr_r[7:0], 2'b0};
            ba_w = addr_r[9:8];
            state_w = WAIT;
            delay_cnt_w = tCASL; 
            next_state_w = READ_RES;
        end
        
        //// READ_RES ////
        READ_RES: begin
            data_w = dqi_r; // data_d by pass
            out_valid_w = 1'b1;
            state_w = IDLE;
            if (row_open_w[prefetch_addr[9:8]]) begin
                cmd_w = CMD_READ;
                a_w = {2'b0, 1'b0, prefetch_addr[7:0], 2'b0};
                ba_w = prefetch_addr[9:8];
                cache_addr_w[prefetch_addr[2]] = prefetch_addr;
                cache_cnt_w[prefetch_addr[2]] = 2; 
            end
        end
        
        //// WRITE ////
        WRITE: begin
            cmd_w = CMD_WRITE;
            dq_w = data_r;
            dq_en_w = 1'b1; // enable out bus
            a_w = {2'b0, 1'b0, addr_r[7:0], 2'b00};
            ba_w = addr_r[9:8];
            delay_cnt_w = tCASL; 
            next_state_w = IDLE;
            state_w = WAIT;
        end
        
        ///// PRECHARGE /////
        PRECHARGE: begin
            cmd_w = CMD_PRECHARGE;
            a_w[10] = precharge_bank_r[2]; // all banks
            ba_w = precharge_bank_r[1:0];
            state_w = WAIT;
            delay_cnt_w = tPRE;
    
            if (precharge_bank_r[2]) row_open_w = 4'b0000; // closed all rows
            else                     row_open_w[precharge_bank_r[1:0]] = 1'b0; // closed one row
        end
    endcase
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        cle_r <= 1'b0;
        dqm_r <= 1'b0;
        cmd_r <= CMD_NOP;
        ba_r <= 2'd0;
        a_r <= 13'd0;
        dq_r <= 32'b0;
        dqi_r <= 32'b0;
        dq_en_r <= 1'b0;
    
        state_r <= INIT;
        next_state_r <= INIT;
        ready_r <= 1'b0;
        start_r <= 1'b0;
        addr_r <= 23'b0;
        data_r <= 32'b0;
        rw_r <= 1'b0;
        out_valid_r <= 1'b0;
    
        delay_cnt_r <= 16'b0;
        refresh_cnt_r <= 10'b0;
        refresh_flag_r <= 1'b0;
    
        row_open_r <= 4'b0;
        for (i=0; i<4; i=i+1) row_addr_r[i] <= 23'b0;
        precharge_bank_r <= 3'b0;
    
        for (i=0; i<2; i=i+1) begin
            cache_r[i] <= 32'b0;
            cache_addr_r[i] <= 23'b0;
            cache_cnt_r[i] <= 2'd3;
        end
    end
    else begin
        cle_r <= cle_w;
        dqm_r <= dqm_w;
        cmd_r <= cmd_w;
        ba_r <= ba_w;
        a_r <= a_w;
        dq_r <= dq_w;
        dqi_r <= dqi_w;
        dq_en_r <= dq_en_w;
    
        state_r <= state_w;
        next_state_r <= next_state_w;
        ready_r <= ready_w;
        start_r <= start_w;
        addr_r <= addr_w;
        data_r <= data_w;
        rw_r <= rw_w;
        out_valid_r <= out_valid_w;
    
        delay_cnt_r <= delay_cnt_w;
        refresh_cnt_r <= refresh_cnt_w;
        refresh_flag_r <= refresh_flag_w;
    
        row_open_r <= row_open_w;
        for (i=0; i<4; i=i+1) row_addr_r[i] <= row_addr_w[i];
        precharge_bank_r <= precharge_bank_w;
    
        for (i=0; i<2; i=i+1) begin
            cache_r[i] <= cache_w[i];
            cache_addr_r[i] <= cache_addr_w[i];
            cache_cnt_r[i] <= cache_cnt_w[i];
        end
    end
end

endmodule


