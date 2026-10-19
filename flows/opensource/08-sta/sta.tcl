# =====================================================================
#  sta.tcl   STA / Signoff del semaforo con OpenSTA (dentro de OpenROAD)
#  Capsula 8 - Cajeta. Firma el timing: revisa setup y hold en TODOS los
#  caminos, con parasitos REALES del ruteo (no estimados a ciegas).
#
#  OpenROAD trae OpenSTA integrado (read_liberty / read_sdc / read_spef /
#  report_checks). Rutas de PDK por variables de entorno (run_sta.sh).
# =====================================================================
set TOP semaforo

# ---- Leer tecnologia + timing + netlist + constraints ---------------
read_lef   $env(TECHLEF)
read_lef   $env(CELLLEF)
read_liberty $env(LIB)
read_verilog netlist.v
link_design  $TOP
read_sdc     semaforo.sdc

# ---- Implementacion minima para tener parasitos del ruteo -----------
#  (el signoff se hace con los cables reales; aqui los conseguimos con un
#   place + CTS + global route rapido, como en Tres Leches)
file mkdir results
initialize_floorplan -utilization 40 -aspect_ratio 1.0 -core_space 3.0 -site unithd
make_tracks
place_pins -hor_layers met3 -ver_layers met2
global_placement -density 0.60
detailed_placement
clock_tree_synthesis -buf_list sky130_fd_sc_hd__clkbuf_4 -root_buf sky130_fd_sc_hd__clkbuf_4
set_propagated_clock [all_clocks]
global_route
estimate_parasitics -global_routing

# ---- El SPEF que "firmamos" -----------------------------------------
catch { write_spef results/semaforo.spef }

# =====================================================================
#  STA: el veredicto
# =====================================================================
puts "========================= SETUP (max) ========================="
report_checks -path_delay max -format full_clock_expanded

puts "========================= HOLD (min) =========================="
report_checks -path_delay min

puts "========================= RESUMEN ============================="
puts ">> Peor slack SETUP:"
report_worst_slack -max
puts ">> Peor slack HOLD:"
report_worst_slack -min
puts ">> TNS (suma de violaciones):"
report_tns

exit
