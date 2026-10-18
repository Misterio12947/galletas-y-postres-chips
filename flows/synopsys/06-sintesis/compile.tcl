# =====================================================================
#  compile.tcl   Sintesis ASIC del semaforo con Design Compiler
#  Capsula 6 - Polvorones.
#
#  Usa la MISMA liberty que el flujo open source (SKY130 HD), compilada
#  a .db con Library Compiler (ver lib/compile_lib.tcl y run_dc.sh), para
#  que los numeros se puedan comparar: mismo RTL, dos sintetizadores.
#
#  Correr:  dc_shell -f compile.tcl     (o ./run_dc.sh)
# =====================================================================

# ---- Libreria objetivo: SKY130 HD (.db) -----------------------------
set SKY130_DB  ./lib/sky130_fd_sc_hd__tt_025C_1v80.db
set link_library    [list "*" $SKY130_DB]
set target_library  $SKY130_DB

set RTL  ../../../common/rtl/semaphore/rtl/semaphore.v
set TOP  semaforo

file mkdir reports

# ---- Leer y elaborar el RTL -----------------------------------------
#  Para cambiar el ancho del contador:  elaborate $TOP -parameters "CW=16"
analyze  -format verilog $RTL
elaborate $TOP
current_design $TOP
link

# ---- Restricciones: el plazo que la sintesis debe cumplir -----------
source semaforo.sdc

# ---- Sintetizar -----------------------------------------------------
compile_ultra

# ---- Reportes: las polvorones (celdas), area, timing ----------------
redirect reports/area.rpt    { report_area }
redirect reports/timing.rpt  { report_timing }
redirect reports/cells.rpt   { report_reference -hierarchy }
redirect reports/qor.rpt     { report_qor }

echo "==================== AREA ===================="
report_area
echo "==================== TIMING (critical path) =="
report_timing
echo "==================== QoR ====================="
report_qor

# ---- Guardar el netlist de compuertas -------------------------------
write -format verilog -hierarchy -output netlist.v

exit
