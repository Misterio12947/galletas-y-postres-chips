# Restricciones de tiempo para la MinyPLD (MAX V 5M80ZE64C5)
# Reloj real de la tarjeta: oscilador de 25 MHz en PIN_7 -> periodo 40 ns.

create_clock -name clk -period 40.000 [get_ports clk]

# El reset es asincrono: no lo restringimos como ruta sincrona.
set_false_path -from [get_ports rst_n]

# Las salidas a LEDs son visuales (humanas), no necesitan timing estricto.
set_false_path -to [get_ports {led_red led_yellow led_green}]