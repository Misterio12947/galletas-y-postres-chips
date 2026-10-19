# =====================================================================
#  pt.tcl   STA / Signoff del semaforo con PrimeTime (Capsula 8 - Cajeta)
#  Lee el netlist ruteado + el SPEF que genero ICC2 en Tres Leches y
#  FIRMA el timing (setup/hold) con los parasitos reales del layout.
#
#  Correr:  pt_shell -f pt.tcl   (lo lanza run_pt.sh)
# =====================================================================
set DESIGN semaforo
set DESIGN_REF_PATH "/home/SHARE-DATA/technology/pdksy/sky130"

# ---- Libreria de timing (.db NLDM) ----------------------------------
lappend search_path "${DESIGN_REF_PATH}/lib/sky130_fd_sc_hd/db_nldm"
set link_library "* sky130_fd_sc_hd__tt_025C_1v80.db"   ;# <-- confirma el nombre del .db

# ---- Entradas: netlist ruteado + SPEF (de Tres Leches / ICC2) -------
set PNR     ../07-pnr/results
set NETLIST $PNR/semaforo_routed.v
set SPEF    $PNR/semaforo.spef.maxTLU_100.spef          ;# <-- confirma el nombre del .spef

file mkdir reports

read_verilog $NETLIST
current_design $DESIGN
link_design

read_sdc semaforo.sdc
read_parasitics $SPEF
update_timing

# ---- El veredicto: setup + hold -------------------------------------
redirect reports/setup.rpt { report_timing -delay_type max }
redirect reports/hold.rpt  { report_timing -delay_type min }
redirect reports/qor.rpt   { report_qor }
puts "========================= SETUP (max) ========================="
report_timing -delay_type max
puts "========================= HOLD (min) =========================="
report_timing -delay_type min
puts "========================= QoR ================================="
report_qor
exit
