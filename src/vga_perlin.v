`default_nettype none

module vga_perlin (
    input wire clk,
    input wire rst_n,
    output wire hsync,
    output wire vsync,
    output wire [5:0] rrggbb
);

  wire reset = ~rst_n;

  wire                 [9:0] x_px;  // X position for actual pixel.
  wire                 [9:0] y_px;  // Y position for actual pixel.

  wire                       activevideo;
  wire                       px_clk;
  assign px_clk = clk;

  VgaSyncGen vga_0 (
      .px_clk(px_clk),
      .hsync(hsync),
      .vsync(vsync),
      .x_px(x_px),
      .y_px(y_px),
      .activevideo(activevideo),
      .reset(reset)
  );

  reg  [ 9:0] prev_y;
  reg  [15:0] counter;
  wire [ 7:0] noise_value;

  perlin_noise_generator perlin_inst (
      .clk(clk),
      .x({x_px[9:2], 2'b00}),
      .y({y_px[9:2], 2'b00}),
      .t(counter),
      .noise(noise_value)
  );

  assign rrggbb = activevideo ? noise_value[7:2] : 6'b0;

  always @(posedge clk) begin
    if (reset) begin
      counter <= 16'b0;
      prev_y  <= 10'b0;
    end else begin
      prev_y <= y_px;
      if (prev_y != y_px && y_px == 0) begin
        counter <= counter + 1;
      end
    end
  end
endmodule
