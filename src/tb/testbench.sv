module pe(
    input clk,
    input rst,
    input [7:0] a_in,
    input [7:0] b_in,
    input valid_in,
    output reg [7:0] a_out,
    output reg [7:0] b_out,
    output reg valid_out,
    output reg [31:0] acc
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        a_out<=0; b_out<=0; valid_out<=0; acc<=0;
    end else begin
        a_out    <= a_in;
        b_out    <= b_in;
        valid_out<= valid_in;
        if (valid_in) acc <= acc + (a_in * b_in);
    end
end
endmodule

module systolic_array(
    input clk,
    input rst,
    input [7:0] a_in [0:3],
    input [7:0] b_in [0:3],
    input valid_a [0:3],
    input valid_b [0:3],
    output [31:0] acc [0:3][0:3],
    output valid_out [0:3][0:3]
);

// Data wires
wire [7:0] a_wire [0:3][0:4];
wire [7:0] b_wire [0:4][0:3];

// Valid wires — registered through PEs
wire va [0:3][0:4];
wire vb [0:4][0:3];

// Combined valid per PE
wire valid_pe [0:3][0:3];

genvar i;
generate
    for (i=0; i<4; i=i+1) begin
        assign a_wire[i][0] = a_in[i];
        assign b_wire[0][i] = b_in[i];
        assign va[i][0]     = valid_a[i];
        assign vb[0][i]     = valid_b[i];
    end
endgenerate

genvar row, col;
generate
    for (row=0; row<4; row=row+1) begin : row_gen
        for (col=0; col<4; col=col+1) begin : col_gen

            // Valid fires when both A row and B col are valid
            assign valid_pe[row][col] = va[row][col] & vb[row][col];

            pe pe_inst(
                .clk(clk),
                .rst(rst),
                .a_in(a_wire[row][col]),
                .b_in(b_wire[row][col]),
                .valid_in(valid_pe[row][col]),
                .a_out(a_wire[row][col+1]),
                .b_out(b_wire[row+1][col]),
                .valid_out(valid_out[row][col]),
                .acc(acc[row][col])
            );

            // Valid propagates with data through registered PEs
            assign va[row][col+1] = valid_out[row][col];
            assign vb[row+1][col] = valid_out[row][col];
        end
    end
endgenerate
endmodule
