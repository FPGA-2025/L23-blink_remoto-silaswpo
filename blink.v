/*module Blink #(
    parameter CLK_FREQ = 25_000_000 
) (
    input wire clk,
    input wire rst_n,
    output reg [7:0] leds
);

    
endmodule
*/
module Blink #(
    parameter CLK_FREQ = 25_000_000 // clock da placa (25 MHz)
) (
    input wire clk,
    input wire rst_n,
    output reg [7:0] leds          // 8 LEDs disponíveis
);

// Parâmetros para tempo de contagem
localparam ONE_SECOND  = CLK_FREQ;
localparam HALF_SECOND = CLK_FREQ / 2; // Pisca a cada 0.5s

reg [31:0] counter;

always @(posedge clk) begin
    if (!rst_n) begin
        counter <= 32'h0;
        leds    <= 8'b0;
    end else begin
        // Modifique aqui a velocidade de piscar:
        if (counter >= HALF_SECOND - 1) begin
            counter <= 32'h0;

            // Modifique aqui quais LEDs piscam:
            //leds[0] <= ~leds[0];  // pisca apenas o LED 0
             leds <= ~leds;     // todos os LEDs piscam juntos
            // leds[3] <= ~leds[3]; // apenas o LED 3 pisca
        end else begin
            counter <= counter + 1;
        end
    end
end

endmodule
