
module NPU_alu

//----------------------------------------------------------------
// Includes
//----------------------------------------------------------------

`include "defs.v"

//----------------------------------------------------------------
// Ports
//----------------------------------------------------------------

(
     clk_i
    ,rst_i
    ,alu_i
    ,w_reg_addr_npu_i
    ,img32_i
    ,img28_i
    ,img14_i
    ,img10_i
    ,img5_i
    ,result_i
    ,fliter_c1_i
    ,fliter_c3_i
    ,weight_c5_i
    ,bias_c1_i
    ,bias_c3_i
    ,bias_c5_i
    ,en_w_o
    ,w_line_o
    ,img28_data_o
    ,img14_data_o
    ,img10_data_o
    ,img5_data_o
    ,result_data_o
    ,npu_alu_sel_o
    ,en_w_reg_npu_o
    ,w_reg_addr_npu_o
    ,w_reg_data_npu_o
);

    // Inputs
    input clk_i;
    input rst_i;
    input [7:0] alu_i;
    input [4:0] w_reg_addr_npu_i;
    input [`IMG_C1_END - `IMG_C1_STA : 0] img32_i;
    input [`IMG_S2_END - `IMG_S2_STA : 0] img28_i;
    input [`IMG_C3_END - `IMG_C3_STA : 0] img14_i;
    input [`IMG_S4_END - `IMG_S4_STA : 0] img10_i;
    input [`IMG_C5_END - `IMG_C5_STA : 0] img5_i;
    input [7:0] result_i; // 需要分部读取并储存到cpu ram中
    input [`FLITER_C1_END - `FLITER_C1_STA : 0] fliter_c1_i;
    input [`FLITER_C3_END - `FLITER_C3_STA : 0] fliter_c3_i;
    input [`WEIGHT_C5_END - `WEIGHT_C5_STA : 0] weight_c5_i;
    input [`BIAS_C1_END - `BIAS_C1_STA : 0] bias_c1_i;
    input [`BIAS_C3_END - `BIAS_C3_STA : 0] bias_c3_i;
    input [`BIAS_C5_END - `BIAS_C5_STA : 0] bias_c5_i;

    // Outputs
    output reg en_w_o;
    output reg [3:0] w_line_o;
    output reg [`IMG_S2_END - `IMG_S2_STA : 0] img28_data_o;
    output reg [`IMG_C3_END - `IMG_C3_STA : 0] img14_data_o;
    output reg [`IMG_S4_END - `IMG_S4_STA : 0] img10_data_o;
    output reg [`IMG_C5_END - `IMG_C5_STA : 0] img5_data_o;
    output reg [`RESULT_END - `RESULT_STA : 0] result_data_o;

    output reg npu_alu_sel_o;
    output reg en_w_reg_npu_o;
    output reg [4:0] w_reg_addr_npu_o;
    output reg [7:0] w_reg_data_npu_o;

//----------------------------------------------------------------
// Registers / Wires
//----------------------------------------------------------------

    wire [`IMG_C1_END - `IMG_C1_STA : 0] img32_result;
    wire [`IMG_S2_END - `IMG_S2_STA : 0] img28_result;
    wire [`IMG_C3_END - `IMG_C3_STA : 0] img14_result;
    wire [`IMG_S4_END - `IMG_S4_STA : 0] img10_result;
    wire [`IMG_C5_END - `IMG_C5_STA : 0] img5_result;
    wire [`RESULT_END - `RESULT_STA : 0] final_result;

//----------------------------------------------------------------
// Circuits
//----------------------------------------------------------------

// Modules
convolution #(
    `BITWIDTH_8,
    `DATAWIDTH_C1,
    `DATAHEIGHT_C1,
    `CHANNEL1,
    `FILTERHEIGHT,
    `FILTERWIDTH,
    `FILTERBATCH,
    `STRIDEHEIGHT,
    `STRIDEWIDTH,
    `PADDINGENABLE)
    c1(
     .data(img32_i)
    ,.filterWeight(fliter_c1_i)
    ,.filterBias(bias_c1_i)
    ,.result(img28_result)
);

pooling #(
    `BITWIDTH_16,
    `DATAWIDTH_S2,
    `DATAHEIGHT_S2,
    `CHANNEL1,
    `KWIDTH,
    `KHEIGHT)
    s2(
     .data(img28_i)
    ,.result(img14_result)
);

convolution #(
    `BITWIDTH_16,
    `DATAWIDTH_C3,
    `DATAHEIGHT_C3,
    `CHANNEL1,
    `FILTERHEIGHT,
    `FILTERWIDTH,
    `FILTERBATCH,
    `STRIDEHEIGHT,
    `STRIDEWIDTH,
    `PADDINGENABLE)
    c3(
     .data(img14_i)
    ,.filterWeight(fliter_c3_i)
    ,.filterBias(bias_c3_i)
    ,.result(img10_result)
);

pooling #(
    `BITWIDTH_32,
    `DATAWIDTH_S4,
    `DATAHEIGHT_S4,
    `CHANNEL1,
    `KWIDTH,
    `KHEIGHT)
    s4(
     .data(img10_i)
    ,.result(img5_result)
);

full_connection #(
    `BITWIDTH_32,
    `LENGTH,
    `OUTLEN,
    `CHANNEL1,
    `FILTERHEIGHT,
    `FILTERWIDTH)
    c5(
     .data(img5_i)
    ,.weight(weight_c5_i)
    ,.bias(bias_c5_i)
    ,.result(final_result)
);

// Initialization
initial begin
    en_w_o = 0;
    w_line_o = 0;
    img28_data_o = 0;
    img14_data_o = 0;
    img10_data_o = 0;
    img5_data_o = 0;
    result_data_o = 0;
    npu_alu_sel_o = 0;
    en_w_reg_npu_o = 0;
    w_reg_addr_npu_o = 0;
    w_reg_data_npu_o = 0;
end

always @(posedge clk_i) begin
    if (rst_i == `RESET) begin
        en_w_o = 0;
        w_line_o = 0;
        img28_data_o = 0;
        img14_data_o = 0;
        img10_data_o = 0;
        img5_data_o = 0;
        result_data_o = 0;
        npu_alu_sel_o = 0;
        en_w_reg_npu_o = 0;
        w_reg_addr_npu_o = 0;
        w_reg_data_npu_o = 0;
    end
    else begin
        case (alu_i)
            `C1: begin
                en_w_reg_npu_o = 0;
                en_w_o = 1;
                img28_data_o = img28_result;
                w_line_o = `IMG_S2_LINE;
                npu_alu_sel_o = 1;
            end
            `S2: begin
                en_w_reg_npu_o = 0;
                en_w_o = 1;
                img14_data_o = img14_result;
                w_line_o = `IMG_C3_LINE;
                npu_alu_sel_o = 1;
            end
            `C3: begin
                en_w_reg_npu_o = 0;
                en_w_o = 1;
                img10_data_o = img10_result;
                w_line_o = `IMG_S4_LINE;
                npu_alu_sel_o = 1;
            end
            `S4: begin
                en_w_reg_npu_o = 0;
                en_w_o = 1;
                img5_data_o = img5_result;
                w_line_o = `IMG_C5_LINE;
                npu_alu_sel_o = 1;
            end
            `C5: begin
                en_w_reg_npu_o = 0;
                en_w_o = 1;
                result_data_o = final_result;
                w_line_o = `RESULT_LINE;
                npu_alu_sel_o = 1;
            end
            `LRMOVE: begin
                en_w_o = 0;
                w_line_o = 0;
                npu_alu_sel_o = 1;
                en_w_reg_npu_o = 1;
                w_reg_addr_npu_o = w_reg_addr_npu_i;
                w_reg_data_npu_o = result_i;
            end
            default: begin
                en_w_o = 0;
                w_line_o = 0;
                img28_data_o = 0;
                img14_data_o = 0;
                img10_data_o = 0;
                img5_data_o = 0;
                result_data_o = 0;
                npu_alu_sel_o = 0;
                en_w_reg_npu_o = 0;
                w_reg_addr_npu_o = 0;
                w_reg_data_npu_o = 0;
            end
        endcase
    end
end

endmodule
