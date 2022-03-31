
module inst_buffer

//----------------------------------------------------------------
// Ports
//----------------------------------------------------------------

(
     clk_i
    ,rst_i
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
    ,npu_ram_addr_i
    ,npu_w_reg_addr_i

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
    input clk_i;
    input rst_i;
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
    input [7:0] npu_ram_addr_i;
    input [4:0] npu_w_reg_addr_i;

    // Outputs
    output reg [7:0] alu_o;
    output reg [1:0] pc_o;
    output reg [1:0] reg_o;
    output reg imm_o;
    output reg mem_o;
    output reg [4:0] reg_addr_1_o;
    output reg [4:0] reg_addr_2_o;
    output reg [4:0] reg_addr_3_o;
    output reg [4:0] reg_addr_4_o;
    output reg [15:0] ram_addr_o;
    output reg [7:0] imm_data_1_o;
    output reg [7:0] imm_data_2_o;
    output reg [7:0] npu_ram_addr_o;
    output reg [4:0] npu_w_reg_addr_o;

//----------------------------------------------------------------
// Includes
//----------------------------------------------------------------

`include "defs.v"

//----------------------------------------------------------------
// Circuits
//----------------------------------------------------------------

// Initialization
initial begin
    alu_o = 0;
    pc_o = 0;
    reg_o = 0;
    imm_o = 0;
    mem_o = 0;
    reg_addr_1_o = 0;
    reg_addr_2_o = 0;
    reg_addr_3_o = 0;
    reg_addr_4_o = 0;
    ram_addr_o = 0;
    imm_data_1_o = 0;
    imm_data_2_o = 0;
    npu_ram_addr_o = 0;
    npu_w_reg_addr_o = 0;
end

always @(posedge clk_i) begin
    if (rst_i == `RESET) begin
        alu_o = 0;
        pc_o = 0;
        reg_o = 0;
        imm_o = 0;
        mem_o = 0;
        reg_addr_1_o = 0;
        reg_addr_2_o = 0;
        reg_addr_3_o = 0;
        reg_addr_4_o = 0;
        ram_addr_o = 0;
        npu_ram_addr_o = 0;
        npu_w_reg_addr_o = 0;
    end
    else begin
        alu_o = alu_i;
        pc_o = pc_i;
        reg_o = reg_i;
        imm_o = imm_i;
        mem_o = mem_i;
        reg_addr_1_o = reg_addr_1_i;
        reg_addr_2_o = reg_addr_2_i;
        reg_addr_3_o = reg_addr_3_i;
        reg_addr_4_o = reg_addr_4_i;
        ram_addr_o = ram_addr_i;
        imm_data_1_o = imm_data_1_i;
        imm_data_2_o = imm_data_2_i;
        npu_ram_addr_o = npu_ram_addr_i;
        npu_w_reg_addr_o = npu_w_reg_addr_i;
    end
end

endmodule
