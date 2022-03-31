

// LeNet Singal Time Convolution Operation


module ConvKernel

//----------------------------------------------------------------
// Params
//----------------------------------------------------------------

#(
    parameter integer BITWIDTH = 8,   
    parameter integer DATACHANNEL = 1, 
    parameter integer FILTERHEIGHT = 5,
    parameter integer FILTERWIDTH = 5
)

//----------------------------------------------------------------
// Ports
//----------------------------------------------------------------

(
    input [BITWIDTH * DATACHANNEL * FILTERHEIGHT * FILTERWIDTH - 1 : 0] data,
    input [BITWIDTH * DATACHANNEL * FILTERHEIGHT * FILTERWIDTH - 1 : 0] weight,
    input [BITWIDTH - 1 : 0] bias,
    output [BITWIDTH * 2 -1 : 0]result
);

//----------------------------------------------------------------
// Registers / Wires
//----------------------------------------------------------------

wire [BITWIDTH * 2 - 1 : 0] out[FILTERHEIGHT * FILTERWIDTH * DATACHANNEL - 1 : 0];
wire [BITWIDTH * 2 - 1 : 0] sum_out[FILTERHEIGHT * FILTERWIDTH * DATACHANNEL : 0];
genvar conv_i;

//----------------------------------------------------------------
// Circuits
//----------------------------------------------------------------

assign sum_out[0] = 0;

generate
    for(conv_i = 0; conv_i < FILTERHEIGHT * FILTERWIDTH * DATACHANNEL; conv_i = conv_i + 1) begin
        Mult#(BITWIDTH) mult(
            data[(conv_i + 1) * BITWIDTH - 1 : conv_i * BITWIDTH], 
            weight[(conv_i + 1) * BITWIDTH - 1 : conv_i * BITWIDTH], 
            out[conv_i]);
        assign sum_out[conv_i + 1] = sum_out[conv_i] + out[conv_i];
    end
endgenerate

assign result = sum_out[FILTERHEIGHT * FILTERWIDTH * DATACHANNEL];

endmodule
