#!/usr/bin/env bash
# Place & Route del semaforo con IC Compiler II (Capsula 7 - Tres Leches)
# Correr desde flows/synopsys/07-pnr/ :  ./run_icc2.sh
set -e

# ---- Netlist SKY130 (el mismo que alimenta a OpenROAD) --------------
# ICC2 necesita el netlist a nivel de compuertas, mapeado a SKY130.
# Opcion A: reusar el que genero Design Compiler en Polvorones:
#   cp ../06-sintesis/netlist.v .
# Opcion B: sintetizar con Yosys aqui (si esta disponible):
if [ ! -f netlist.v ]; then
  if command -v yosys >/dev/null 2>&1; then
    LIB=$(find /foss/pdks "$HOME" -path "*sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib" 2>/dev/null | head -1)
    RTL=../../../common/rtl/semaphore/rtl/semaphore.v
    echo ">> Sintetizando netlist.v con Yosys (lib: $LIB)..."
    yosys -q -p "read_verilog $RTL; synth -top semaforo -flatten; \
                 dfflibmap -liberty $LIB; abc -liberty $LIB; opt_clean; \
                 write_verilog -noattr netlist.v"
  else
    echo "ERROR: falta netlist.v. Copialo de Polvorones:  cp ../06-sintesis/netlist.v ."
    exit 1
  fi
fi

# ---- Place & Route con ICC2 -----------------------------------------
echo ">> Corriendo IC Compiler II..."
icc2_shell -f run_icc2.tcl | tee icc2.log

echo ">> Listo."
echo "   layout : results/semaforo.def | results/semaforo.gds"
echo "   reportes: reports/  |  log: icc2.log"
