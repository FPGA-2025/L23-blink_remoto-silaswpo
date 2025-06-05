module Blink #(
    parameter CLK_FREQ = 25_000_000
) (
    input wire clk,
    input wire rst_n,
    output reg [7:0] leds
);

localparam PWM_RESOLUTION = 8;
localparam PWM_MAX = (1 << PWM_RESOLUTION)-1;
localparam SWITCH_TIME_CYCLES = CLK_FREQ * 4;

reg [31:0] counter;
reg [7:0] led_mask;
reg [7:0] brightness_level;
reg [PWM_RESOLUTION-1:0] pwm_counter;

integer i; // <- declaração obrigatória para uso no for loop abaixo

always @(posedge clk) begin
    if (!rst_n) begin
        counter          <= 0;
        pwm_counter      <= 0;
        brightness_level <= PWM_MAX;
        led_mask         <= 8'b01010101;
    end else begin
        pwm_counter <= pwm_counter + 1;

        for (i = 0; i < 8; i = i + 1) begin
            leds[i] <= (pwm_counter < brightness_level) ? led_mask[i] : 1'b0;
        end

        counter <= counter + 1;
        if (counter >= SWITCH_TIME_CYCLES) begin
            counter <= 0;
            brightness_level <= PWM_MAX - brightness_level;
            led_mask <= ~led_mask;
        end
    end
end

endmodule
