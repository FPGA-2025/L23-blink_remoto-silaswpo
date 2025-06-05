module Blink #(
    parameter CLK_FREQ = 25_000_000
) (
    input wire clk,
    input wire rst_n,
    output reg [7:0] leds
);

// Parâmetros PWM
localparam PWM_RESOLUTION = 8;                // 8-bit PWM
localparam PWM_MAX = (1 << PWM_RESOLUTION)-1; // 255

// Tempo entre inversões da máscara (em ciclos de clock)
localparam SWITCH_TIME_CYCLES = CLK_FREQ * 4;

reg [31:0] counter;
reg [7:0] led_mask;               // Indica quais LEDs estão "ativos"
reg [7:0] brightness_level;       // Intensidade do brilho dos LEDs ativos
reg [PWM_RESOLUTION-1:0] pwm_counter;

always @(posedge clk) begin
    if (!rst_n) begin
        counter          <= 0;
        pwm_counter      <= 0;
        brightness_level <= PWM_MAX;
        led_mask         <= 8'b01010101; // Inicia com LEDs 0,2,4,6
    end else begin
        // PWM counter incrementa continuamente
        pwm_counter <= pwm_counter + 1;

        // Controle de intensidade (PWM por software)
        // led está "ligado" se: pwm_counter < brightness_level AND led_mask[i] = 1
        for (int i = 0; i < 8; i = i + 1) begin
            leds[i] <= (pwm_counter < brightness_level) ? led_mask[i] : 1'b0;
        end

        // Atualização da máscara e intensidade com o tempo
        counter <= counter + 1;
        if (counter >= SWITCH_TIME_CYCLES) begin
            counter <= 0;
            brightness_level <= PWM_MAX - brightness_level; // Inverte o brilho
            led_mask <= ~led_mask;                          // Inverte LEDs ativos
        end
    end
end

endmodule
