# Restricciones de tiempo para la MinyPLD (MAX V 5M80ZE64C5)
# Reloj real de la tarjeta: oscilador de 25 MHz en PIN_7 -> periodo 40 ns.

create_clock -name clk -period 40.000 [get_ports clk]

# NOTA (benigno): el divisor genera slow_clk (~1 Hz) en un registro de logica
# (clk_divider:u_div|clk_out). En MAX V ese reloj derivado aparece como
# "Unconstrained" y Quartus no deja restringirlo de forma limpia (no es un pin
# de reloj dedicado). NO afecta la tarjeta: slow_clk solo maneja el semaforo a
# 1 Hz (1 s de periodo vs ns de retardo -> nunca falla). El signoff que importa
# -el contador del divisor contra los 40 ns de clk- cierra con holgura.

# El reset es asincrono: no lo restringimos como ruta sincrona.
set_false_path -from [get_ports rst_n]

# Las salidas a LEDs son visuales (humanas), no necesitan timing estricto.
set_false_path -to [get_ports {led_red led_yellow led_green}]