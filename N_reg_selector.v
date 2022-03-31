
module N_reg_selector

//----------------------------------------------------------------
// Includes
//----------------------------------------------------------------

`include "defs.v"

//----------------------------------------------------------------
// Ports
//----------------------------------------------------------------

(
     npu_alu_sel_i
    ,en_w_reg_npu_i
    ,w_reg_addr_npu_i
    ,w_reg_data_npu_i
    ,en_w_reg_i
    ,w_reg_data_1_i
    ,w_reg_addr_1_i
    ,en_w_reg_o
    ,w_reg_data_1_o
    ,w_reg_addr_1_o
);

    // Inputs
    input npu_alu_sel_i;
    input en_w_reg_npu_i;
    input [4:0] w_reg_addr_npu_i;
    input [7:0] w_reg_data_npu_i;
    input en_w_reg_i;
    input [7:0] w_reg_data_1_i;
    input [4:0] w_reg_addr_1_i;

    // Outputs
    output en_w_reg_o;
    output [7:0] w_reg_data_1_o;
    output [4:0] w_reg_addr_1_o;

//----------------------------------------------------------------
// Circuits
//----------------------------------------------------------------

assign w_reg_data_1_o = (npu_alu_sel_i == `Sel_NPU_ALU)?w_reg_data_npu_i:w_reg_data_1_i;
assign w_reg_addr_1_o = (npu_alu_sel_i == `Sel_NPU_ALU)?w_reg_addr_npu_i:w_reg_addr_1_i;
assign en_w_reg_o = (npu_alu_sel_i == `Sel_NPU_ALU)?en_w_reg_npu_i:en_w_reg_i;

endmodule
