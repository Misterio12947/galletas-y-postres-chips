#!/usr/bin/env bash
# STA / Signoff del semaforo con OpenSTA (Capsula 8 - Cajeta)
# Correr desde flows/opensource/08-sta/ :  ./run_sta.sh
set -e

CELL=sky130_fd_sc_hd

# ---- Localizar SKY130 (ciel / volare / FOSS) ------------------------
find_one() { find /foss/pdks "$HOME" -path "*$1" 2>/dev/null | head -1; }
: "${LIB:=$(find_one "$CELL/lib/${CELL}__tt_025C_1v80.lib")}"
: "${TECHLEF:=$(find_one "$CELL/techlef/${CELL}__nom.tlef")}"
: "${CELLLEF:=$(find_one "$CELL/lef/${CELL}.lef")}"
export LIB TECHLEF CELLLEF
echo "LIB     = $LIB"
echo "TECHLEF = $TECHLEF"
echo "CELLLEF = $CELLLEF"
for f in "$LIB" "$TECHLEF" "$CELLLEF"; do
  [ -f "$f" ] || { echo "ERROR: no encontre $f (pasa LIB=/TECHLEF=/CELLLEF= a mano)"; exit 1; }
done

# ---- Netlist SKY130 (mismo que en sintesis/PnR) ---------------------
RTL=../../../common/rtl/semaphore/rtl/semaphore.v
if [ ! -f netlist.v ]; then
  echo ">> Sintetizando netlist.v con Yosys..."
  yosys -q -p "read_verilog $RTL; synth -top semaforo -flatten; \
               dfflibmap -liberty $LIB; abc -liberty $LIB; opt_clean; \
               write_verilog -noattr netlist.v"
fi

# ---- STA con OpenSTA (dentro de OpenROAD) ---------------------------
echo ">> Corriendo STA (OpenSTA)..."
openroad -exit sta.tcl 2>&1 | tee sta.log

echo ">> Listo.  Reporte completo en sta.log  |  SPEF en results/semaforo.spef"
