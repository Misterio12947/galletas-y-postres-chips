# Restricciones de tiempo para la MinyPLD (MAX V)
# ⚠️ Ajusta el periodo al reloj REAL de tu tarjeta.

# Ejemplo: reloj de 50 MHz (20 ns). Cámbialo a tu frecuencia real.
create_clock -name clk -period 20.000 [get_ports clk]

# El reset es asíncrono: no lo restringimos como ruta síncrona.
set_false_path -from [get_ports rst_n]

# Las salidas a LEDs son visuales (humanas), no necesitan timing estricto.
set_false_path -to [get_ports {led_red led_yellow led_green}]
