// =====================================================================
//  formal_top.v  -  Envoltorio formal del semaforo (Capsula 4 - Gelatina)
//  Instancia el semaforo y le pone la propiedad, SIN tocar el RTL.
//  (Mismo patron que el envoltorio de VC Formal del lado Synopsys.)
//
//  Propiedad de seguridad: NUNCA hay dos luces encendidas a la vez.
//  Incluye una secuencia de reset para que el analisis arranque desde
//  un estado valido (si no, el motor podria partir de un estado
//  invalido del registro de 2 bits y dar un contraejemplo trivial).
// =====================================================================
module formal_top (input wire clk, input wire rst_n);

    wire red, yellow, green;

    semaforo dut (
        .clk(clk), .rst_n(rst_n),
        .red(red), .yellow(yellow), .green(green)
    );

    // arranque: reset activo el primer ciclo, luego corre normal
    reg f_started = 1'b0;
    always @(posedge clk) f_started <= 1'b1;
    always @(posedge clk) begin
        if (!f_started) assume (!rst_n);
        else            assume ( rst_n);
    end

    // propiedad: una sola luz encendida, siempre (fuera de reset)
    always @(posedge clk)
        if (f_started && rst_n)
            assert (red + yellow + green == 1);

endmodule
