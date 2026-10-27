`timescale 1ns/1ps

module sync_fifo_tb;

    reg clk;
    reg rst;
    reg wr_en;
    reg rd_en;
    reg [7:0] data_in;

    wire [7:0] data_out;
    wire full;
    wire empty;

    sync_fifo #(
        .DATA_WIDTH(8),
        .DEPTH(16)
    ) uut (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        wr_en = 0;
        rd_en = 0;
        data_in = 0;

        repeat (2) @(negedge clk);
        rst = 0;

        // Write three values
        @(negedge clk);
        wr_en = 1;
        data_in = 8'h11;

        @(negedge clk);
        data_in = 8'h22;

        @(negedge clk);
       
