#!/usr/bin/env bash
# Buñuelo (Capsula 9) - Esquematico -> netlist SPICE del OTA de 5T con xschem.
# Toma el esquematico de common/analog/ota5t/ y genera su netlist SPICE.
# Requiere xschem configurado con la libreria xschem de SKY130 (sky130_fd_pr).
#
# Uso (desde flows/opensource/09-esquematico/):
#   ./run_netlist.sh            # netlistea y muestra el resultado
set -e

# Raiz del repo (dos niveles arriba de flows/opensource/) y diseno compartido
HERE="$(cd "$(dirname "$0")" && pwd)"
REPO="$(cd "$HERE/../../.." && pwd)"
DESIGN="$REPO/common/analog/ota5t"
SCH="$DESIGN/OTA_5T.sch"
OUT="$HERE/results"

if [ ! -f "$SCH" ]; then
  echo "ERROR: no encuentro el esquematico en $SCH"
  exit 1
fi
if ! command -v xschem >/dev/null 2>&1; then
  echo "ERROR: xschem no esta en el PATH. Cargalo con tu entorno SKY130."
  exit 1
fi

mkdir -p "$OUT"
echo ">> Netlisteando $SCH con xschem (modo batch)..."
# -n netlist, -s formato SPICE, -q salir al terminar, -b sin GUI, -o directorio
xschem -n -s -q -b -o "$OUT" "$SCH"

NETLIST="$OUT/OTA_5T.spice"
if [ -f "$NETLIST" ]; then
  echo ">> Listo. Netlist generado:"
  echo "   $NETLIST"
  echo "----------------------------------------"
  cat "$NETLIST"
  echo "----------------------------------------"
  echo ">> Comparalo con el netlist de referencia en:"
  echo "   $DESIGN/OTA_5T.spice"
else
  echo "ERROR: xschem no genero el netlist. Revisa que la libreria SKY130"
  echo "       (XSCHEM_LIBRARY_PATH / sky130_fd_pr) este cargada."
  exit 1
fi

