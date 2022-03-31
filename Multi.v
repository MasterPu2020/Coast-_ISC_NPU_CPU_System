
// LeNet Multiplier

module Mult

#(
    parameter BITWIDTH = 8
)

(
    input [BITWIDTH-1:0] a,
    input [BITWIDTH-1:0] b,
    output [BITWIDTH * 2 - 1:0] c
);
    
assign c = a * b;
    
endmodule