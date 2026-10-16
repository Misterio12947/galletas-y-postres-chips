module semaforo_fpv (input logic clk, rst_n);
  logic red, yellow, green;
  semaforo dut (.clk(clk), .rst_n(rst_n),
                .red(red), .yellow(yellow), .green(green));
  // una sola luz encendida, siempre (fuera de reset)
  a_one_light: assert property (
    @(posedge clk) disable iff (!rst_n) $onehot({red, yellow, green})
  );
endmodule
