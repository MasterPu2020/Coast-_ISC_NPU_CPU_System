
module N_ram_selector

//----------------------------------------------------------------
// Includes
//----------------------------------------------------------------

`include "defs.v"

//----------------------------------------------------------------
// Ports
//----------------------------------------------------------------

(
     npu_alu_sel_i

    ,wb_en_w_i
    ,wb_w_line_i
    ,wb_img28_data_i
    ,wb_img14_data_i
    ,wb_img10_data_i
    ,wb_img5_data_i
    ,wb_result_data_i

    ,axi_en_w_i
    ,axi_w_line_i
    ,axi_r_rslt_addr_i
    ,axi_img32_data_i
    ,axi_img28_data_i
    ,axi_img14_data_i
    ,axi_img10_data_i
    ,axi_img5_data_i
    ,axi_fliter_c1_data_i
    ,axi_fliter_c3_data_i
    ,axi_weight_c5_data_i
    ,axi_bias_c1_data_i
    ,axi_bias_c3_data_i
    ,axi_bias_c5_data_i
    ,axi_result_data_i

    ,en_w_o
    ,w_line_o
    ,img32_data_o
    ,img28_data_o
    ,img14_data_o
    ,img10_data_o
    ,img5_data_o
    ,fliter_c1_data_o
    ,fliter_c3_data_o
    ,weight_c5_data_o
    ,bias_c1_data_o
    ,bias_c3_data_o
    ,bias_c5_data_o
    ,result_data_o
);

    // Inputs

    input npu_alu_sel_i;

    input wb_en_w_i;
    input [3:0] wb_w_line_i;
    input [`IMG_S2_END - `IMG_S2_STA : 0] wb_img28_data_i;
    input [`IMG_C3_END - `IMG_C3_STA : 0] wb_img14_data_i;
    input [`IMG_S4_END - `IMG_S4_STA : 0] wb_img10_data_i;
    input [`IMG_C5_END - `IMG_C5_STA : 0] wb_img5_data_i;
    input [`RESULT_END - `RESULT_STA : 0] wb_result_data_i;

    input axi_en_w_i;
    input [3:0] axi_w_line_i;
    input [7:0] axi_r_rslt_addr_i;
    input [`IMG_C1_END - `IMG_C1_STA : 0] axi_img32_data_i;
    input [`IMG_S2_END - `IMG_S2_STA : 0] axi_img28_data_i;
    input [`IMG_C3_END - `IMG_C3_STA : 0] axi_img14_data_i;
    input [`IMG_S4_END - `IMG_S4_STA : 0] axi_img10_data_i;
    input [`IMG_C5_END - `IMG_C5_STA : 0] axi_img5_data_i;
    input [`FLITER_C1_END - `FLITER_C1_STA : 0] axi_fliter_c1_data_i;
    input [`FLITER_C3_END - `FLITER_C3_STA : 0] axi_fliter_c3_data_i;
    input [`WEIGHT_C5_END - `WEIGHT_C5_STA : 0] axi_weight_c5_data_i;
    input [`BIAS_C1_END - `BIAS_C1_STA : 0] axi_bias_c1_data_i;
    input [`BIAS_C3_END - `BIAS_C3_STA : 0] axi_bias_c3_data_i;
    input [`BIAS_C5_END - `BIAS_C5_STA : 0] axi_bias_c5_data_i;
    input [`RESULT_END - `RESULT_STA : 0] axi_result_data_i;

    // Outputs
    output en_w_o;
    output [3:0] w_line_o;
    output [`IMG_C1_END - `IMG_C1_STA : 0] img32_data_o;
    output [`IMG_S2_END - `IMG_S2_STA : 0] img28_data_o;
    output [`IMG_C3_END - `IMG_C3_STA : 0] img14_data_o;
    output [`IMG_S4_END - `IMG_S4_STA : 0] img10_data_o;
    output [`IMG_C5_END - `IMG_C5_STA : 0] img5_data_o;
    output [`FLITER_C1_END - `FLITER_C1_STA : 0] fliter_c1_data_o;
    output [`FLITER_C3_END - `FLITER_C3_STA : 0] fliter_c3_data_o;
    output [`WEIGHT_C5_END - `WEIGHT_C5_STA : 0] weight_c5_data_o;
    output [`BIAS_C1_END - `BIAS_C1_STA : 0] bias_c1_data_o;
    output [`BIAS_C3_END - `BIAS_C3_STA : 0] bias_c3_data_o;
    output [`BIAS_C5_END - `BIAS_C5_STA : 0] bias_c5_data_o;
    output [`RESULT_END - `RESULT_STA : 0] result_data_o;

//----------------------------------------------------------------
// Circuits
//----------------------------------------------------------------

assign en_w_o = (npu_alu_sel_i == `Sel_NPU_ALU)?wb_en_w_i:axi_en_w_i;
assign w_line_o = (npu_alu_sel_i == `Sel_NPU_ALU)?wb_w_line_i:axi_w_line_i;
assign img32_data_o = axi_img32_data_i;
assign img28_data_o = (npu_alu_sel_i == `Sel_NPU_ALU)?wb_img28_data_i:axi_img28_data_i;
assign img14_data_o = (npu_alu_sel_i == `Sel_NPU_ALU)?wb_img14_data_i:axi_img14_data_i;
assign img10_data_o = (npu_alu_sel_i == `Sel_NPU_ALU)?wb_img10_data_i:axi_img10_data_i;
assign img5_data_o = (npu_alu_sel_i == `Sel_NPU_ALU)?wb_img5_data_i:axi_img5_data_i;
assign fliter_c1_data_o = axi_fliter_c1_data_i;
assign fliter_c3_data_o = axi_fliter_c3_data_i;
assign weight_c5_data_o = axi_weight_c5_data_i;
assign bias_c1_data_o = axi_bias_c1_data_i;
assign bias_c3_data_o = axi_bias_c3_data_i;
assign bias_c5_data_o = axi_bias_c5_data_i;
assign result_data_o = (npu_alu_sel_i == `Sel_NPU_ALU)?wb_result_data_i:axi_result_data_i;

endmodule
