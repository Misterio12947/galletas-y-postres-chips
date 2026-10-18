# Restriccion de reloj para el PnR del semaforo (Capsula 7 - Tres Leches)
# El mismo plazo que en sintesis: 10 ns (100 MHz).
create_clock -name clk -period 10.000 [get_ports clk]
