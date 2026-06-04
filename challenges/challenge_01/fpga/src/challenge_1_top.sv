// ============================================================
// CrashTech VLSI-2026 -- Challenge 1: Volt-Meter (FPGA side)
// ============================================================
module challenge_1_top (
    input           MAX10_CLK1_50,
    input   [9:0]   SW,
    input   [1:0]   KEY,
    output  [9:0]   LEDR,
    output  [7:0]   HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
    inout   [15:0]  ARDUINO_IO
);

    wire clk   = MAX10_CLK1_50;
    wire rst_n = KEY[0]; // Active low reset

    // ---- Arduino Header UART Pins ----
    wire uart_rx_in = ARDUINO_IO[0];
    assign ARDUINO_IO[0]    = 1'bz;       // Explicit input (tri-state buffer)
    assign ARDUINO_IO[1]    = 1'bz;       // Not transmitting to ESP32
    assign ARDUINO_IO[15:2] = 14'bz;      // Unused pins to high-Z

    // UART speed: 50 MHz clock / 9600 baud = 5208 clocks per bit
    localparam CLKS_PER_BIT = 13'd5208;

    // ================================================================
    //  UART RX Engine
    // ================================================================
    reg rx_s1, rx_s2;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin rx_s1 <= 1; rx_s2 <= 1; end
        else begin rx_s1 <= uart_rx_in; rx_s2 <= rx_s1; end
    end
    wire rx_bit = rx_s2;

    reg [1:0]  rx_state;
    reg [12:0] rx_clk_cnt;
    reg [2:0]  rx_bit_idx;
    reg [7:0]  rx_shift;
    reg        rx_done;
    reg [7:0]  rx_byte;

    localparam RX_IDLE  = 2'd0;
    localparam RX_START = 2'd1;
    localparam RX_DATA  = 2'd2;
    localparam RX_STOP  = 2'd3;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rx_state   <= RX_IDLE;
            rx_clk_cnt <= 0;
            rx_bit_idx <= 0;
            rx_shift   <= 0;
            rx_byte    <= 0;
            rx_done    <= 0;
        end else begin
            rx_done <= 0;
            case (rx_state)
                RX_IDLE: if (rx_bit == 0) begin
                    rx_clk_cnt <= 0;
                    rx_state   <= RX_START;
                end
                RX_START: begin
                    if (rx_clk_cnt == (CLKS_PER_BIT - 1) / 2) begin
                        if (rx_bit == 0) begin
                            rx_clk_cnt <= 0;
                            rx_bit_idx <= 0;
                            rx_state   <= RX_DATA;
                        end else
                            rx_state   <= RX_IDLE;
                    end else
                        rx_clk_cnt <= rx_clk_cnt + 1;
                end
                RX_DATA: begin
                    if (rx_clk_cnt == CLKS_PER_BIT - 1) begin
                        rx_clk_cnt <= 0;
                        rx_shift[rx_bit_idx] <= rx_bit;
                        if (rx_bit_idx == 7)
                            rx_state <= RX_STOP;
                        else
                            rx_bit_idx <= rx_bit_idx + 1;
                    end else
                        rx_clk_cnt <= rx_clk_cnt + 1;
                end
                RX_STOP: begin
                    if (rx_clk_cnt == CLKS_PER_BIT - 1) begin
                        rx_byte  <= rx_shift;
                        rx_done  <= 1;
                        rx_state <= RX_IDLE;
                    end else
                        rx_clk_cnt <= rx_clk_cnt + 1;
                end
            endcase
        end
    end

    // ================================================================
    //  UART Parser: Parses string of format "X.XX\n"
    // ================================================================
    reg [3:0] parsed_digit0;
    reg [3:0] parsed_digit1;
    reg [3:0] parsed_digit2;
    reg [1:0] rx_char_idx;

    reg [3:0] digit0; // Integer part
    reg [3:0] digit1; // First decimal
    reg [3:0] digit2; // Second decimal

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            parsed_digit0 <= 0;
            parsed_digit1 <= 0;
            parsed_digit2 <= 0;
            rx_char_idx   <= 0;
            digit0        <= 0;
            digit1        <= 0;
            digit2        <= 0;
        end else if (rx_done) begin
            if (rx_byte == 8'h0A || rx_byte == 8'h0D) begin
                // Newline or carriage return: update outputs
                digit0      <= parsed_digit0;
                digit1      <= parsed_digit1;
                digit2      <= parsed_digit2;
                rx_char_idx <= 0;
            end else if (rx_byte == 8'h2E) begin
                // Decimal point: skip
            end else if (rx_byte >= 8'h30 && rx_byte <= 8'h39) begin
                // Digit character '0'-'9'
                case (rx_char_idx)
                    2'd0: begin
                        parsed_digit0 <= rx_byte[3:0];
                        rx_char_idx   <= 2'd1;
                    end
                    2'd1: begin
                        parsed_digit1 <= rx_byte[3:0];
                        rx_char_idx   <= 2'd2;
                    end
                    2'd2: begin
                        parsed_digit2 <= rx_byte[3:0];
                        rx_char_idx   <= 2'd3;
                    end
                    default: ;
                endcase
            end
        end
    end

    // ================================================================
    //  7-segment Displays
    // ================================================================
    function [7:0] seg7;
        input [3:0] d;
        case (d)
            4'd0: seg7 = 8'b1100_0000;
            4'd1: seg7 = 8'b1111_1001;
            4'd2: seg7 = 8'b1010_0100;
            4'd3: seg7 = 8'b1011_0000;
            4'd4: seg7 = 8'b1001_1001;
            4'd5: seg7 = 8'b1001_0010;
            4'd6: seg7 = 8'b1000_0010;
            4'd7: seg7 = 8'b1111_1000;
            4'd8: seg7 = 8'b1000_0000;
            4'd9: seg7 = 8'b1001_0000;
            default: seg7 = 8'b1111_1111;
        endcase
    endfunction

    // Decode digits for HEX0, HEX1, HEX2 (with DP turned ON by setting bit 7 to 0)
    wire [7:0] seg7_d0 = seg7(digit0);
    assign HEX0 = seg7(digit2);
    assign HEX1 = seg7(digit1);
    assign HEX2 = {1'b0, seg7_d0[6:0]}; // Active-low DP is bit 7 (set to 0 for ON)

    // Blank out HEX3, HEX4, HEX5
    assign HEX3 = 8'hFF;
    assign HEX4 = 8'hFF;
    assign HEX5 = 8'hFF;

    // ================================================================
    //  Proportional LED Bar Graph
    // ================================================================
    wire [11:0] val_reg = (digit0 * 12'd100) + (digit1 * 12'd10) + digit2;

    assign LEDR[0] = (val_reg >= 12'd16);  // > 0.16V
    assign LEDR[1] = (val_reg >= 12'd49);  // > 0.49V
    assign LEDR[2] = (val_reg >= 12'd82);  // > 0.82V
    assign LEDR[3] = (val_reg >= 12'd115); // > 1.15V
    assign LEDR[4] = (val_reg >= 12'd148); // > 1.48V
    assign LEDR[5] = (val_reg >= 12'd181); // > 1.81V
    assign LEDR[6] = (val_reg >= 12'd214); // > 2.14V
    assign LEDR[7] = (val_reg >= 12'd247); // > 2.47V
    assign LEDR[8] = (val_reg >= 12'd280); // > 2.80V
    assign LEDR[9] = (val_reg >= 12'd313); // > 3.13V

endmodule
