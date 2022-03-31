

// LeNet Maximum Operation


module Max

//----------------------------------------------------------------
// Params
//----------------------------------------------------------------

#(
    parameter BITWIDTH = 8,
    parameter LENGTH = 4
)

//----------------------------------------------------------------
// Ports
//----------------------------------------------------------------

(
    input [BITWIDTH * LENGTH - 1 : 0] data,
    output reg [BITWIDTH - 1 : 0] result
);

//----------------------------------------------------------------
// Registers / Wires
//----------------------------------------------------------------

wire [BITWIDTH - 1:0] dataArray[0:LENGTH - 1];
genvar len;
integer row;

//----------------------------------------------------------------
// Circuits
//----------------------------------------------------------------

generate
    for(len = 0; len < LENGTH; len = len + 1) begin
        assign dataArray[len] = data[len * BITWIDTH + BITWIDTH - 1: len * BITWIDTH];
    end
endgenerate

always @(*) begin
    result = 0;
    for(row = 0; row < LENGTH; row = row + 1) begin
        if(dataArray[row] > result) begin
            result = dataArray[row];
        end
    end
end

endmodule
