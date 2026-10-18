# Restricciones de sintesis para el semaforo (Capsula 6 - Polvorones)
# El "plazo" (SDC) le dice a la sintesis que tan rapido debe ir: sin esto
# no sabe que celdas elegir. Ajusta el periodo a lo que quieras demostrar.

create_clock -name clk -period 10.000 [get_ports clk]   ;# 100 MHz

# Reset asincrono: no es una ruta sincrona de datos.
set_false_path -from [get_ports rst_n]

# Margenes de entrada/salida (modelan el mundo fuera del bloque).
set_input_delay  2.0 -clock clk [remove_from_collection [all_inputs]  [get_ports clk]]
set_output_delay 2.0 -clock clk [all_outputs]
