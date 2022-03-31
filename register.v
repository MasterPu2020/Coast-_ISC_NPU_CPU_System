
module register

//----------------------------------------------------------------
// Ports
//----------------------------------------------------------------

(
     clk_i
    ,rst_i
    ,en_w_reg_i
    ,w_reg_data_1_i
    ,w_reg_data_2_i
    ,w_reg_addr_1_i
    ,w_reg_addr_2_i
    ,r_reg_addr_1_i
    ,r_reg_addr_2_i
    ,r_reg_addr_3_i
    ,r_reg_addr_4_i
    ,r_reg_data_1_o
    ,r_reg_data_2_o
    ,r_reg_data_3_o
    ,r_reg_data_4_o
);

    // Inputs
    input clk_i;
    input rst_i;
    input en_w_reg_i;
    input [7:0] w_reg_data_1_i;
    input [7:0] w_reg_data_2_i;
    input [4:0] w_reg_addr_1_i;
    input [4:0] w_reg_addr_2_i;
    input [4:0] r_reg_addr_1_i;
    input [4:0] r_reg_addr_2_i;
    input [4:0] r_reg_addr_3_i;
    input [4:0] r_reg_addr_4_i;

    // Outputs
    output reg [7:0] r_reg_data_1_o;
    output reg [7:0] r_reg_data_2_o;
    output reg [7:0] r_reg_data_3_o;
    output reg [7:0] r_reg_data_4_o;

//----------------------------------------------------------------
// Includes
//----------------------------------------------------------------

`include "defs.v"

//----------------------------------------------------------------
// Registers / Wires
//----------------------------------------------------------------

reg [7:0] REG[31:0]; //8x32
integer row;

//----------------------------------------------------------------
// Circuits
//----------------------------------------------------------------

// Initialization
initial begin
    r_reg_data_1_o = 0;
    r_reg_data_2_o = 0;
    r_reg_data_3_o = 0;
    r_reg_data_4_o = 0;
    for(row = 0; row <= 31; row = row + 1)
        REG[row] = 0;
end

// Read and Write Controller
always @(posedge clk_i) begin
    if (rst_i == `RESET) begin
        r_reg_data_1_o <= 0;
        r_reg_data_2_o <= 0;
        r_reg_data_3_o <= 0;
        r_reg_data_4_o <= 0;
        for(row = 0; row <= 31; row = row + 1)
            REG[row] <= 0;
    end
    else if (en_w_reg_i == `EN_W) begin
        r_reg_data_1_o <= 0;
        r_reg_data_2_o <= 0;
        r_reg_data_3_o <= 0;
        r_reg_data_4_o <= 0;
        REG[w_reg_addr_1_i] <= w_reg_data_1_i;
        REG[w_reg_addr_2_i] <= w_reg_data_2_i;
    end
    else begin
        r_reg_data_1_o <= REG[r_reg_addr_1_i];
        r_reg_data_2_o <= REG[r_reg_addr_2_i];
        r_reg_data_3_o <= REG[r_reg_addr_3_i];
        r_reg_data_4_o <= REG[r_reg_addr_4_i];
    end
end

endmodule
