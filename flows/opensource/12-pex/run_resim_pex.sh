#!/usr/bin/env bash
# Capirotada (Capsula 12) - re-simula el OTA CON parasitos (PEX) y compara vs ideal.
#
# Uso (desde flows/opensource/12-pex/):
#   ./run_resim_pex.sh [ac] [corner]   # corner = tt (def) | ss | ff | sf | fs
#   (el "ac" es opcional; el re-sim con parasitos siempre es AC)
#   ejemplos:  ./run_resim_pex.sh        ./run_resim_pex.sh ac
#              ./run_resim_pex.sh ss     ./run_resim_pex.sh ac ss
set -e

# Acepta un "ac" (modo) como primer argumento y lo ignora; el corner es el resto.
if [ "${1:-}" = "ac" ] || [ -z "${1:-}" ]; then
  CORNER="${2:-tt}"
else
  CORNER="$1"
fi
HERE="$(cd "$(dirname "$0")" && pwd)"
OUT="$HERE/results"
PEX="$OUT/OTA_5T_pex.spice"
IDEAL="$HERE/../10-simulacion/results/bode.txt"      # el Bode ideal (Arroz con Leche)
mkdir -p "$OUT"

if ! command -v ngspice >/dev/null 2>&1; then
  echo "ERROR: ngspice no esta en el PATH."; exit 1
fi
if [ ! -f "$PEX" ]; then
  echo "ERROR: falta el netlist PEX ($PEX). Corre primero: ./run_pex.sh"; exit 1
fi

# --- nombre + puertos reales del subckt del netlist PEX ---
SUBCKT_LINE="$(grep -i '^\.subckt' "$PEX" | head -1)"
[ -n "$SUBCKT_LINE" ] || { echo "ERROR: no encontre .subckt en $PEX"; exit 1; }
SUBCKT="$(echo "$SUBCKT_LINE" | awk '{print $2}')"
PORTS="$(echo "$SUBCKT_LINE" | awk '{$1="";$2="";print $0}' | xargs)"
echo ">> subckt PEX : $SUBCKT"
echo ">> puertos    : $PORTS"

# mapea cada puerto del subckt a un nodo del testbench (quita ! y case-insensitive)
map_port() {
  local p="${1%!}"
  case "$(echo "$p" | tr 'A-Z' 'a-z')" in
    vin)              echo VDD  ;;   # alimentacion
    vout_amp|vout)    echo VOUT ;;   # salida
    vinp)             echo VINP ;;
    vinn)             echo VINN ;;
    ib)               echo IB   ;;
    vss|gnd|sky130_gnd) echo 0  ;;   # tierra
    vsubs|vsub|vnb|vb)  echo 0  ;;   # sustrato (bulk nfet) -> tierra
    *)                echo "$p" ;;   # desconocido: mismo nombre (puede flotar)
  esac
}
NODES=""
for p in $PORTS; do NODES="$NODES $(map_port "$p")"; done
XINST="x1${NODES} ${SUBCKT}"
echo ">> instancia  : $XINST"

# --- libreria de modelos SKY130 ---
LIB=""
for c in \
  "$PDK_ROOT/sky130A/libs.tech/combined/sky130.lib.spice" \
  /foss/pdks/sky130A/libs.tech/combined/sky130.lib.spice \
  "$HOME/.volare/sky130A/libs.tech/combined/sky130.lib.spice" \
  "$HOME/.ciel/sky130A/libs.tech/combined/sky130.lib.spice" ; do
  [ -f "$c" ] && { LIB="$c"; break; }
done
[ -n "$LIB" ] || { echo "ERROR: no encontre sky130.lib.spice (exporta PDK_ROOT)."; exit 1; }

RUN="$OUT/_run_pex_ac_${CORNER}.spice"
sed -e "s#__SKY130_LIB__#$LIB#g" \
    -e "s#__PEX__#$PEX#g" \
    -e "s#__XINST__#$XINST#g" \
    -e "s#__CORNER__#$CORNER#g" \
    -e "s#__OUT__#$OUT#g" \
    "$HERE/decks/ota_pex_ac.spice.in" > "$RUN"

echo ">> Re-simulando con parasitos (ngspice)..."
ngspice -b "$RUN" -o "$OUT/pex_ac_${CORNER}.log"

if [ ! -f "$OUT/bode_pex.txt" ]; then
  echo "ERROR: no se genero bode_pex.txt. Revisa $OUT/pex_ac_${CORNER}.log"; exit 1
fi

# --- comparar ideal vs con parasitos ---
if [ -f "$IDEAL" ]; then
  echo ">> Comparando ideal vs parasitos..."
  python3 "$HERE/plot_pex_compare.py" "$IDEAL" "$OUT/bode_pex.txt" "$OUT/bode_compare.png"
else
  echo ">> No encontre el Bode ideal en $IDEAL"
  echo "   Corre primero Arroz con Leche:  (cd ../10-simulacion && ./run_sim.sh ac)"
  echo "   Grafico solo el PEX:"
  python3 "$HERE/plot_pex_compare.py" "" "$OUT/bode_pex.txt" "$OUT/bode_pex.png"
fi
echo ">> Listo."
