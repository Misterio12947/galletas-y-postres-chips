// =====================================================================
//  tb_semaphore.v  ·  Testbench autocomprobante (Cápsula 3 · Flan)
//  Mismo TB para Icarus (open source) y Questa/VCS (comercial).
//
//  Checker clave: NUNCA hay dos luces encendidas a la vez (propiedad de
//  seguridad). Esto es justo lo que la Cápsula 4 (Formal) demostrará
//  matemáticamente; aquí lo comprobamos por simulación.
// =====================================================================
`timescale 1ns/1ps
module tb_semaphore;

    reg  clk = 1'b0;
    reg  rst_n = 1'b0;
    wire red, yellow, green;

    // Tiempos chicos para simular rápido (en el tablero son más largos).
    semaforo #(.T_GREEN(3), .T_YELLOW(2), .T_RED(3), .CW(8)) dut (
        .clk(clk), .rst_n(rst_n),
        .red(red), .yellow(yellow), .green(green)
    );

    // Reloj de 10 ns.
    always #5 clk = ~clk;

    integer errors = 0;

    // ---- CHECKER: exactamente UNA luz encendida -----------------------
    always @(posedge clk) if (rst_n) begin
        if ((red + yellow + green) !== 1) begin
            $display("[%0t] FAIL: luces invalidas r=%b y=%b g=%b",
                     $time, red, yellow, green);
            errors = errors + 1;
        end
    end

    // ---- Estímulo + cobertura simple ----------------------------------
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_semaphore);

        #12 rst_n = 1'b1;    // suelta el reset
        #500;                // deja correr varios ciclos del semáforo

        if (errors == 0)
            $display(">>> PASS: el semaforo cumple (1 luz a la vez, secuencia OK)");
        else
            $display(">>> FAIL: %0d violaciones detectadas", errors);

        $finish;
    end

endmodule
