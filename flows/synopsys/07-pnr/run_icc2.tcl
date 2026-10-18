# =====================================================================
#  run_icc2.tcl   Place & Route del semaforo con IC Compiler II
#  Capsula 7 - Tres Leches (lado Synopsys). UN solo script de referencia:
#  setup + corner/mode/scenario + floorplan -> place -> CTS -> route.
#  Estructura basada en el flujo SKY130 del Microprocessor_PLC.
#
#  Correr:  icc2_shell -f run_icc2.tcl   (lo lanza run_icc2.sh)
# =====================================================================
set DESIGN  semaforo
set NETLIST netlist.v          ;# netlist mapeado a SKY130 (de Polvorones)

# ---- Setup de tecnologia SKY130 (del ICC2_Setup.tcl) ----------------
set DESIGN_REF_PATH        "/home/SHARE-DATA/technology/pdksy/sky130"
set NDM_REFERENCE_LIB_DIRS "${DESIGN_REF_PATH}/lib/sky130_fd_sc_hd/ndm/sky130_fd_sc_hd.ndm"
set TECH_FILE              "${DESIGN_REF_PATH}/lib/sky130_fd_sc_hd/tech/milkyway/sky130_fd_sc_hd.tf"
set MAP_FILE               "${DESIGN_REF_PATH}/tech/star_rcxt/skywater130.mw2itf.map"
set TLUPLUS_MAX_FILE       "${DESIGN_REF_PATH}/tech/star_rcxt/skywater130.nominal.tluplus"
lappend search_path        "${DESIGN_REF_PATH}/lib/sky130_fd_sc_hd/db_nldm"
set_host_options -max_cores 16

file mkdir reports results

# ---- Libreria de diseno ---------------------------------------------
if {[file exists ${DESIGN}.dlib]} { file delete -force ${DESIGN}.dlib }
create_lib -technology $TECH_FILE -ref_libs $NDM_REFERENCE_LIB_DIRS ${DESIGN}.dlib

# ---- Netlist + link (AQUI nace el bloque actual) --------------------
read_verilog -top $DESIGN $NETLIST
link_block

# ---- Corner + parasitos (DESPUES del link) --------------------------
create_corner worst
read_parasitic_tech -tlup $TLUPLUS_MAX_FILE -layermap $MAP_FILE -name maxTLU
set_parasitic_parameters -corner worst -early_spec maxTLU -late_spec maxTLU

# ---- Mode + scenario + SDC ------------------------------------------
create_mode functional
create_scenario -mode functional -name functional_worst -corner worst
read_sdc semaforo.sdc

# ---- PG nets --------------------------------------------------------
connect_pg_net -auto

# ========================= Floorplan =================================
puts "--- PNR: Floorplan ---"
initialize_floorplan -core_utilization 0.45 -core_offset 5
place_pins -self
save_block -as post_floorplan

# ========================= Placement =================================
puts "--- PNR: Placement ---"
place_opt
save_block -as post_placement

# ========================= CTS =======================================
puts "--- PNR: CTS ---"
clock_opt
save_block -as post_cts

# ========================= Route =====================================
puts "--- PNR: Route ---"
route_auto
route_opt
save_block -as post_route

# ========================= Reportes ==================================
puts "--- PNR: Reportes ---"
redirect reports/qor.rpt          { report_qor }
redirect reports/timing.rpt       { report_timing }
redirect reports/utilization.rpt  { report_utilization }
report_qor
report_timing

# ========================= Salidas (signoff) =========================
# (ICC2: write_def/write_verilog van con nombre posicional; write_parasitics
#  y write_sdc usan -output)
puts "--- PNR: Exportando layout + signoff ---"
write_verilog results/semaforo_routed.v
write_def     results/semaforo.def
catch { write_gds results/semaforo.gds }
# SPEF: parasitos para el signoff en PrimeTime -> relevo a Cajeta (STA)
write_parasitics -output results/semaforo.spef -format SPEF
write_sdc        -output results/semaforo_routed.sdc
save_lib

puts "--- PNR: Flujo completado ---"
exit