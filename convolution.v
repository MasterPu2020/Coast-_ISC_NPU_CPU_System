
// LeNet Convolution Operation

module convolution

//----------------------------------------------------------------
// Params
//----------------------------------------------------------------

#(
    parameter BITWIDTH = 8,
    parameter DATAWIDTH = 32,
    parameter DATAHEIGHT = 32,
    parameter CHANNEL1 = 1,
    parameter FILTERHEIGHT = 5,
    parameter FILTERWIDTH = 5,
    parameter FILTERBATCH = 1,
    parameter STRIDEHEIGHT = 1,
    parameter STRIDEWIDTH = 1,
    parameter PADDINGENABLE = 0
)

//----------------------------------------------------------------
// Ports
//----------------------------------------------------------------

(
    input [BITWIDTH * DATAWIDTH * DATAHEIGHT * CHANNEL1 - 1 : 0]data,
    input [BITWIDTH * FILTERHEIGHT * FILTERWIDTH * CHANNEL1 * FILTERBATCH - 1 : 0]filterWeight,
    input [BITWIDTH * FILTERBATCH - 1 : 0] filterBias,
    output wire [(BITWIDTH * 2) * FILTERBATCH * (PADDINGENABLE == 0 ? 
                                                (DATAWIDTH - FILTERWIDTH + 1) / STRIDEWIDTH : 
                                                (DATAWIDTH / STRIDEWIDTH))
                                                * (PADDINGENABLE == 0 ? 
                                                (DATAHEIGHT - FILTERHEIGHT + 1) / STRIDEHEIGHT : 
                                                (DATAHEIGHT / STRIDEHEIGHT)) - 1 
                                                :0] result
);

//----------------------------------------------------------------
// Registers / Wires
//----------------------------------------------------------------

wire [BITWIDTH - 1 : 0] dataArray[0 : CHANNEL1 - 1][0 : DATAHEIGHT-1][0 : DATAWIDTH - 1];

wire [BITWIDTH - 1 : 0] dataArrayWithPadding[0 : CHANNEL1 - 1]
                                            [0 : (PADDINGENABLE == 1 ? DATAHEIGHT + FILTERHEIGHT - 1 : DATAHEIGHT)-1]
                                            [0 : (PADDINGENABLE == 1 ? DATAWIDTH + FILTERWIDTH - 1 : DATAWIDTH)-1];

wire [BITWIDTH * FILTERHEIGHT * FILTERWIDTH * CHANNEL1 - 1 : 0] paramArray
                        [0: (PADDINGENABLE == 1 ? DATAHEIGHT / STRIDEHEIGHT: (DATAHEIGHT - FILTERHEIGHT + 1) / STRIDEHEIGHT)-1]
                        [0: (PADDINGENABLE == 1 ? DATAWIDTH / STRIDEWIDTH : (DATAWIDTH - FILTERWIDTH + 1) / STRIDEWIDTH)-1];

wire [BITWIDTH * CHANNEL1 * FILTERHEIGHT * FILTERWIDTH - 1 : 0] filterWeightArray[0: FILTERBATCH - 1];

wire [(BITWIDTH * 2) * FILTERBATCH * (PADDINGENABLE == 0 ? 
        (DATAWIDTH - FILTERWIDTH + 1) / STRIDEWIDTH : 
        (DATAWIDTH / STRIDEWIDTH)) 
    * 
        (PADDINGENABLE == 0 ? 
            (DATAHEIGHT - FILTERHEIGHT + 1) / STRIDEHEIGHT : 
            (DATAHEIGHT / STRIDEHEIGHT)) - 1 
    : 0] out;

genvar channel, row, col, d_row, d_col;

//----------------------------------------------------------------
// Circuits
//----------------------------------------------------------------

generate       
    for(channel = 0; channel < CHANNEL1; channel = channel + 1) begin
        for(row = 0; row < DATAHEIGHT; row = row + 1) begin
            for(col = 0; col < DATAWIDTH; col = col + 1) begin
                assign dataArray[channel][row][col] = data[(channel * DATAHEIGHT * DATAWIDTH + row * DATAHEIGHT + col) * BITWIDTH + BITWIDTH - 1:
                                                (channel * DATAHEIGHT * DATAWIDTH + row * DATAHEIGHT + col) * BITWIDTH];
            end
        end
    end      
endgenerate

generate
    for(channel = 0; channel < CHANNEL1; channel = channel + 1) begin
        for(d_row = 0; d_row < (PADDINGENABLE == 1 ? DATAHEIGHT + FILTERHEIGHT - 1 : DATAHEIGHT); d_row = d_row + 1) begin
            for(d_col = 0; d_col < (PADDINGENABLE == 1 ? DATAWIDTH + FILTERWIDTH - 1 : DATAWIDTH); d_col = d_col + 1) begin
                if(PADDINGENABLE == 1) begin
                    if(d_row < (FILTERHEIGHT / 2) || d_row > (DATAHEIGHT + FILTERHEIGHT / 2 - 1)) begin
                        assign dataArrayWithPadding[channel][d_row][d_col] = 0;
                    end
                    else if(d_col < (FILTERWIDTH / 2) || d_col > (DATAWIDTH + FILTERWIDTH / 2 - 1)) begin
                        assign dataArrayWithPadding[channel][d_row][d_col] = 0;
                    end
                    else begin
                        assign dataArrayWithPadding[channel][d_row][d_col] = dataArray[channel][d_row - FILTERHEIGHT / 2][d_col - FILTERWIDTH / 2];
                    end
                end
                else begin
                    assign dataArrayWithPadding[channel][d_row][d_col] = dataArray[channel][d_row][d_col];
                end
            end
        end
    end
endgenerate

generate
        for(row = FILTERHEIGHT / 2; row < (PADDINGENABLE == 1 ? DATAHEIGHT + FILTERHEIGHT - 1 - FILTERHEIGHT / 2: DATAHEIGHT - FILTERHEIGHT / 2); row = row + STRIDEHEIGHT) begin
            for(col = FILTERWIDTH / 2; col < (PADDINGENABLE == 1 ? DATAWIDTH + FILTERWIDTH - 1 - FILTERWIDTH / 2 : DATAWIDTH - FILTERWIDTH / 2); col = col + STRIDEWIDTH) begin
                for(channel = 0; channel < CHANNEL1; channel = channel + 1) begin
                    for(d_row = row - FILTERHEIGHT / 2; d_row <= row + FILTERHEIGHT / 2; d_row = d_row + 1) begin
                        for(d_col = col - FILTERWIDTH / 2; d_col <= col + FILTERWIDTH / 2; d_col = d_col + 1) begin
                            assign paramArray[(row - FILTERHEIGHT / 2) / STRIDEHEIGHT]
                                                [(col - FILTERWIDTH / 2) / STRIDEWIDTH]
                                                    [(channel * FILTERHEIGHT * FILTERWIDTH + (d_row - row + FILTERHEIGHT / 2) * FILTERWIDTH + (d_col - col + FILTERWIDTH / 2)) * BITWIDTH + BITWIDTH - 1:
                                                    (channel * FILTERHEIGHT * FILTERWIDTH + (d_row - row + FILTERHEIGHT / 2) * FILTERWIDTH + (d_col - col + FILTERWIDTH / 2)) * BITWIDTH] = 
                                dataArrayWithPadding[channel][d_row][d_col];
                        end
                    end
                end
            end
        end
endgenerate

generate 
    for(channel = 0; channel < FILTERBATCH; channel = channel + 1) begin
        assign filterWeightArray[channel] = filterWeight[(channel + 1) * CHANNEL1 * FILTERHEIGHT * FILTERWIDTH * BITWIDTH - 1: 
                                                    channel * CHANNEL1 * FILTERHEIGHT * FILTERWIDTH * BITWIDTH];
    end
endgenerate

// Convolution operation
generate
    for(channel = 0; channel < FILTERBATCH; channel = channel + 1) begin
        for(d_row = 0; d_row < (PADDINGENABLE == 1 ? DATAHEIGHT / STRIDEHEIGHT: (DATAHEIGHT - FILTERHEIGHT + 1) / STRIDEHEIGHT); d_row = d_row + 1) begin
            for(d_col = 0; d_col < (PADDINGENABLE == 1 ? DATAWIDTH / STRIDEWIDTH : (DATAWIDTH - FILTERWIDTH + 1) / STRIDEWIDTH); d_col = d_col + 1) begin
                    ConvKernel#(BITWIDTH, CHANNEL1, FILTERHEIGHT, FILTERWIDTH) convKernel(paramArray[d_row][d_col], 
                    filterWeightArray[channel], 
                    filterBias[(channel + 1) * BITWIDTH - 1 :channel * BITWIDTH],
                    out[(channel * (PADDINGENABLE == 1 ? DATAHEIGHT / STRIDEHEIGHT: (DATAHEIGHT - FILTERHEIGHT + 1) / STRIDEHEIGHT) 
                        * (PADDINGENABLE == 1 ? DATAWIDTH / STRIDEWIDTH : (DATAWIDTH - FILTERWIDTH + 1) / STRIDEWIDTH) * BITWIDTH * 2
                        + d_row * (PADDINGENABLE == 1 ? DATAWIDTH / STRIDEWIDTH : (DATAWIDTH - FILTERWIDTH + 1) / STRIDEWIDTH) 
                        * BITWIDTH * 2 + d_col * 2 * BITWIDTH) + 2 * BITWIDTH - 1
                        :
                        (channel * (PADDINGENABLE == 1 ? DATAHEIGHT / STRIDEHEIGHT: (DATAHEIGHT - FILTERHEIGHT + 1) / STRIDEHEIGHT)
                        * (PADDINGENABLE == 1 ? DATAWIDTH / STRIDEWIDTH : (DATAWIDTH - FILTERWIDTH + 1) / STRIDEWIDTH) 
                        * BITWIDTH * 2
                        + d_row * (PADDINGENABLE == 1 ? DATAWIDTH / STRIDEWIDTH : (DATAWIDTH - FILTERWIDTH + 1) / STRIDEWIDTH) 
                        * BITWIDTH * 2 + d_col * 2 * BITWIDTH)]
                    );
            end
        end            
    end
endgenerate
    
assign result = out;

endmodule
