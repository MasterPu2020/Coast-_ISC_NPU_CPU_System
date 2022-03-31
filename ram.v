
module ram

//----------------------------------------------------------------
// Ports
//----------------------------------------------------------------

(
     clk_i
    ,rst_i
    ,en_w_ram_i
    ,w_ram_data_i
    ,w_ram_addr_i
    ,r_ram_addr_i
    ,r_ram_data_o
);

    // Inputs
    input clk_i;
    input rst_i;
    input en_w_ram_i;
    input [7:0] w_ram_data_i;
    input [15:0] w_ram_addr_i;
    input [15:0] r_ram_addr_i;

    // Outputs
    output reg [7:0] r_ram_data_o;

//----------------------------------------------------------------
// Includes
//----------------------------------------------------------------

`include "defs.v"

//----------------------------------------------------------------
// Registers / Wires
//----------------------------------------------------------------

reg [7:0] RAM[`MAX_RAM_ADDR:0];
integer row;

//----------------------------------------------------------------
// Circuits
//----------------------------------------------------------------

// Initialization
initial begin
    r_ram_data_o = 0;
    for(row = 0; row <= `MAX_RAM_ADDR; row = row + 1)
        RAM[row] = 0;
end

// Read and Write Controller
always @(posedge clk_i) begin
    if (rst_i == `RESET) begin
        r_ram_data_o <= 0;
        for(row = 0; row <= `MAX_RAM_ADDR; row = row + 1)
            RAM[row] <= 0;
    end
    else if (en_w_ram_i == `EN_W) begin
        r_ram_data_o <= 0;
        RAM[w_ram_addr_i] <= w_ram_data_i;
    end
    else begin
        r_ram_data_o <= RAM[r_ram_addr_i];
    end
end

endmodule
