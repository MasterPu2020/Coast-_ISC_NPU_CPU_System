
module NPU_ram

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
    ,en_w_i
    ,w_line_i
    ,r_rslt_addr_i
    ,img32_data_i
    ,img28_data_i
    ,img14_data_i
    ,img10_data_i
    ,img5_data_i
    ,fliter_c1_data_i
    ,fliter_c3_data_i
    ,weight_c5_data_i
    ,bias_c1_data_i
    ,bias_c3_data_i
    ,bias_c5_data_i
    ,result_data_i

    ,img32_o
    ,img28_o
    ,img14_o
    ,img10_o
    ,img5_o
    ,result_o
    ,fliter_c1_o
    ,fliter_c3_o
    ,weight_c5_o
    ,bias_c1_o
    ,bias_c3_o
    ,bias_c5_o
);

    // Inputs
    input clk_i;
    input rst_i;
    input en_w_i;
    input [3:0] w_line_i;
    input [7:0] r_rslt_addr_i;
    input [`IMG_C1_END - `IMG_C1_STA : 0] img32_data_i;
    input [`IMG_S2_END - `IMG_S2_STA : 0] img28_data_i;
    input [`IMG_C3_END - `IMG_C3_STA : 0] img14_data_i;
    input [`IMG_S4_END - `IMG_S4_STA : 0] img10_data_i;
    input [`IMG_C5_END - `IMG_C5_STA : 0] img5_data_i;
    input [`FLITER_C1_END - `FLITER_C1_STA : 0] fliter_c1_data_i;
    input [`FLITER_C3_END - `FLITER_C3_STA : 0] fliter_c3_data_i;
    input [`WEIGHT_C5_END - `WEIGHT_C5_STA : 0] weight_c5_data_i;
    input [`BIAS_C1_END - `BIAS_C1_STA : 0] bias_c1_data_i;
    input [`BIAS_C3_END - `BIAS_C3_STA : 0] bias_c3_data_i;
    input [`BIAS_C5_END - `BIAS_C5_STA : 0] bias_c5_data_i;
    input [`RESULT_END - `RESULT_STA : 0] result_data_i;

    // Outputs
    output reg [`IMG_C1_END - `IMG_C1_STA : 0] img32_o;
    output reg [`IMG_S2_END - `IMG_S2_STA : 0] img28_o;
    output reg [`IMG_C3_END - `IMG_C3_STA : 0] img14_o;
    output reg [`IMG_S4_END - `IMG_S4_STA : 0] img10_o;
    output reg [`IMG_C5_END - `IMG_C5_STA : 0] img5_o;
    output reg [7:0] result_o;
    output reg [`FLITER_C1_END - `FLITER_C1_STA : 0] fliter_c1_o;
    output reg [`FLITER_C3_END - `FLITER_C3_STA : 0] fliter_c3_o;
    output reg [`WEIGHT_C5_END - `WEIGHT_C5_STA : 0] weight_c5_o;
    output reg [`BIAS_C1_END - `BIAS_C1_STA : 0] bias_c1_o;
    output reg [`BIAS_C3_END - `BIAS_C3_STA : 0] bias_c3_o;
    output reg [`BIAS_C5_END - `BIAS_C5_STA : 0] bias_c5_o;

//----------------------------------------------------------------
// Registers / Wires
//----------------------------------------------------------------

reg [`IMG_C1_END - `IMG_C1_STA : 0] IMG_C1_RAM;
reg [`IMG_S2_END - `IMG_S2_STA : 0] IMG_S2_RAM;
reg [`IMG_C3_END - `IMG_C3_STA : 0] IMG_C3_RAM;
reg [`IMG_S4_END - `IMG_S4_STA : 0] IMG_S4_RAM;
reg [`IMG_C5_END - `IMG_C5_STA : 0] IMG_C5_RAM;
reg [`RESULT_END - `RESULT_STA : 0] RESULT_RAM;
reg [`FLITER_C1_END - `FLITER_C1_STA : 0] FLITER_C1_RAM;
reg [`FLITER_C3_END - `FLITER_C3_STA : 0] FLITER_C3_RAM;
reg [`WEIGHT_C5_END - `WEIGHT_C5_STA : 0] WEIGHT_C5_RAM;
reg [`BIAS_C1_END - `BIAS_C1_STA : 0] BIAS_C1_RAM;
reg [`BIAS_C3_END - `BIAS_C3_STA : 0] BIAS_C3_RAM;
reg [`BIAS_C5_END - `BIAS_C5_STA : 0] BIAS_C5_RAM;

wire [7:0] RESULT_OUTPUT[79:0];

integer row;
genvar i;

//----------------------------------------------------------------
// Circuits
//----------------------------------------------------------------

// Initialization
initial begin
    IMG_C1_RAM = 0;
    IMG_S2_RAM = 0;
    IMG_C3_RAM = 0;
    IMG_S4_RAM = 0;
    IMG_C5_RAM = 0;
    FLITER_C1_RAM = 0;
    FLITER_C3_RAM = 0;
    WEIGHT_C5_RAM = 0;
    BIAS_C1_RAM = 0;
    BIAS_C3_RAM = 0;
    BIAS_C5_RAM = 0;
    RESULT_RAM = 0;
end

// Read and Write Controller
always @(posedge clk_i) begin
    if (rst_i == `RESET) begin
        IMG_C1_RAM = 0;
        IMG_S2_RAM = 0;
        IMG_C3_RAM = 0;
        IMG_S4_RAM = 0;
        IMG_C5_RAM = 0;
        FLITER_C1_RAM = 0;
        FLITER_C3_RAM = 0;
        WEIGHT_C5_RAM = 0;
        BIAS_C1_RAM = 0;
        BIAS_C3_RAM = 0;
        BIAS_C5_RAM = 0;
        RESULT_RAM = 0;
    end
    else if (en_w_i == 1) begin
        case (w_line_i)
            `IMG_C1_LINE: begin
                IMG_C1_RAM = img32_data_i;
            end
            `IMG_S2_LINE: begin
                IMG_S2_RAM = img28_data_i;
            end
            `IMG_C3_LINE: begin
                IMG_C3_RAM = img14_data_i;
            end
            `IMG_S4_LINE: begin
                IMG_S4_RAM = img10_data_i;
            end
            `IMG_C5_LINE: begin
                IMG_C5_RAM = img5_data_i;
            end
            `FLITER_C1_LINE: begin
                FLITER_C1_RAM = fliter_c1_data_i;
            end
            `FLITER_C3_LINE: begin
                FLITER_C3_RAM = fliter_c3_data_i;
            end
            `WEIGHT_C5_LINE: begin
                WEIGHT_C5_RAM = weight_c5_data_i;
            end
            `BIAS_C1_LINE: begin
                BIAS_C1_RAM = bias_c1_data_i;
            end
            `BIAS_C3_LINE: begin
                BIAS_C3_RAM = bias_c3_data_i;
            end
            `BIAS_C5_LINE: begin
                BIAS_C5_RAM = bias_c5_data_i;
            end
            `RESULT_LINE: begin
                RESULT_RAM = result_data_i;
            end
            default: begin
                img32_o = 0;
                img28_o = 0;
                img14_o = 0;
                img10_o = 0;
                img5_o = 0;
                fliter_c1_o = 0;
                fliter_c3_o = 0;
                weight_c5_o = 0;
                bias_c1_o = 0;
                bias_c3_o = 0;
                bias_c5_o = 0;
                result_o = 0;
            end
        endcase
    end
    else begin
        img32_o = IMG_C1_RAM;
        img28_o = IMG_S2_RAM;
        img14_o = IMG_C3_RAM;
        img10_o = IMG_S4_RAM;
        img5_o = IMG_C5_RAM;
        fliter_c1_o = FLITER_C1_RAM;
        fliter_c3_o = FLITER_C3_RAM;
        weight_c5_o = WEIGHT_C5_RAM;
        bias_c1_o = BIAS_C1_RAM;
        bias_c3_o = BIAS_C3_RAM;
        bias_c5_o = BIAS_C5_RAM;
        result_o = RESULT_OUTPUT[r_rslt_addr_i];
    end
end

generate
    for (i = 0; i < 80; i = i + 1) begin
        assign RESULT_OUTPUT[i] = RESULT_RAM[i * `BITWIDTH_8 + `BITWIDTH_8 - 1 : i * `BITWIDTH_8];
    end
endgenerate


endmodule
