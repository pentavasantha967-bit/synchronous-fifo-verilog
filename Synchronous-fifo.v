module sync_fifo #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH = 16
)(
    input wire clk,
    input wire rst,
    input wire wr_en,
    input wire rd_en,
    input wire [DATA_WIDTH-1:0] data_in,
    output reg [DATA_WIDTH-1:0] data_out,
    output wire full,
    output wire empty
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam COUNT_WIDTH = $clog2(DEPTH + 1);

    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];
    reg [ADDR_WIDTH-1:0] wr_ptr;
    reg [ADDR_WIDTH-1:0] rd_ptr;
    reg [COUNT_WIDTH-1:0] count;

    assign full  = (count == DEPTH);
    assign empty = (count == 0);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wr_ptr  <= 0;
            rd_ptr  <= 0;
            count   <= 0;
            data_out <= 0;
        end
        else begin
            case ({wr_en && !full, rd_en && !empty})
                2'b10: begin
                    mem[wr_ptr] <= data_in;
                    wr_ptr <= (wr_ptr == DEPTH-1) ? 0 : wr_ptr + 1'b1;
                    count <= count + 1'b1;
                end

                2'b01: begin
                    data_out <= mem[rd_ptr];
                    rd_ptr <= (rd_ptr == DEPTH-1) ? 0 : rd_ptr + 1'b1;
                    count <= count - 1'b1;
                end

                2'b11: begin
                    mem[wr_ptr] <= data_in;
                    data_out <= mem[rd_ptr];

                    wr_ptr <= (wr_ptr == DEPTH-1) ? 0 : wr_ptr + 1'b1;
                    rd_ptr <= (rd_ptr == DEPTH-1) ? 0 : rd_ptr + 1'b1;
                end

                default: begin
                    // No valid read or write operation.
                end
            endcase
        end
    end

endmodule
