# =====================================================================
#  pnr.tcl   Place & Route del semaforo con OpenROAD (Capsula 7 - Tres Leches)
#  Toma el netlist sintetizado (Polvorones) y lo vuelve geometria:
#    floorplan -> place -> CTS (reloj) -> route (senal) -> DEF.
#  Las rutas y PDK se pasan por variables de entorno desde run_pnr.sh.
#
#  Pasos marcados con "==>" para ver donde va (y donde se detiene si falla).
# =====================================================================
set TOP semaforo
file mkdir results

# ---- Leer tecnologia + celdas + timing + netlist --------------------
read_lef   $env(TECHLEF)
read_lef   $env(CELLLEF)
if {[info exists env(CELLLEF2)] && $env(CELLLEF2) ne ""} { read_lef $env(CELLLEF2) }
read_liberty $env(LIB)
read_verilog $env(NETLIST)
link_design  $TOP
read_sdc     semaforo.sdc

puts "==> 1/7 Floorplan"
initialize_floorplan -utilization 35 -aspect_ratio 1.0 -core_space 3.0 -site unithd
make_tracks

puts "==> 2/7 Pines de IO"
place_pins -hor_layers met3 -ver_layers met2

puts "==> 3/7 Tap / endcap (opcional)"
catch { tapcell -distance 14 \
          -tapcell_master sky130_fd_sc_hd__tapvpwrvgnd_1 \
          -endcap_master  sky130_fd_sc_hd__decap_3 } msg
if {$msg ne ""} { puts "   (tapcell omitido: $msg)" }

puts "==> 4/7 Global placement"
global_placement -density 0.60 -pad_left 1 -pad_right 1

# RC para estimar parasitos (la 'fisica' que entra en PnR)
set_wire_rc -signal -layer met2
set_wire_rc -clock  -layer met3
estimate_parasitics -placement

puts "==> 5/7 Detailed placement"
detailed_placement

puts "==> 6/7 CTS (arbol de reloj)"
clock_tree_synthesis -buf_list sky130_fd_sc_hd__clkbuf_4 \
                     -root_buf sky130_fd_sc_hd__clkbuf_4
set_propagated_clock [all_clocks]
estimate_parasitics -placement
detailed_placement

puts "==> 7/7 Routing (global + detailed)"
global_route
catch { detailed_route -output_drc results/route_drc.rpt -verbose 0 } rmsg
if {$rmsg ne ""} { puts "   (detailed_route aviso: $rmsg)" }

# ---- Reportes: area + timing (ya con parasitos) ---------------------
puts "==> Reportes"
report_design_area
report_worst_slack -max
report_tns

# ---- Salidas: el layout ---------------------------------------------
puts "==> Guardando layout (DEF + ODB para el visor)"
write_def results/semaforo.def
catch { write_db  results/semaforo.odb }
catch { write_verilog results/semaforo_pnr.v }

puts "==> PnR terminado."
exit

