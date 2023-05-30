module Automatic_Gate (
    input wire clk,
    input wire reset,
    input wire sensor,
    output wire green_led,
    output wire blue_led,
    output wire red_led
);

  reg [1:0] gate_state = 2'b00;
  reg [1:0] timer = 2'b00;
  parameter DELAY = 10;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      gate_state <= 2'b00;
      timer <= 2'b00;
    end else begin
      case (gate_state)
        2'b00: begin  // Kapı kapalı durumda
          if (sensor) begin
            gate_state <= 2'b01;  // Açılış aşamasına geç
            timer <= DELAY;
          end
        end
        2'b01: begin  // Açılış aşaması
          if (timer == 2'b00) begin
            gate_state <= 2'b10;  // Açık duruma geç
          end else begin
            timer <= timer - 1;
          end
        end
        2'b10: begin  // Kapı açık durumda
          if (!sensor) begin
            gate_state <= 2'b11;  // Kapanış aşamasına geç
            timer <= DELAY;
          end
        end
        2'b11: begin  // Kapanış aşaması
          if (timer == 2'b00) begin
            gate_state <= 2'b00;  // Kapalı duruma geç
          end else begin
            timer <= timer - 1;
          end
        end
        default: begin
          gate_state <= 2'b00;
        end
      endcase
    end
  end

  assign green_led = (gate_state == 2'b01);
  assign blue_led = (gate_state == 2'b10);
  assign red_led = (gate_state == 2'b11);

endmodule