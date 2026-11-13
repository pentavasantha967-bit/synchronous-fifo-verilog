module fifo (
    input [15:0] data_in,
    input clk,
    input rst,          // Resets pointers and flags
    input rd_en,
    input wr_en,
    output reg [15:0] dout,
    output reg full,
    output reg empty
);

    // 5-bit pointers: [4] is the lap/wrap-around bit, [3:0] are the 16 memory addresses (0 to 15)
    reg [4:0] rp, wp;
    
    // 16 rows deep, each row is 16 bits wide (0 to 15)
    reg [15:0] mem [15:0]; 

    // Flag generation logic
    always @(*) begin
        full  = (rp[3:0] == wp[3:0]) && (rp[4] != wp[4]);
        empty = (rp == wp);
    end

    // Synchronous operations on clock edge
    always @(posedge clk) begin
        if (rst) begin
            rp <= 5'b00000;
            wp <= 5'b00000;
            dout <= 16'h0000;
        end else begin
            case ({wr_en, rd_en})
                2'b10: begin // Write Only
                    if (!full) begin
                        mem[wp[3:0]] <= data_in;
                        wp <= wp + 1;
                    end
                end
                
                2'b01: begin // Read Only
                    if (!empty) begin
                        dout <= mem[rp[3:0]];
                        rp <= rp + 1;
                    end
                end
                
                2'b11: begin // Simultaneous Read & Write
                    if (full) begin
                        // Full state: can't write, but can read
                        dout <= mem[rp[3:0]];
                        rp <= rp + 1;
                    end else if (empty) begin
                        // Empty state: can't read, but can write
                        mem[wp[3:0]] <= data_in;
                        wp <= wp + 1;
                    end else begin
                        // Normal state: do both concurrently
                        mem[wp[3:0]] <= data_in;
                        dout <= mem[rp[3:0]];
                        wp <= wp + 1;
                        rp <= rp + 1;
                    end
                end
                
                2'b00: begin // Idle
                    wp <= wp;
                    rp <= rp;
                end
            endcase
        end
    end

endmodule
