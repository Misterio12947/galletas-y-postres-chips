// =====================================================================
//  semaphore.v  ·  Ejemplo guía "Galletas y Postres: el camino de chips"
//  Cápsula 2 (Churros / RTL). Este MISMO archivo alimenta los dos flujos:
//    - Open source : Yosys, Icarus, OpenROAD...
//    - Comercial   : Synopsys Design Compiler / Siemens Questa...
//  y también la implementación en la MinyPLD (MAX V) vía Quartus.
//
//  Semáforo de 3 estados (verde -> amarillo -> rojo -> verde) tipo Moore.
//  RTL puro y sintetizable: describe el QUÉ, no el CÓMO.
// =====================================================================
module semaphore #(
    parameter integer T_GREEN  = 5,   // ticks en verde
    parameter integer T_YELLOW = 2,   // ticks en amarillo
    parameter integer T_RED    = 5,   // ticks en rojo
    parameter integer CW       = 8    // ancho del contador (ojo: MinyPLD = 80 LE)
)(
    input  wire clk,
    input  wire rst_n,                // reset asíncrono, activo en bajo
    output reg  red,
    output reg  yellow,
    output reg  green
);

    // ---- Codificación de estados --------------------------------------
    localparam [1:0] S_GREEN  = 2'd0,
                     S_YELLOW = 2'd1,
                     S_RED    = 2'd2;

    reg [1:0]    state, next_state;
    reg [CW-1:0] cnt;                 // cuánto llevamos en el estado actual
    reg [CW-1:0] limit;               // cuántos ticks dura el estado actual

    // ---- ¿Cuánto dura el estado actual? -------------------------------
    //  (la asignación trunca a CW bits automáticamente)
    always @(*) begin
        case (state)
            S_GREEN:  limit = T_GREEN;
            S_YELLOW: limit = T_YELLOW;
            S_RED:    limit = T_RED;
            default:  limit = T_RED;
        endcase
    end

    // ---- Lógica de siguiente estado (el anillo) -----------------------
    always @(*) begin
        case (state)
            S_GREEN:  next_state = S_YELLOW;
            S_YELLOW: next_state = S_RED;
            S_RED:    next_state = S_GREEN;
            default:  next_state = S_GREEN;
        endcase
    end

    // ---- Registro de estado + contador --------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= S_GREEN;
            cnt   <= {CW{1'b0}};
        end else if (cnt == limit - 1'b1) begin
            state <= next_state;      // se acabó el tiempo: avanza
            cnt   <= {CW{1'b0}};
        end else begin
            cnt   <= cnt + 1'b1;      // sigue contando
        end
    end

    // ---- Salidas (Moore: dependen solo del estado) --------------------
    always @(*) begin
        red = 1'b0; yellow = 1'b0; green = 1'b0;
        case (state)
            S_GREEN:  green  = 1'b1;
            S_YELLOW: yellow = 1'b1;
            S_RED:    red    = 1'b1;
            default:  red    = 1'b1;
        endcase
    end

endmodule
