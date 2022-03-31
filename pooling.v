

// LeNet Pooling Operation


module pooling

//----------------------------------------------------------------
// Params
//----------------------------------------------------------------

#(
    parameter integer BITWIDTH = 16,
    parameter integer DATAWIDTH = 28,
    parameter integer DATAHEIGHT = 28,
    parameter integer CHANNEL = 1,
    parameter integer KWIDTH = 2,
    parameter integer KHEIGHT = 2
)

//----------------------------------------------------------------
// Ports
//----------------------------------------------------------------

(
    input [BITWIDTH * DATAWIDTH * DATAHEIGHT * CHANNEL - 1 : 0]data,
    output wire [BITWIDTH * DATAWIDTH / KWIDTH * DATAHEIGHT / KHEIGHT * CHANNEL - 1 : 0] result
);

//----------------------------------------------------------------
// Registers / Wires
//----------------------------------------------------------------

wire [BITWIDTH - 1 : 0] dataArray[0 : CHANNEL - 1][0 : DATAHEIGHT-1][0 : DATAWIDTH - 1];

wire [BITWIDTH * KHEIGHT * KWIDTH - 1 : 0]paramArray [0: CHANNEL - 1][0: DATAHEIGHT / KHEIGHT - 1][0: DATAWIDTH / KWIDTH - 1];

wire [BITWIDTH * DATAWIDTH / KWIDTH * DATAHEIGHT / KHEIGHT * CHANNEL - 1 : 0] out;

genvar channel, row, col, k_row, k_col;

//----------------------------------------------------------------
// Circuits
//----------------------------------------------------------------

generate
    for(channel = 0; channel < CHANNEL; channel = channel + 1) begin
        for(row = 0; row < DATAHEIGHT; row = row + 1) begin
            for(col = 0; col < DATAWIDTH; col = col + 1) begin
                assign dataArray[channel][row][col] = data[(channel * DATAHEIGHT * DATAWIDTH + row * DATAHEIGHT + col) * BITWIDTH + BITWIDTH - 1:(channel * DATAHEIGHT * DATAWIDTH + row * DATAHEIGHT + col) * BITWIDTH];
            end
        end
    end
endgenerate

generate
    for(channel = 0; channel < CHANNEL; channel = channel + 1) begin
        for(row = 0; row < DATAHEIGHT / KHEIGHT; row = row + 1) begin
            for(col = 0; col < DATAWIDTH / KWIDTH; col = col + 1) begin
                for(k_row = row * 2; k_row < row * 2 + KHEIGHT; k_row = k_row + 1) begin
                    for(k_col = col * 2; k_col < col * 2 + KWIDTH; k_col = k_col + 1) begin
                        assign paramArray[channel][row][col]
                        [((k_row - row * 2) * KWIDTH + k_col - col * 2) * BITWIDTH + BITWIDTH - 1:((k_row - row * 2) * KWIDTH + k_col - col * 2) * BITWIDTH]
                            = dataArray[channel][k_row][k_col];
                    end
                end
            end
        end
    end
endgenerate

generate
    for(channel = 0; channel < CHANNEL; channel = channel + 1) begin
        for(row = 0; row < DATAHEIGHT / KHEIGHT; row = row + 1) begin
            for(col = 0; col < DATAWIDTH / KWIDTH; col = col + 1) begin
                Max #(BITWIDTH, KHEIGHT * KWIDTH) max(paramArray[channel][row][col], out[(channel * DATAHEIGHT / KHEIGHT * DATAWIDTH / KWIDTH + row * DATAWIDTH / KWIDTH + col) * BITWIDTH + BITWIDTH - 1:(channel * DATAHEIGHT / KHEIGHT * DATAWIDTH / KWIDTH + row * DATAWIDTH / KWIDTH + col) * BITWIDTH]);
            end
        end
    end
endgenerate

assign result = out;

endmodule
