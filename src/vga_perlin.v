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

  wire [7:0] noise_value;

  perlin_noise_generator perlin_inst (
      .clk(clk),
      .x({x_px[9:2], 2'b00}),
      .y({y_px[9:2], 2'b00}),
      .noise(noise_value)
  );

  assign rrggbb = activevideo ? noise_value[7:2] : 6'b0;
endmodule
