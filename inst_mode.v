
module inst_mode

//----------------------------------------------------------------
// Ports
//----------------------------------------------------------------

(
     clk_i
    ,rst_i
    ,mode_sel_i
    ,imm_inst_i
    ,rom_inst_i
    ,inst_o
);

    // Inputs
    input clk_i;
    input rst_i;
    input mode_sel_i;
    input [31:0] imm_inst_i;
    input [31:0] rom_inst_i;

    // Outputs
    output [31:0] inst_o;

//----------------------------------------------------------------
// Includes
//----------------------------------------------------------------

`include "defs.v"

//----------------------------------------------------------------
// Registers / Wires
//----------------------------------------------------------------

reg [1:0] bubble_counter;

//----------------------------------------------------------------
// Circuits
//----------------------------------------------------------------

initial begin
    bubble_counter = 0;
end

always @(posedge clk_i) begin
    if (rst_i == `RESET) begin
        bubble_counter = 0;
    end
    else if(mode_sel_i == `ROM_INST_sel) begin
        if (bubble_counter == 3) begin
            bubble_counter = 0;
        end
        else begin
            bubble_counter = bubble_counter + 1;
        end
    end
    else begin
        bubble_counter = 0;
    end
end

assign inst_o = (bubble_counter == 0)?((mode_sel_i)?rom_inst_i:imm_inst_i):`I_WAIT_STAY;

endmodule
