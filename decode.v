
module decode

//----------------------------------------------------------------
// Ports
//----------------------------------------------------------------

(
     inst_i
    ,alu_o
    ,pc_o
    ,reg_o
    ,imm_o
    ,mem_o
    ,reg_addr_1_o
    ,reg_addr_2_o
    ,reg_addr_3_o
    ,reg_addr_4_o
    ,ram_addr_o
    ,imm_data_1_o
    ,imm_data_2_o
    ,npu_ram_addr_o
    ,npu_w_reg_addr_o
);

    // Inputs
    input [31:0] inst_i;

    // Outputs
    output [7:0] alu_o;
    output [1:0] pc_o;
    output [1:0] reg_o;
    output imm_o;
    output mem_o;
    output [4:0] reg_addr_1_o;
    output [4:0] reg_addr_2_o;
    output [4:0] reg_addr_3_o;
    output [4:0] reg_addr_4_o;
    output [15:0] ram_addr_o;
    output [7:0] imm_data_1_o;
    output [7:0] imm_data_2_o;
    output [7:0] npu_ram_addr_o;
    output [4:0] npu_w_reg_addr_o;

//----------------------------------------------------------------
// Includes
//----------------------------------------------------------------

`include "defs.v"

//----------------------------------------------------------------
// Circuits
//----------------------------------------------------------------

function [4:0] reg_addr_1;
    input [31:0] inst_i;
    case(inst_i[19])
        `IMM_YES: begin
            case(inst_i[31:24])
                `ADD: reg_addr_1 = inst_i[9:5];
                `SUB: reg_addr_1 = inst_i[9:5];
                `AND: reg_addr_1 = inst_i[9:5];
                `OR: reg_addr_1 = inst_i[9:5];
                `NOT: reg_addr_1 = inst_i[9:5];
                `RSHIFT: reg_addr_1 = inst_i[9:5];
                `LSHIFT: reg_addr_1 = inst_i[9:5];
                `MOVE: reg_addr_1 = inst_i[9:5];
                default: reg_addr_1 = `EMPTY;
            endcase
        end
        `IMM_NO: begin
            case(inst_i[31:24])
                `ADD: reg_addr_1 = inst_i[17:13];
                `SUB: reg_addr_1 = inst_i[17:13];
                `MUL: reg_addr_1 = inst_i[17:13];
                `DIV: reg_addr_1 = inst_i[17:13];
                `AND: reg_addr_1 = inst_i[17:13];
                `OR: reg_addr_1 = inst_i[17:13];
                `NOT: reg_addr_1 = inst_i[17:13];
                `RSHIFT: reg_addr_1 = inst_i[17:13];
                `LSHIFT: reg_addr_1 = inst_i[17:13];
                `MOVE: reg_addr_1 = inst_i[17:13];            
                `MOVEOUT: reg_addr_1 = inst_i[17:13];
                `JUMP: reg_addr_1 = inst_i[17:13];
                `EJUMP: reg_addr_1 = inst_i[17:13];
                `NEJUMP: reg_addr_1 = inst_i[17:13];
                `MTHAN: reg_addr_1 = inst_i[17:13];
                `WAIT: reg_addr_1 = `EMPTY;
                `INTER:  reg_addr_1 = `REG_INTER;
                default: reg_addr_1 = `EMPTY;
            endcase
        end
        default: reg_addr_1 = `EMPTY;
    endcase
endfunction

function [4:0] reg_addr_2;
    input [31:0] inst_i;
    case(inst_i[19])
        `IMM_YES: begin
            case(inst_i[31:24])
                `ADD: reg_addr_2 = inst_i[4:0];
                `SUB: reg_addr_2 = inst_i[4:0];
                `AND: reg_addr_2 = inst_i[4:0];
                `OR: reg_addr_2 = inst_i[4:0];
                `RSHIFT: reg_addr_2 = inst_i[4:0];
                `LSHIFT: reg_addr_2 = inst_i[4:0];
                default: reg_addr_2 = `EMPTY;
            endcase
        end
        `IMM_NO: begin
            case(inst_i[31:24])
                `ADD: reg_addr_2 = inst_i[12:8];
                `SUB: reg_addr_2 = inst_i[12:8];
                `MUL: reg_addr_2 = inst_i[12:8];
                `DIV: reg_addr_2 = inst_i[12:8];
                `AND: reg_addr_2 = inst_i[12:8];
                `OR: reg_addr_2 = inst_i[12:8];
                `NOT: reg_addr_2 = inst_i[12:8];
                `RSHIFT: reg_addr_2 = inst_i[12:8];
                `LSHIFT: reg_addr_2 = inst_i[12:8];
                `MOVE: reg_addr_2 = inst_i[12:8];            
                `MOVEOUT: reg_addr_2 = inst_i[12:8];
                `JUMP: reg_addr_2 = inst_i[12:8];
                `EJUMP: reg_addr_2 = inst_i[12:8];
                `NEJUMP: reg_addr_2 = inst_i[12:8];
                `MTHAN: reg_addr_2 = inst_i[12:8];
                `WAIT: reg_addr_2 = `EMPTY;
                default: reg_addr_2 = `EMPTY;
            endcase
        end
        default: reg_addr_2 = `EMPTY;
    endcase
endfunction

function [4:0] reg_addr_3;
    input [31:0] inst_i;
    case(inst_i[19])
        `IMM_YES: begin
            case(inst_i[31:24])
                default: reg_addr_3 = `EMPTY;
            endcase
        end
        `IMM_NO: begin
            case(inst_i[31:24])
                `ADD: reg_addr_3 = inst_i[7:3];
                `SUB: reg_addr_3 = inst_i[7:3];
                `MUL: reg_addr_3 = inst_i[7:3];
                `DIV: reg_addr_3 = `REG_MD_H;
                `AND: reg_addr_3 = inst_i[7:3];
                `OR: reg_addr_3 = inst_i[7:3];
                `RSHIFT: reg_addr_3 = inst_i[7:3];
                `LSHIFT: reg_addr_3 = inst_i[7:3];           
                `MOVEOUT: reg_addr_3 = inst_i[7:3];
                `EJUMP: reg_addr_3 = `REG_JUMP_H;
                `NEJUMP: reg_addr_3 = `REG_JUMP_H;
                `MTHAN: reg_addr_3 = inst_i[7:3];
                `WAIT: reg_addr_3 = `EMPTY;
                default: reg_addr_3 = `EMPTY;
            endcase
        end
        default: reg_addr_3 = `EMPTY;
    endcase
endfunction

function [4:0] reg_addr_4;
    input [31:0] inst_i;
    case(inst_i[19])
        `IMM_YES: begin
            case(inst_i[31:24])
                default: reg_addr_4 = `EMPTY;
            endcase
        end
        `IMM_NO: begin
            case(inst_i[31:24])
                `DIV: reg_addr_4 = `REG_MD_L;
                `EJUMP: reg_addr_4 = `REG_JUMP_L;
                `NEJUMP: reg_addr_4 = `REG_JUMP_L;
                `WAIT: reg_addr_4 = `EMPTY;
                default: reg_addr_4 = `EMPTY;
            endcase
        end
        default: reg_addr_4 = `EMPTY;
    endcase
endfunction

function [7:0] imm_data_1;
    input [31:0]inst_i;
    case(inst_i[19])
        `IMM_YES: begin
            case(inst_i[31:24])
                `ADD: imm_data_1 = inst_i[17:10];
                `SUB: imm_data_1 = inst_i[17:10];
                `AND: imm_data_1 = inst_i[17:10];
                `OR: imm_data_1 = inst_i[17:10];
                `NOT: imm_data_1 = inst_i[17:10];
                `RSHIFT: imm_data_1 = inst_i[17:10];
                `LSHIFT: imm_data_1 = inst_i[17:10];
                `MOVE: imm_data_1 = inst_i[17:10];
                `MOVEIN: imm_data_1 = inst_i[17:10];
                default: imm_data_1 = `EMPTY;
            endcase
        end
        `IMM_NO: begin
            case(inst_i[31:24])
                default: imm_data_1 = `EMPTY;
            endcase
        end
        default: imm_data_1 = `EMPTY;
    endcase
endfunction

function [7:0] imm_data_2;
    input [31:0]inst_i;
    case(inst_i[19])
        `IMM_YES: begin
            case(inst_i[31:24])
                `MOVEIN: imm_data_2 = inst_i[9:2];
                default: imm_data_2 = `EMPTY;
            endcase
        end
        `IMM_NO: begin
            case(inst_i[31:24])
                default: imm_data_2 = `EMPTY;
            endcase
        end
        default: imm_data_2 = `EMPTY;
    endcase
endfunction

assign alu_o = inst_i[31:24];
assign pc_o = inst_i[23:22];
assign reg_o = inst_i[21:20];
assign imm_o = inst_i[19];
assign mem_o = inst_i[18];
assign reg_addr_1_o = reg_addr_1(inst_i);
assign reg_addr_2_o = reg_addr_2(inst_i);
assign reg_addr_3_o = reg_addr_3(inst_i);
assign reg_addr_4_o = reg_addr_4(inst_i);
assign ram_addr_o = (alu_o == `MOVEIN)?inst_i[17:2]:`EMPTY;
assign imm_data_1_o = imm_data_1(inst_i);
assign imm_data_2_o = imm_data_2(inst_i);

//Extended
assign npu_ram_addr_o = inst_i[17:10];
assign npu_w_reg_addr_o = inst_i[9:5];

endmodule
