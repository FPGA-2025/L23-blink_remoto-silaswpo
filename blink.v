module Blink #(
    parameter CLK_FREQ = 25_000_000
) (
    input wire clk,
    input wire rst_n,
    output reg [7:0] leds
);

reg [7:0] brightness [7:0]; // brilho individual
reg [7:0] pwm_counter;
reg [31:0] step_counter;
reg [3:0] index;
reg ascending;
integer i;

// PWM e controle de brilho
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pwm_counter  <= 0;
        step_counter <= 0;
        index        <= 0;
        ascending    <= 1;
brightness[0] <= 32;   // LED 0 = 12% brilho
brightness[1] <= 64;   // LED 1 = 25%
brightness[2] <= 96;   // LED 2 = 38%

brightness[3] <= 128;  // LED 3 = 50%
brightness[4] <= 160;  // LED 4 = 63%
brightness[5] <= 192;  // LED 5 = 75%
brightness[6] <= 224;  // LED 6 = 88%
brightness[7] <= 255;  // LED 7 = 100%

    end else begin
        pwm_counter <= pwm_counter + 1;

        for (i = 0; i < 8; i = i + 1)
            leds[i] <= (pwm_counter < brightness[i]);

        // Atualiza brilho a cada 2 segundos
        step_counter <= step_counter + 1;
        if (step_counter >= (CLK_FREQ * 2)) begin
            step_counter <= 0;

            if (ascending) begin
                brightness[index] <= 255;
                if (index == 7) begin
                    ascending <= 0;
                    index <= 0;
                end else begin
                    index <= index + 1;
                end
            end else begin
                brightness[index] <= 0;
                if (index == 7) begin
                    ascending <= 1;
                    index <= 0;
                end else begin
                    index <= index + 1;
                end
            end
        end
    end
end

endmodule
