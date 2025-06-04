module Blink #(
    parameter CLK_FREQ = 25_000_000  // Clock fixo da FPGA
) (
    input wire clk,
    input wire rst_n,
    output reg [7:0] leds
);

localparam ON_TIME_CYCLES  = CLK_FREQ * 4; // 4 segundos
localparam OFF_TIME_CYCLES = CLK_FREQ * 2; // 2 segundos

reg [31:0] counter;
reg led_on;

always @(posedge clk) begin
    if (!rst_n) begin
        counter <= 32'd0;
        led_on  <= 1'b1;
        leds    <= 8'b01010101; // Liga LEDs 0,2,4,6
    end else begin
        counter <= counter + 1;

        if (led_on && counter >= ON_TIME_CYCLES) begin
            counter <= 0;
            led_on  <= 1'b0;
            leds    <= 8'b11100000; // Desliga todos
        end else if (!led_on && counter >= OFF_TIME_CYCLES) begin
            counter <= 0;
            led_on  <= 1'b1;
            leds    <= 8'b01111111; // Liga 0,2,4,6
        end
    end
end

endmodule
