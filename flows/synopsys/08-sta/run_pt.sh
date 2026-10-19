#!/usr/bin/env bash
# STA / Signoff del semaforo con PrimeTime (Capsula 8 - Cajeta)
# Correr desde flows/synopsys/08-sta/ :  ./run_pt.sh
set -e

PNR=../07-pnr/results
if [ ! -f "$PNR/semaforo_routed.v" ]; then
  echo "ERROR: falta el netlist ruteado de Tres Leches."
  echo "       Corre primero:  (cd ../07-pnr && ./run_icc2.sh)"
  exit 1
fi

echo ">> Corriendo STA de firma con PrimeTime..."
pt_shell -f pt.tcl 2>&1 | tee pt.log

echo ">> Listo.  Reportes en reports/  |  log en pt.log"
