`timescale 1ns/1ns

module LeNet_tb();

//----------------------------------------------------------------
// Params
//----------------------------------------------------------------
    
    parameter CYCLE = 10; //100mHz

    // GENERAL
    parameter CHANNEL1 = 1;
    parameter CHANNEL2 = 1;

    parameter BITWIDTH_8 = 8;
    parameter BITWIDTH_16 = 16;
    parameter BITWIDTH_32 = 32;
    parameter BITWIDTH_64 = 64;
    
    parameter DATAWIDTH_C1 = 32;
    parameter DATAHEIGHT_C1 = 32;

    parameter DATAWIDTH_S2 = 28;
    parameter DATAHEIGHT_S2 = 28;

    parameter DATAWIDTH_C3 = 14;
    parameter DATAHEIGHT_C3 = 14;

    parameter DATAWIDTH_S4 = 10;
    parameter DATAHEIGHT_S4 = 10;

    parameter DATAWIDTH_C5 = 5;
    parameter DATAHEIGHT_C5 = 5;

    parameter LENGTH = DATAWIDTH_C5 * DATAHEIGHT_C5 * CHANNEL2;
    parameter OUTLEN = 10;
    
    parameter FILTERHEIGHT = 5;
    parameter FILTERWIDTH = 5;
    
    // ADDRESS: 
    
    // IMG
    parameter IMG_C1_STA = 0;
    parameter IMG_C1_END = IMG_C1_STA + BITWIDTH_8 * DATAWIDTH_C1 * DATAHEIGHT_C1 * CHANNEL1 - 1;
    parameter IMG_S2_STA = IMG_C1_END + 1;
    parameter IMG_S2_END = IMG_S2_STA + BITWIDTH_16 * DATAWIDTH_S2 * DATAHEIGHT_S2 * CHANNEL2 - 1;
    parameter IMG_C3_STA = IMG_S2_END + 1;
    parameter IMG_C3_END = IMG_C3_STA + BITWIDTH_16 * DATAWIDTH_C3 * DATAHEIGHT_C3 * CHANNEL2 - 1;
    parameter IMG_S4_STA = IMG_C3_END + 1;
    parameter IMG_S4_END = IMG_S4_STA + BITWIDTH_32 * DATAWIDTH_S4 * DATAHEIGHT_S4 * CHANNEL2 - 1;
    parameter IMG_C5_STA = IMG_S4_END + 1;
    parameter IMG_C5_END = IMG_C5_STA + BITWIDTH_32 * LENGTH - 1;
    parameter RESULT_STA = IMG_C5_END + 1;
    parameter RESULT_END = RESULT_STA + BITWIDTH_64 * OUTLEN - 1;

    // FLITER
    parameter FLITER_C1_STA = RESULT_END + 1;
    parameter FLITER_C1_END = FLITER_C1_STA + BITWIDTH_8 * FILTERHEIGHT * FILTERHEIGHT - 1;
    parameter FLITER_C3_STA = FLITER_C1_END + 1;
    parameter FLITER_C3_END = FLITER_C3_STA + BITWIDTH_16 * FILTERHEIGHT * FILTERHEIGHT - 1;
    parameter WEIGHT_C5_STA = FLITER_C3_END + 1;
    parameter WEIGHT_C5_END = WEIGHT_C5_STA + BITWIDTH_32 * LENGTH * OUTLEN - 1;
    
    // BIAS
    parameter BIAS_C1_STA = WEIGHT_C5_END + 1;
    parameter BIAS_C1_END = BIAS_C1_STA + BITWIDTH_8 - 1;
    parameter BIAS_C3_STA = BIAS_C1_END + 1;
    parameter BIAS_C3_END = BIAS_C3_STA + BITWIDTH_16;
    parameter BIAS_C5_STA = BIAS_C3_END + 1;
    parameter BIAS_C5_END = BIAS_C5_STA + BITWIDTH_32 * OUTLEN - 1;

//----------------------------------------------------------------
// Ports
//----------------------------------------------------------------

    // Inputs
    reg clk_i;
    reg [IMG_C1_END - IMG_C1_STA : 0] img32_i;
    reg [IMG_S2_END - IMG_S2_STA : 0] img28_i;
    reg [IMG_C3_END - IMG_C3_STA : 0] img14_i;
    reg [IMG_S4_END - IMG_S4_STA : 0] img10_i;
    reg [IMG_C5_END - IMG_C5_STA : 0] img5_i;
    reg [7:0] result_i; // 需要分部读取并储存到cpu ram中
    reg [FLITER_C1_END - FLITER_C1_STA : 0] fliter_c1_i;
    reg [FLITER_C3_END - FLITER_C3_STA : 0] fliter_c3_i;
    reg [WEIGHT_C5_END - WEIGHT_C5_STA : 0] weight_c5_i;
    reg [BIAS_C1_END - BIAS_C1_STA : 0] bias_c1_i;
    reg [BIAS_C3_END - BIAS_C3_STA : 0] bias_c3_i;
    reg [BIAS_C5_END - BIAS_C5_STA : 0] bias_c5_i;

//----------------------------------------------------------------
// Includes
//----------------------------------------------------------------

`include "defs.v"

//----------------------------------------------------------------
// Registers / Wires
//----------------------------------------------------------------

    wire [IMG_C1_END - IMG_C1_STA : 0] img32_result;
    wire [IMG_S2_END - IMG_S2_STA : 0] img28_result;
    wire [IMG_C3_END - IMG_C3_STA : 0] img14_result;
    wire [IMG_S4_END - IMG_S4_STA : 0] img10_result;
    wire [IMG_C5_END - IMG_C5_STA : 0] img5_result;
    wire [RESULT_END - RESULT_STA : 0] final_result;

//----------------------------------------------------------------
// Circuits
//----------------------------------------------------------------

// Modules
c1 c1(
     .data(img32_i)
    ,.filterWeight(fliter_c1_i)
    ,.filterBias(bias_c1_i)
    ,.result(img28_result)
);

s2 s2(
     .data(img28_i)
    ,.result(img14_result)
);

c3 c3(
     .data(img14_i)
    ,.filterWeight(fliter_c3_i)
    ,.filterBias(bias_c3_i)
    ,.result(img10_result)
);

s4 s4(
     .data(img10_i)
    ,.result(img5_result)
);

c5 c5(
     .data(img5_i)
    ,.weight(weight_c5_i)
    ,.bias(bias_c5_i)
    ,.result(final_result)
);

// sys clock
always begin
    #5; clk_i = 0;
    #5; clk_i = 1;
end

initial begin
    clk_i = 0;
    img32_i = `IMAGE_DATA;
    img28_i = 0;
    img14_i = 0;
    img10_i = 0;
    img5_i = 0;
    result_i = 0;
    fliter_c1_i = `C1_FILTER_DATA;
    fliter_c3_i = `C3_FILTER_DATA;
    weight_c5_i = `C5_WEIGHT_DATA;
    bias_c1_i = 0;
    bias_c3_i = 0;
    bias_c5_i = 0;

    #CYCLE;
    img28_i = img28_result;
    #CYCLE;
    img14_i = img14_result;
    #CYCLE;
    img10_i = img10_result;
    #CYCLE;
    img5_i = img5_result;
    #CYCLE;
    result_i = final_result;

end

endmodule
