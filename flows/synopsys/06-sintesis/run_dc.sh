#!/usr/bin/env bash
# Sintesis del semaforo con Synopsys Design Compiler (Capsula 6 - Polvorones)
# Correr desde flows/synopsys/06-sintesis/ :  ./run_dc.sh
set -e

DB=lib/sky130_fd_sc_hd__tt_025C_1v80.db

# 1) Asegura el .db de la libreria (compila la .lib de SKY130 si falta).
#    PDK_ROOT debe apuntar a tu SKY130 (la MISMA liberty del flujo open source).
if [ ! -f "$DB" ]; then
  echo ">> Compilando la liberty SKY130 (.lib -> .db) con Library Compiler..."
  : "${PDK_ROOT:?define PDK_ROOT apuntando a tu instalacion de SKY130}"
  lc_shell -f lib/compile_lib.tcl
fi

# 2) Sintesis.
echo ">> Sintetizando con Design Compiler..."
dc_shell -f compile.tcl | tee dc.log

echo ">> Listo. Netlist en netlist.v | reportes en reports/ | log en dc.log"
