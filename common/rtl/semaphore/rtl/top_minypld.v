`timescale 1ns / 1ps
// =====================================================================
//  top_minypld.v  ·  Top de la demo para la MinyPLD (Altera/Intel MAX V)
//  Conecta el divisor de reloj + el semáforo a los pines de la tarjeta.
//  Este es el módulo "top" que Quartus sintetiza (ver flows/fpga-minypld).
//
//  AJUSTA a tu tarjeta: el reloj de entrada, el presupuesto de LE (80 en
//  el 5M80Z) y, si tu MinyPLD ya tiene reloj lento, puedes quitar el divisor.
// =====================================================================
module top_minypld (
    input  wire clk,          // reloj de la tarjeta
    input  wire rst_n,        // push-button de reset (activo en bajo)
    output wire led_red,
    output wire led_yellow,
    output wire led_green
);
    wire slow_clk;

    // Divisor para pasar del reloj de la tarjeta a ~1 Hz visible.
    clk_divider #(.DIV(25_000_000), .CW(25)) u_div (
        .clk_in (clk),
        .rst_n  (rst_n),
        .clk_out(slow_clk)
    );

    // El semáforo corriendo a ritmo humano.
    semaforo #(.T_GREEN(5), .T_YELLOW(2), .T_RED(5), .CW(8)) u_sem (
        .clk   (slow_clk),
        .rst_n (rst_n),
        .red   (led_red),
        .yellow(led_yellow),
        .green (led_green)
    );
endmodule
