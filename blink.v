module BlinkPWM #(
    parameter CLK_FREQ = 25_000_000
) (
    input wire clk,
    input wire rst_n,
    output reg [7:0] leds
);

reg [7:0] brightness [7:0]; // brilho individual de cada LED
reg [7:0] pwm_counter;
reg [31:0] slow_counter;

// Inicializar brilho
integer i;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pwm_counter <= 0;
        slow_counter <= 0;
        
        for (i = 0; i < 8; i = i + 1)
            brightness[i] <= i * 32;  // exemplo: brilho crescente
    end else begin
        pwm_counter <= pwm_counter + 1;

        // LED PWM: acende se contador < brilho
        for (i = 0; i < 8; i = i + 1)
            leds[i] <= (pwm_counter < brightness[i]);

        // Exemplo opcional: variar brilho lentamente
        slow_counter <= slow_counter + 1;
        if (slow_counter == CLK_FREQ) begin // a cada 1 segundo
            for (i = 0; i < 8; i = i + 1)
                brightness[i] <= brightness[i] + 8;
            slow_counter <= 0;
        end
    end
end

endmodule
