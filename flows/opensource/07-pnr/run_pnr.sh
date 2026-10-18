#!/usr/bin/env bash
# Place & Route del semaforo con OpenROAD (Capsula 7 - Tres Leches)
# Corre desde flows/opensource/07-pnr/ :  ./run_pnr.sh
set -e

# Para que gui::save_image pueda renderizar sin pantalla (headless).
export QT_QPA_PLATFORM=offscreen

CELL=sky130_fd_sc_hd

# ---- 1) Localizar SKY130 (ciel / volare / FOSS) ---------------------
find_one() { find /foss/pdks "$HOME" -path "*$1" 2>/dev/null | head -1; }
: "${LIB:=$(find_one "$CELL/lib/${CELL}__tt_025C_1v80.lib")}"
: "${TECHLEF:=$(find_one "$CELL/techlef/${CELL}__nom.tlef")}"
: "${CELLLEF:=$(find_one "$CELL/lef/${CELL}.lef")}"
export LIB TECHLEF CELLLEF
# PDK_ROOT = el directorio que contiene sky130A/ (lo usa el magicrc de Magic).
# Se deriva de la ruta de la liberty; sobre-escribe el PDK_ROOT del entorno
# (que en la caja FOSS apunta mal, p.ej. /headless/pdk).
export PDK_ROOT="${LIB%%/sky130A/*}"
echo "LIB      = $LIB"
echo "TECHLEF  = $TECHLEF"
echo "CELLLEF  = $CELLLEF"
echo "PDK_ROOT = $PDK_ROOT"
for f in "$LIB" "$TECHLEF" "$CELLLEF"; do
  [ -f "$f" ] || { echo "ERROR: no encontre $f  (pasa LIB=/TECHLEF=/CELLLEF= a mano)"; exit 1; }
done

# ---- 2) Sintetizar el netlist (mismo recipe que 06-sintesis) --------
RTL=../../../common/rtl/semaphore/rtl/semaphore.v
export NETLIST=netlist.v
echo ">> Sintetizando netlist con Yosys..."
yosys -q -p "read_verilog $RTL; synth -top semaforo -flatten; \
             dfflibmap -liberty $LIB; abc -liberty $LIB; opt_clean; \
             write_verilog -noattr $NETLIST"

# ---- 3) Place & Route con OpenROAD ----------------------------------
echo ">> Corriendo OpenROAD (PnR)..."
openroad -exit pnr.tcl 2>&1 | tee pnr.log

# ---- 4) GDS con Magic (DEF -> GDS usando la geometria del PDK) ------
MAGICRC=$(find_one "sky130A/libs.tech/magic/sky130A.magicrc")
export CELLGDS=$(find_one "$CELL/gds/${CELL}.gds")
if command -v magic >/dev/null 2>&1 && [ -f "$MAGICRC" ] && [ -f "$CELLGDS" ]; then
  echo ">> Generando GDS con Magic..."
  magic -dnull -noconsole -rcfile "$MAGICRC" def2gds.tcl </dev/null 2>&1 | tee -a pnr.log
else
  echo ">> (GDS omitido: falta magic, el magicrc o el cell GDS)"
fi

echo ">> Listo."
echo "   layout : results/semaforo.def | results/semaforo.gds"
echo "   log    : pnr.log"
