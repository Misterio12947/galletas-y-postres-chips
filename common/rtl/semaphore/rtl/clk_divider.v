`timescale 1ns / 1ps
// =====================================================================
//  clk_divider.v  ·  Divisor de reloj para que los LEDs se vean en la tarjeta
//  Solo se usa en la implementación física (MinyPLD). En simulación NO
//  hace falta: ahí alimentamos el semáforo con un reloj rápido directo.
//
//  OJO (MAX V 5M80Z = 80 logic elements): un DIV grande = contador ancho
//  = muchos LE. Ajusta DIV/CW al reloj real de tu MinyPLD y a su presupuesto
//  de LE. Si la tarjeta ya tiene un reloj lento, puedes omitir este módulo.
// =====================================================================
module clk_divider #(
    parameter integer DIV = 25_000_000,  // medio periodo; ajústalo a tu reloj
    parameter integer CW  = 25           // ancho del contador (ceil(log2(DIV)))
)(
    input  wire clk_in,
    input  wire rst_n,
    output reg  clk_out
);
    reg [CW-1:0] cnt;
    localparam [CW-1:0] DIV_M1 = DIV - 1;   // trunca a CW bits
    always @(posedge clk_in or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= {CW{1'b0}};
            clk_out <= 1'b0;
        end else if (cnt == DIV_M1) begin
            cnt     <= {CW{1'b0}};
            clk_out <= ~clk_out;
        end else begin
            cnt     <= cnt + 1'b1;
        end
    end
endmodule
