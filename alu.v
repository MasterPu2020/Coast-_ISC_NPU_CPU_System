
module alu

//----------------------------------------------------------------
// Ports
//----------------------------------------------------------------
(
     clk_i
    ,rst_i
    ,mode_sel
    ,alu_i
    ,pc_i
    ,reg_i
    ,imm_i
    ,mem_i
    ,reg_addr_1_i
    ,reg_addr_2_i
    ,reg_addr_3_i
    ,reg_addr_4_i
    ,ram_addr_i
    ,imm_data_1_i
    ,imm_data_2_i
    ,r_ram_data_i
    ,r_reg_data_1_i
    ,r_reg_data_2_i
    ,r_reg_data_3_i
    ,r_reg_data_4_i
    ,r_pc_data_i
    ,en_w_reg_o
    ,en_w_ram_o
    ,w_ram_data_o
    ,w_ram_addr_o
    ,w_reg_data_1_o
    ,w_reg_data_2_o
    ,w_reg_addr_1_o
    ,w_reg_addr_2_o
    ,w_pc_data_o
);

    // Inputs
    input clk_i;
    input rst_i;
    input mode_sel;
    input [7:0] alu_i;
    input [1:0] pc_i;
    input [1:0] reg_i;
    input imm_i;
    input mem_i;
    input [4:0] reg_addr_1_i;
    input [4:0] reg_addr_2_i;
    input [4:0] reg_addr_3_i;
    input [4:0] reg_addr_4_i;
    input [15:0] ram_addr_i;
    input [7:0] imm_data_1_i;
    input [7:0] imm_data_2_i;
    input [7:0] r_ram_data_i;
    input [7:0] r_reg_data_1_i;
    input [7:0] r_reg_data_2_i;
    input [7:0] r_reg_data_3_i;
    input [7:0] r_reg_data_4_i;
    input [15:0] r_pc_data_i;

    // Outputs
    output reg en_w_reg_o;
    output reg en_w_ram_o;
    output reg [7:0] w_ram_data_o;
    output reg [15:0] w_ram_addr_o;
    output reg [7:0] w_reg_data_1_o;
    output reg [7:0] w_reg_data_2_o;
    output reg [4:0] w_reg_addr_1_o;
    output reg [4:0] w_reg_addr_2_o;
    output reg [15:0] w_pc_data_o;

//----------------------------------------------------------------
// Includes
//----------------------------------------------------------------

`include "defs.v"

//----------------------------------------------------------------
// Registers / Wires
//----------------------------------------------------------------

reg [15:0] mul_div_rslt;

//----------------------------------------------------------------
// Circuits
//----------------------------------------------------------------

// Initialization
initial begin
    en_w_reg_o = 0;
    en_w_ram_o = 0;
    w_ram_data_o = 0;
    w_ram_addr_o = 0;
    w_reg_data_1_o = 0;
    w_reg_data_2_o = 0;
    w_reg_addr_1_o = 0;
    w_reg_addr_2_o = 0;
    mul_div_rslt = 0;
    w_pc_data_o = 0;
end

always @(posedge clk_i) begin
    if (rst_i == `RESET) begin
        en_w_reg_o = 0;
        en_w_ram_o = 0;
        w_ram_data_o = 0;
        w_ram_addr_o = 0;
        w_reg_data_1_o = 0;
        w_reg_data_2_o = 0;
        w_reg_addr_1_o = 0;
        w_reg_addr_2_o = 0;
        mul_div_rslt = 0;
        w_pc_data_o = 0;
    end
    else begin
        case(alu_i)
            `ADD: begin
                if (imm_i == `IMM_YES) begin
                    if (imm_data_1_i[7] == 1 && r_reg_data_1_i[7] == 1) begin
                        w_reg_addr_1_o = reg_addr_2_i;
                        w_reg_addr_2_o = `REG_CARRY;
                        w_reg_data_1_o = imm_data_1_i + r_reg_data_1_i;
                        w_reg_data_2_o = `EN_CARRY;
                    end
                    else begin
                        w_reg_addr_1_o = reg_addr_2_i;
                        w_reg_addr_2_o = `REG_CARRY;
                        w_reg_data_1_o = imm_data_1_i + r_reg_data_1_i;
                        w_reg_data_2_o = `DIS_CARRY;
                    end
                end
                else begin
                    if (r_reg_data_2_i[7] == 1 && r_reg_data_1_i[7] == 1) begin
                        w_reg_addr_1_o = reg_addr_3_i;
                        w_reg_addr_2_o = `REG_CARRY;
                        w_reg_data_1_o = r_reg_data_2_i + r_reg_data_1_i;
                        w_reg_data_2_o = `EN_CARRY;
                    end
                    else begin
                        w_reg_addr_1_o = reg_addr_3_i;
                        w_reg_addr_2_o = `REG_CARRY;
                        w_reg_data_1_o = r_reg_data_2_i + r_reg_data_1_i;
                        w_reg_data_2_o = `DIS_CARRY;
                    end
                end
                en_w_reg_o = 1;
                en_w_ram_o = 0;
                w_ram_data_o = 0;
                w_ram_addr_o = 0;
                if (mode_sel == `IMM_INST_sel) begin
                    w_pc_data_o = r_pc_data_i;
                end
                else begin
                    if (r_pc_data_i >= `MAX_ROM_ADDR) begin
                        w_pc_data_o = 0;
                    end
                    else begin
                        w_pc_data_o = r_pc_data_i + 1;
                    end
                end
            end
            `SUB: begin
                if (imm_i == `IMM_YES) begin
                    w_reg_addr_1_o = reg_addr_2_i;
                    w_reg_addr_2_o = `REG_NEG;
                    w_reg_data_1_o = r_reg_data_1_i - imm_data_1_i;
                    if (imm_data_1_i <= r_reg_data_1_i) begin
                        w_reg_data_2_o = `DIS_NEG;
                    end
                    else begin
                        w_reg_data_2_o = `EN_NEG;
                    end
                end
                else begin
                    w_reg_addr_1_o = reg_addr_3_i;
                    w_reg_addr_2_o = `REG_NEG;
                    w_reg_data_1_o = r_reg_data_1_i - r_reg_data_2_i;
                    if (r_reg_data_2_i <= r_reg_data_1_i) begin
                        w_reg_data_2_o = `DIS_NEG;
                    end
                    else begin
                        w_reg_data_2_o = `EN_NEG;
                    end
                end
                en_w_reg_o = 1;
                en_w_ram_o = 0;
                w_ram_data_o = 0;
                w_ram_addr_o = 0;
                if (mode_sel == `IMM_INST_sel) begin
                    w_pc_data_o = r_pc_data_i;
                end
                else begin
                    if (r_pc_data_i >= `MAX_ROM_ADDR) begin
                        w_pc_data_o = 0;
                    end
                    else begin
                        w_pc_data_o = r_pc_data_i + 1;
                    end
                end
            end
            `MUL: begin
                if (imm_i == `IMM_YES) begin
                    w_reg_addr_1_o = `REG_MD_H;
                    w_reg_addr_2_o = `REG_MD_L;
                    mul_div_rslt = r_reg_data_1_i * imm_data_1_i;
                    w_reg_data_1_o = mul_div_rslt[15:8];
                    w_reg_data_2_o = mul_div_rslt[7:0];
                end
                else begin
                    w_reg_addr_1_o = `REG_MD_H;
                    w_reg_addr_2_o = `REG_MD_L;
                    mul_div_rslt = r_reg_data_1_i * r_reg_data_2_i;
                    w_reg_data_1_o = mul_div_rslt[15:8];
                    w_reg_data_2_o = mul_div_rslt[7:0];
                end
                en_w_reg_o = 1;
                en_w_ram_o = 0;
                w_ram_data_o = 0;
                w_ram_addr_o = 0;
                if (mode_sel == `IMM_INST_sel) begin
                    w_pc_data_o = r_pc_data_i;
                end
                else begin
                    if (r_pc_data_i >= `MAX_ROM_ADDR) begin
                        w_pc_data_o = 0;
                    end
                    else begin
                        w_pc_data_o = r_pc_data_i + 1;
                    end
                end
            end
            `DIV: begin
                if (imm_i == `IMM_YES) begin
                    en_w_reg_o = 0;
                    en_w_ram_o = 0;
                    w_ram_data_o = 0;
                    w_ram_addr_o = 0;
                    w_reg_data_1_o = 0;
                    w_reg_data_2_o = 0;
                    w_reg_addr_1_o = 0;
                    w_reg_addr_2_o = 0;
                end
                else begin
                    w_reg_addr_1_o = `REG_MD_H;
                    w_reg_addr_2_o = `REG_MD_L;
                    mul_div_rslt = {r_reg_data_3_i, r_reg_data_4_i}/{r_reg_data_1_i, r_reg_data_2_i};
                    w_reg_data_1_o = mul_div_rslt[15:8];
                    w_reg_data_2_o = mul_div_rslt[7:0];
                end
                en_w_reg_o = 1;
                en_w_ram_o = 0;
                w_ram_data_o = 0;
                w_ram_addr_o = 0;
                if (mode_sel == `IMM_INST_sel) begin
                    w_pc_data_o = r_pc_data_i;
                end
                else begin
                    if (r_pc_data_i >= `MAX_ROM_ADDR) begin
                        w_pc_data_o = 0;
                    end
                    else begin
                        w_pc_data_o = r_pc_data_i + 1;
                    end
                end
            end
            `AND: begin
                if (imm_i == `IMM_YES) begin
                    w_reg_addr_1_o = reg_addr_2_i;
                    w_reg_data_1_o = imm_data_1_i & r_reg_data_1_i;
                end
                else begin
                    w_reg_addr_1_o = reg_addr_3_i;
                    w_reg_data_1_o = r_reg_data_2_i & r_reg_data_1_i;
                end
                w_reg_addr_2_o = `REG_0;
                w_reg_data_2_o = `EMPTY;
                en_w_reg_o = 1;
                en_w_ram_o = 0;
                w_ram_data_o = 0;
                w_ram_addr_o = 0;
                if (mode_sel == `IMM_INST_sel) begin
                    w_pc_data_o = r_pc_data_i;
                end
                else begin
                    if (r_pc_data_i >= `MAX_ROM_ADDR) begin
                        w_pc_data_o = 0;
                    end
                    else begin
                        w_pc_data_o = r_pc_data_i + 1;
                    end
                end
            end
            `OR: begin
                if (imm_i == `IMM_YES) begin
                    w_reg_addr_1_o = reg_addr_2_i;
                    w_reg_data_1_o = imm_data_1_i | r_reg_data_1_i;
                end
                else begin
                    w_reg_addr_1_o = reg_addr_3_i;
                    w_reg_data_1_o = r_reg_data_2_i | r_reg_data_1_i;
                end
                w_reg_addr_2_o = `REG_0;
                w_reg_data_2_o = `EMPTY;
                en_w_reg_o = 1;
                en_w_ram_o = 0;
                w_ram_data_o = 0;
                w_ram_addr_o = 0;
                if (mode_sel == `IMM_INST_sel) begin
                    w_pc_data_o = r_pc_data_i;
                end
                else begin
                    if (r_pc_data_i >= `MAX_ROM_ADDR) begin
                        w_pc_data_o = 0;
                    end
                    else begin
                        w_pc_data_o = r_pc_data_i + 1;
                    end
                end
            end
            `NOT: begin
                if (imm_i == `IMM_YES) begin
                    w_reg_addr_1_o = reg_addr_1_i;
                    w_reg_data_1_o = ~ imm_data_1_i;
                end
                else begin
                    w_reg_addr_1_o = reg_addr_2_i;
                    w_reg_data_1_o = ~ r_reg_data_1_i;
                end
                w_reg_addr_2_o = `REG_0;
                w_reg_data_2_o = `EMPTY;
                en_w_reg_o = 1;
                en_w_ram_o = 0;
                w_ram_data_o = 0;
                w_ram_addr_o = 0;
                if (mode_sel == `IMM_INST_sel) begin
                    w_pc_data_o = r_pc_data_i;
                end
                else begin
                    if (r_pc_data_i >= `MAX_ROM_ADDR) begin
                        w_pc_data_o = 0;
                    end
                    else begin
                        w_pc_data_o = r_pc_data_i + 1;
                    end
                end
            end
            `RSHIFT: begin
                if (imm_i == `IMM_YES) begin
                    w_reg_addr_1_o = reg_addr_2_i;
                    w_reg_data_1_o = r_reg_data_1_i >> imm_data_1_i;
                end
                else begin
                    w_reg_addr_1_o = reg_addr_3_i;
                    w_reg_data_1_o = r_reg_data_1_i >> r_reg_data_2_i;
                end
                w_reg_addr_2_o = `REG_0;
                w_reg_data_2_o = `EMPTY;
                en_w_reg_o = 1;
                en_w_ram_o = 0;
                w_ram_data_o = 0;
                w_ram_addr_o = 0;
                if (mode_sel == `IMM_INST_sel) begin
                    w_pc_data_o = r_pc_data_i;
                end
                else begin
                    if (r_pc_data_i >= `MAX_ROM_ADDR) begin
                        w_pc_data_o = 0;
                    end
                    else begin
                        w_pc_data_o = r_pc_data_i + 1;
                    end
                end
            end
            `LSHIFT: begin
                if (imm_i == `IMM_YES) begin
                    w_reg_addr_1_o = reg_addr_2_i;
                    w_reg_data_1_o = r_reg_data_1_i << imm_data_1_i;
                end
                else begin
                    w_reg_addr_1_o = reg_addr_3_i;
                    w_reg_data_1_o = r_reg_data_1_i << r_reg_data_2_i;
                end
                w_reg_addr_2_o = `REG_0;
                w_reg_data_2_o = `EMPTY;
                en_w_reg_o = 1;
                en_w_ram_o = 0;
                w_ram_data_o = 0;
                w_ram_addr_o = 0;
                if (mode_sel == `IMM_INST_sel) begin
                    w_pc_data_o = r_pc_data_i;
                end
                else begin
                    if (r_pc_data_i >= `MAX_ROM_ADDR) begin
                        w_pc_data_o = 0;
                    end
                    else begin
                        w_pc_data_o = r_pc_data_i + 1;
                    end
                end
            end
            `MOVE: begin
                if (imm_i == `IMM_YES) begin
                    w_reg_addr_1_o = reg_addr_1_i;
                    w_reg_data_1_o = imm_data_1_i;
                end
                else begin
                    w_reg_addr_1_o = reg_addr_2_i;
                    w_reg_data_1_o = r_reg_data_1_i;
                end
                w_reg_addr_2_o = `REG_0;
                w_reg_data_2_o = `EMPTY;
                en_w_reg_o = 1;
                en_w_ram_o = 0;
                w_ram_data_o = 0;
                w_ram_addr_o = 0;
                if (mode_sel == `IMM_INST_sel) begin
                    w_pc_data_o = r_pc_data_i;
                end
                else begin
                    if (r_pc_data_i >= `MAX_ROM_ADDR) begin
                        w_pc_data_o = 0;
                    end
                    else begin
                        w_pc_data_o = r_pc_data_i + 1;
                    end
                end
            end
            `MOVEOUT: begin
                if (imm_i == `IMM_YES) begin
                    en_w_reg_o = 0;
                    en_w_ram_o = 0;
                    w_ram_data_o = 0;
                    w_ram_addr_o = 0;
                    w_reg_data_1_o = 0;
                    w_reg_data_2_o = 0;
                    w_reg_addr_1_o = 0;
                    w_reg_addr_2_o = 0;
                end
                else begin
                    w_reg_addr_1_o = `REG_0;
                    w_reg_data_1_o = `EMPTY;
                    w_reg_addr_2_o = `REG_0;
                    w_reg_data_2_o = `EMPTY;
                    en_w_reg_o = 0;
                    en_w_ram_o = 1;
                    w_ram_data_o = r_reg_data_1_i;
                    w_ram_addr_o = {r_reg_data_2_i,r_reg_data_3_i};
                end
                if (mode_sel == `IMM_INST_sel) begin
                    w_pc_data_o = r_pc_data_i;
                end
                else begin
                    if (r_pc_data_i >= `MAX_ROM_ADDR) begin
                        w_pc_data_o = 0;
                    end
                    else begin
                        w_pc_data_o = r_pc_data_i + 1;
                    end
                end
            end
            `MOVEIN: begin
                if (imm_i == `IMM_YES) begin
                    en_w_reg_o = 1;
                    en_w_ram_o = 0;
                    w_ram_data_o = 0;
                    w_ram_addr_o = 0;
                    w_reg_data_1_o = r_ram_data_i;
                    w_reg_data_2_o = `REG_0;
                    w_reg_addr_1_o = `REG_MOVEIN;
                    w_reg_addr_2_o = `EMPTY;
                end
                else begin
                    en_w_reg_o = 0;
                    en_w_ram_o = 0;
                    w_ram_data_o = 0;
                    w_ram_addr_o = 0;
                    w_reg_data_1_o = 0;
                    w_reg_data_2_o = 0;
                    w_reg_addr_1_o = 0;
                    w_reg_addr_2_o = 0;
                end
                if (mode_sel == `IMM_INST_sel) begin
                    w_pc_data_o = r_pc_data_i;
                end
                else begin
                    if (r_pc_data_i >= `MAX_ROM_ADDR) begin
                        w_pc_data_o = 0;
                    end
                    else begin
                        w_pc_data_o = r_pc_data_i + 1;
                    end
                end
            end
            `JUMP: begin
                if (imm_i == `IMM_YES) begin
                    en_w_reg_o = 0;
                    en_w_ram_o = 0;
                    w_ram_data_o = 0;
                    w_ram_addr_o = 0;
                    w_reg_data_1_o = 0;
                    w_reg_data_2_o = 0;
                    w_reg_addr_1_o = 0;
                    w_reg_addr_2_o = 0;
                    w_pc_data_o = r_pc_data_i + 1;
                end
                else begin
                    w_pc_data_o = {r_reg_data_1_i,r_reg_data_2_i};
                end
            end
            `EJUMP: begin
                if (imm_i == `IMM_YES) begin
                    en_w_reg_o = 0;
                    en_w_ram_o = 0;
                    w_ram_data_o = 0;
                    w_ram_addr_o = 0;
                    w_reg_data_1_o = 0;
                    w_reg_data_2_o = 0;
                    w_reg_addr_1_o = 0;
                    w_reg_addr_2_o = 0;
                    w_pc_data_o = r_pc_data_i + 1;
                end
                else begin
                    if (r_reg_data_1_i == r_reg_data_2_i) begin
                        w_pc_data_o = {r_reg_data_3_i,r_reg_data_4_i};
                    end
                    else begin
                        w_pc_data_o = r_pc_data_i + 1;
                    end
                end
            end
            `NEJUMP: begin
                if (imm_i == `IMM_YES) begin
                    en_w_reg_o = 0;
                    en_w_ram_o = 0;
                    w_ram_data_o = 0;
                    w_ram_addr_o = 0;
                    w_reg_data_1_o = 0;
                    w_reg_data_2_o = 0;
                    w_reg_addr_1_o = 0;
                    w_reg_addr_2_o = 0;
                    w_pc_data_o = r_pc_data_i + 1;
                end
                else begin
                    if (r_reg_data_1_i != r_reg_data_2_i) begin
                        w_pc_data_o = {r_reg_data_3_i,r_reg_data_4_i};
                    end
                    else begin
                        w_pc_data_o = r_pc_data_i + 1;
                    end
                end
            end
            `MTHAN: begin
                if (imm_i == `IMM_YES) begin
                    en_w_reg_o = 0;
                    w_reg_data_1_o = 0;
                    w_reg_data_2_o = 0;
                    w_reg_addr_1_o = 0;
                    w_reg_addr_2_o = 0;
                end
                else begin
                    en_w_reg_o = 1;
                    w_reg_data_1_o = (r_reg_data_1_i > r_reg_data_2_i)?r_reg_data_1_i:r_reg_data_2_i;
                    w_reg_data_2_o = (r_reg_data_1_i > r_reg_data_2_i)?`EN_MORE:`DIS_MORE;
                    w_reg_addr_1_o = r_reg_data_3_i;
                    w_reg_addr_2_o = `REG_MTHAN;
                end
                en_w_ram_o = 0;
                w_ram_data_o = 0;
                w_ram_addr_o = 0;
                if (mode_sel == `IMM_INST_sel) begin
                    w_pc_data_o = r_pc_data_i;
                end
                else begin
                    if (r_pc_data_i >= `MAX_ROM_ADDR) begin
                        w_pc_data_o = 0;
                    end
                    else begin
                        w_pc_data_o = r_pc_data_i + 1;
                    end
                end
            end
            `WAIT: begin
                en_w_ram_o = 0;
                en_w_reg_o = 0;
                w_ram_data_o = 0;
                w_ram_addr_o = 0;
                w_reg_data_1_o = 0;
                w_reg_data_2_o = 0;
                w_reg_addr_1_o = 0;
                w_reg_addr_2_o = 0;
                if (pc_i == `PC_WAIT || pc_i == `PC_WAIT_HIGH || mode_sel == `IMM_INST_sel) begin
                    w_pc_data_o = r_pc_data_i;
                end
                else begin
                    if (r_pc_data_i >= `MAX_ROM_ADDR) begin
                        w_pc_data_o = 0;
                    end
                    else begin
                        w_pc_data_o = r_pc_data_i + 1;
                    end
                end
            end
            `INTER: begin // disabled
                if (imm_i == `IMM_YES) begin
                    en_w_reg_o = 0;
                    en_w_ram_o = 0;
                    w_ram_data_o = 0;
                    w_ram_addr_o = 0;
                    w_reg_data_1_o = 0;
                    w_reg_data_2_o = 0;
                    w_reg_addr_1_o = 0;
                    w_reg_addr_2_o = 0;
                    if (mode_sel == `IMM_INST_sel) begin
                        w_pc_data_o = r_pc_data_i;
                    end
                    else begin
                        if (r_pc_data_i >= `MAX_ROM_ADDR) begin
                            w_pc_data_o = 0;
                        end
                        else begin
                            w_pc_data_o = r_pc_data_i + 1;
                        end
                    end
                end
                else begin
                    en_w_reg_o = 0;
                    en_w_ram_o = 0;
                    w_ram_data_o = 0;
                    w_ram_addr_o = 0;
                    w_reg_data_1_o = 0;
                    w_reg_data_2_o = 0;
                    w_reg_addr_1_o = 0;
                    w_reg_addr_2_o = 0;
                    if (mode_sel == `IMM_INST_sel) begin
                        w_pc_data_o = r_pc_data_i;
                    end
                    else begin
                        if (r_pc_data_i >= `MAX_ROM_ADDR) begin
                            w_pc_data_o = 0;
                        end
                        else begin
                            w_pc_data_o = r_pc_data_i + 1;
                        end
                    end
                end
            end
            default: begin
                en_w_ram_o = 0;
                en_w_reg_o = 0;
                w_ram_data_o = 0;
                w_ram_addr_o = 0;
                w_reg_data_1_o = 0;
                w_reg_data_2_o = 0;
                w_reg_addr_1_o = 0;
                w_reg_addr_2_o = 0;
                if (mode_sel == `IMM_INST_sel) begin
                    w_pc_data_o = r_pc_data_i;
                end
                else begin
                    if (r_pc_data_i >= `MAX_ROM_ADDR) begin
                        w_pc_data_o = 0;
                    end
                    else begin
                        w_pc_data_o = r_pc_data_i + 1;
                    end
                end
            end
        endcase
    end
end

endmodule
