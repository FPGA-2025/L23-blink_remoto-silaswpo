module Blink #(
    parameter CLK_FREQ = 25_000_000
) (
    input wire clk,
    input wire rst_n,
    output reg [7:0] leds
);

localparam PWM_RESOLUTION = 8;
localparam PWM_MAX = (1 << PWM_RESOLUTION)-1;
localparam FADE_INTERVAL_CYCLES = CLK_FREQ / 1000;  // ajusta o tempo de subida/descida
localparam FADE_STEP = 1;

reg [7:0] led_mask = 8'b01010101;
reg [7:0] brightness_a = PWM_MAX;  // grupo 1: começa aceso
reg [7:0] brightness_b = 8'd0;     // grupo 2: começa apagado
reg [PWM_RESOLUTION-1:0] pwm_counter;


reg [31:0] fade_counter;
integer i;


always @(posedge clk) begin
    if (!rst_n) begin
        pwm_counter  <= 0;
        fade_counter <= 0;
        brightness_a <= PWM_MAX;
        brightness_b <= 0;
        led_mask     <= 8'b01010101;
    end else begin
        pwm_counter <= pwm_counter + 1;

        // PWM: controlar brilho dos LEDs usando duas máscaras
        for (i = 0; i < 8; i = i + 1) begin
            if (led_mask[i])
                leds[i] <= (pwm_counter < brightness_a) ? 1'b1 : 1'b0;
            else
                leds[i] <= (pwm_counter < brightness_b) ? 1'b1 : 1'b0;
        end

        // Lógica de fade-in/fade-out gradual
        fade_counter <= fade_counter + 1;
        if (fade_counter >= FADE_INTERVAL_CYCLES) begin
            fade_counter <= 0;

            if (brightness_a > 0)
                brightness_a <= brightness_a - FADE_STEP;
            if (brightness_b < PWM_MAX)
                brightness_b <= brightness_b + FADE_STEP;

            // Quando troca de papel: inverte máscaras
            if (brightness_a == 0 && brightness_b == PWM_MAX) begin
                brightness_a <= PWM_MAX;
                brightness_b <= 0;
                led_mask <= ~led_mask;
            end
        end
    end
end

endmodule
