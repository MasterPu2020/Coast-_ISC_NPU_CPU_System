

// LeNet Full Connection (Micro Convolution)


module full_connection

//----------------------------------------------------------------
// Params
//----------------------------------------------------------------

#(
    parameter BITWIDTH = 32,
    parameter LENGTH = 25,
    parameter OUTLEN = 10,
    parameter CHANNEL1 = 1,
    parameter FILTERHEIGHT = 5,
    parameter FILTERWIDTH = 5
)

//----------------------------------------------------------------
// Ports
//----------------------------------------------------------------

(
    input [BITWIDTH * LENGTH - 1 : 0] data,
    input [BITWIDTH * LENGTH * OUTLEN - 1 : 0] weight,
    input [BITWIDTH * OUTLEN - 1 : 0] bias,
    output wire [BITWIDTH * 2 * OUTLEN - 1 : 0] result
);

//----------------------------------------------------------------
// Registers / Wires
//----------------------------------------------------------------

wire [BITWIDTH * LENGTH * 2 - 1:0] out [0:OUTLEN - 1];

genvar row, col, number;

//----------------------------------------------------------------
// Circuits
//----------------------------------------------------------------

generate
    for (number = 0; number < OUTLEN; number = number + 1) begin
        ConvKernel#(BITWIDTH, CHANNEL1, FILTERHEIGHT, FILTERWIDTH) convKernel(
            data, 
            weight[number * LENGTH * BITWIDTH + LENGTH * BITWIDTH - 1 : number * LENGTH * BITWIDTH],
            bias[number * BITWIDTH + BITWIDTH - 1 : number * BITWIDTH],
            out[number]
        );
    end
endgenerate

generate
    for (number = 0; number < OUTLEN; number = number + 1) begin
        assign result[number * 2 * BITWIDTH + 2 * BITWIDTH - 1 : number * 2 * BITWIDTH] = out[number];
    end
endgenerate

endmodule
