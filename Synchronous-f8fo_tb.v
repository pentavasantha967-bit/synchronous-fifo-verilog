module tb_fifo;
    reg [15:0] data_in;
    reg clk;
    reg rst;
    reg rd_en;
    reg wr_en;
    wire [15:0] dout;
    wire full;
    wire empty;

    // Instantiate the 16x16 FIFO module
    fifo uut (
        .data_in(data_in),
        .clk(clk),
        .rst(rst),
        .rd_en(rd_en),
        .wr_en(wr_en),
        .dout(dout),
        .full(full),
        .empty(empty)
    );

    // Generate Clock: 10ns period (100 MHz)
    always #5 clk = ~clk;

    initial begin
        // Monitor signals in the transcript window
        $monitor("Time=%0t | rst=%b | wr=%b rd=%b | data_in=%h | dout=%h | full=%b empty=%b", 
                  $time, rst, wr_en, rd_en, data_in, dout, full, empty);

        // Initialize signals
        clk = 0;
        rst = 1;
        wr_en = 0;
        rd_en = 0;
        data_in = 16'h0000;

        #12 rst = 0; // Release reset

        // ==========================================
        // TEST CASE 1: Fill FIFO & Test Overflow
        // ==========================================
        $display("\n--- TEST CASE 1: Filling 16 items & Testing Overflow ---");
        repeat (16) begin
            @(posedge clk);
            wr_en = 1;
            data_in = data_in + 16'h0001; // Data values: 1, 2, 3 ... 16
        end
        
        @(posedge clk);
        // At this point, FIFO is FULL. Try writing a 17th item (Overflow test)
        data_in = 16'hDEAD; 
        wr_en = 1; // Should be blocked by 'full' flag
        
        @(posedge clk);
        wr_en = 0; // Stop writing

        #20;

        // ==========================================
        // TEST CASE 2: Empty FIFO & Test Underflow
        // ==========================================
        $display("\n--- TEST CASE 2: Reading 16 items & Testing Underflow ---");
        repeat (16) begin
            @(posedge clk);
            rd_en = 1;
        end
        
        @(posedge clk);
        // At this point, FIFO is EMPTY. Try reading again (Underflow test)
        rd_en = 1; // Should be blocked by 'empty' flag
        
        @(posedge clk);
        rd_en = 0;

        #20;

        // ==========================================
        // TEST CASE 3: Simultaneous Read & Write
        // ==========================================
        $display("\n--- TEST CASE 3: Simultaneous Read & Write ---");
        // Write two items first so it has data
        @(posedge clk); wr_en = 1; data_in = 16'hAAAA;
        @(posedge clk); wr_en = 1; data_in = 16'hBBBB;
        
        // Execute Read and Write on the exact same clock edge
        @(posedge clk);
        wr_en = 1; rd_en = 1;
        data_in = 16'hCCCC; // Writing CCCC while reading out AAAA

        @(posedge clk);
        wr_en = 0; rd_en = 0;

        #40;
        $finish;
    end

endmodule
