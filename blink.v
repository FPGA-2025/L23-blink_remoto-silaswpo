module Blink #(
    parameter CLK_FREQ = 25_000_000
) (
    input wire clk,
    input wire rst_n,
    output reg [7:0] leds
);

localparam STEP_TIME = CLK_FREQ * 2;  // 2 segundos por etapa

reg [31:0] counter;
reg [3:0] index;  // contador de qual LED está sendo alterado
reg ascending;    // 1 = ligando, 0 = desligando

always @(posedge clk) begin
    if (!rst_n) begin
        counter   <= 0;
        index     <= 0;
        ascending <= 1'b1;
        leds      <= 8'b00000000;
    end else begin
        counter <= counter + 1;

        if (counter >= STEP_TIME) begin
            counter <= 0;

            if (ascending) begin
                leds[index] <= 1'b1;
                if (index == 7) begin
                    ascending <= 1'b0;
                    index <= 0;
                end else begin
                    index <= index + 1;
                end
            end else begin
                leds[index] <= 1'b0;
                if (index == 7) begin
                    ascending <= 1'b1;
                    index <= 0;
                end else begin
                    index <= index + 1;
                end
            end
        end
    end
end

endmodule
