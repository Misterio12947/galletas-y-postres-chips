# =====================================================================
#  def2gds.tcl   Magic: convierte el DEF ruteado en GDS final
#  OpenROAD no genera GDS; Magic (o KLayout) leen el DEF + la geometria
#  REAL de las celdas estandar del PDK (sky130_fd_sc_hd.gds) y la funden.
#  Es el mismo paso que hace OpenLane por dentro.
#
#  Corre (lo lanza run_pnr.sh):
#    magic -dnull -noconsole -rcfile <sky130A.magicrc> def2gds.tcl
#  Variables de entorno esperadas:  CELLGDS  (ruta al sky130_fd_sc_hd.gds)
# =====================================================================
drc off
gds readonly true
gds rescale false

# 1) Leer el tech LEF: define las CAPAS y los VIAS del routing
#    (M1M2_PR, L1M1_PR_MR, ...). Sin esto, Magic tira el routing del DEF.
lef read $env(TECHLEF)

# 2) Cargar las celdas estandar reales del PDK (su geometria de verdad)
gds read $env(CELLGDS)

# 3) Leer el diseno colocado y ruteado (ahora los vias SI se conocen)
def read results/semaforo.def
load semaforo
select top cell

# 3) Escribir el GDS final (celdas + routing fundidos)
gds write results/semaforo.gds

puts "GDS escrito: results/semaforo.gds"
quit -noprompt
