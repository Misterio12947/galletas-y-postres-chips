// =====================================================================
//  semaforo_bug.v  -  El semaforo CON UN BUG a proposito
//  En AMARILLO enciende tambien el verde (dos luces a la vez).
//  Se usa solo para la demo del contraejemplo (bug.sby).
// =====================================================================
module semaforo #(
    parameter integer T_GREEN  = 5,
    parameter integer T_YELLOW = 2,
    parameter integer T_RED    = 5,
    parameter integer CW       = 8
)(
    input  wire clk,
    input  wire rst_n,
    output reg  red,
    output reg  yellow,
    output reg  green
);
    localparam [1:0] S_GREEN = 2'd0, S_YELLOW = 2'd1, S_RED = 2'd2;
    reg [1:0]    state;
    reg [CW-1:0] cnt, limit;

    always @(*)
        case (state)
            S_GREEN:  limit = T_GREEN;
            S_YELLOW: limit = T_YELLOW;
            default:  limit = T_RED;
        endcase

    always @(posedge clk or negedge rst_n)
        if (!rst_n) begin
            state <= S_GREEN; cnt <= {CW{1'b0}};
        end else if (cnt == limit - 1'b1) begin
            cnt <= {CW{1'b0}};
            state <= (state == S_GREEN)  ? S_YELLOW :
                     (state == S_YELLOW) ? S_RED    : S_GREEN;
        end else
            cnt <= cnt + 1'b1;

    always @(*) begin
        red = 1'b0; yellow = 1'b0; green = 1'b0;
        case (state)
            S_GREEN:  green  = 1'b1;
            S_YELLOW: begin yellow = 1'b1; green = 1'b1; end  // <-- BUG: dos luces
            S_RED:    red    = 1'b1;
        endcase
    end
endmodule
