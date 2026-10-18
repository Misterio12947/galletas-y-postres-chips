# Compila la liberty de SKY130 HD (.lib) al formato .db que usa Design Compiler.
# Es la MISMA .lib del flujo open source, para que los numeros se comparen.
#
# Correr desde flows/synopsys/06-sintesis/ :
#   lc_shell -f lib/compile_lib.tcl
#
# PDK_ROOT debe apuntar a tu instalacion de SKY130 (volare enable --pdk sky130).

set SKY130_LIB $env(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib

read_lib  $SKY130_LIB
write_lib sky130_fd_sc_hd__tt_025C_1v80 \
          -format db \
          -output lib/sky130_fd_sc_hd__tt_025C_1v80.db
exit
