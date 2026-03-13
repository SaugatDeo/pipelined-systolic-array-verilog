module tb_systolic;

reg clk, rst;
reg [7:0] a_in [0:3];
reg [7:0] b_in [0:3];
reg valid_a [0:3];
reg valid_b [0:3];
wire [31:0] acc [0:3][0:3];
wire valid_out [0:3][0:3];

systolic_array uut(
    .clk(clk), .rst(rst),
    .a_in(a_in), .b_in(b_in),
    .valid_a(valid_a), .valid_b(valid_b),
    .acc(acc), .valid_out(valid_out)
);

always #5 clk = ~clk;
integer i, j, cycle;

// Feed arrays — precomputed from Python simulation
reg [7:0] a_feed [0:3][0:9];
reg [7:0] b_feed [0:3][0:9];
reg       va_feed[0:3][0:9];
reg       vb_feed[0:3][0:9];

initial begin
    clk=0; rst=1;
    for(i=0;i<4;i=i+1) begin
        a_in[i]=0; b_in[i]=0;
        valid_a[i]=0; valid_b[i]=0;
        for(j=0;j<10;j=j+1) begin
            a_feed[i][j]=0; b_feed[i][j]=0;
            va_feed[i][j]=0; vb_feed[i][j]=0;
        end
    end

    // Row 0 of A: starts cycle 0
    a_feed[0][0]=1; a_feed[0][1]=2; a_feed[0][2]=3; a_feed[0][3]=4;
    va_feed[0][0]=1; va_feed[0][1]=1; va_feed[0][2]=1; va_feed[0][3]=1;

    // Row 1 of A: starts cycle 1
    a_feed[1][1]=5; a_feed[1][2]=6; a_feed[1][3]=7; a_feed[1][4]=8;
    va_feed[1][1]=1; va_feed[1][2]=1; va_feed[1][3]=1; va_feed[1][4]=1;

    // Row 2 of A: starts cycle 2
    a_feed[2][2]=1; a_feed[2][3]=2; a_feed[2][4]=1; a_feed[2][5]=2;
    va_feed[2][2]=1; va_feed[2][3]=1; va_feed[2][4]=1; va_feed[2][5]=1;

    // Row 3 of A: starts cycle 3
    a_feed[3][3]=3; a_feed[3][4]=4; a_feed[3][5]=3; a_feed[3][6]=4;
    va_feed[3][3]=1; va_feed[3][4]=1; va_feed[3][5]=1; va_feed[3][6]=1;

    // Col 0 of B (Identity): B[0][0]=1, rest 0
    b_feed[0][0]=1; b_feed[0][1]=0; b_feed[0][2]=0; b_feed[0][3]=0;
    vb_feed[0][0]=1; vb_feed[0][1]=1; vb_feed[0][2]=1; vb_feed[0][3]=1;

    // Col 1 of B: B[1][1]=1, rest 0 — starts cycle 1
    b_feed[1][1]=0; b_feed[1][2]=1; b_feed[1][3]=0; b_feed[1][4]=0;
    vb_feed[1][1]=1; vb_feed[1][2]=1; vb_feed[1][3]=1; vb_feed[1][4]=1;

    // Col 2 of B: B[2][2]=1, rest 0 — starts cycle 2
    b_feed[2][2]=0; b_feed[2][3]=0; b_feed[2][4]=1; b_feed[2][5]=0;
    vb_feed[2][2]=1; vb_feed[2][3]=1; vb_feed[2][4]=1; vb_feed[2][5]=1;

    // Col 3 of B: B[3][3]=1, rest 0 — starts cycle 3
    b_feed[3][3]=0; b_feed[3][4]=0; b_feed[3][5]=0; b_feed[3][6]=1;
    vb_feed[3][3]=1; vb_feed[3][4]=1; vb_feed[3][5]=1; vb_feed[3][6]=1;

    #10; rst=0; #10;

    // Feed cycle by cycle
    for(cycle=0; cycle<10; cycle=cycle+1) begin
        for(i=0;i<4;i=i+1) begin
            a_in[i]   = a_feed[i][cycle];
            b_in[i]   = b_feed[i][cycle];
            valid_a[i]= va_feed[i][cycle];
            valid_b[i]= vb_feed[i][cycle];
        end
        #10;
    end

    // Zero everything
    for(i=0;i<4;i=i+1) begin
        a_in[i]=0; b_in[i]=0;
        valid_a[i]=0; valid_b[i]=0;
    end

    // Wait for pipeline to flush — 2 extra cycles per stage
    #80;

    $display("=== Pipelined Systolic Array: A x I ===");
    $display("Expected:");
    $display("1 2 3 4");
    $display("5 6 7 8");
    $display("1 2 1 2");
    $display("3 4 3 4");
    $display("Got:");
    for(i=0;i<4;i=i+1) begin
        $display("%0d %0d %0d %0d",
            acc[i][0], acc[i][1], acc[i][2], acc[i][3]);
    end

    $finish;
end
endmodule
