# Constraints para el STA del semaforo (Capsula 8 - Cajeta)
# Mismo plazo que sintesis y PnR: 10 ns (100 MHz).
create_clock -name clk -period 10.000 [get_ports clk]
set_false_path -from [get_ports rst_n]
set_output_delay 2.0 -clock clk [get_ports {red yellow green}]
