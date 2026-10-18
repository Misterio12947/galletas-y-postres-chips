# Restriccion de tiempo para el PnR del semaforo (Capsula 7 - Tres Leches)
# Mismo plazo que en sintesis y que el flujo OpenROAD: 10 ns (100 MHz).
# (modo read_sdc de ICC2: sin remove_from_collection; el unico input de datos
#  es rst_n y es asincrono, asi que no lleva input_delay)
create_clock -name clk -period 10.000 [get_ports clk]
set_false_path -from [get_ports rst_n]
set_output_delay 2.0 -clock clk [get_ports {red yellow green}]
