#!/usr/bin/env bash
# Arroz con Leche (Capsula 10) - simulacion del OTA 5T con ngspice.
#
# Uso (desde flows/opensource/10-simulacion/):
#   ./run_sim.sh op  [corner]    # punto de operacion  (gm, Id, Vds)
#   ./run_sim.sh ac  [corner]    # respuesta en frecuencia (Bode)
#   corner = tt (def) | ss | ff | sf | fs
set -e

MODE="${1:-op}"
CORNER="${2:-tt}"

HERE="$(cd "$(dirname "$0")" && pwd)"
REPO="$(cd "$HERE/../../.." && pwd)"
OTA="$REPO/common/analog/ota5t/OTA_5T.spice"
OUT="$HERE/results"
DECKS="$HERE/decks"
mkdir -p "$OUT"

if ! command -v ngspice >/dev/null 2>&1; then
  echo "ERROR: ngspice no esta en el PATH. Carga tu entorno SKY130."; exit 1
fi
if [ ! -f "$OTA" ]; then
  echo "ERROR: no encuentro el OTA en $OTA"; exit 1
fi

# --- localizar la libreria de modelos de SKY130 (sky130.lib.spice) ---
LIB=""
for c in \
  "$PDK_ROOT/sky130A/libs.tech/combined/sky130.lib.spice" \
  /foss/pdks/sky130A/libs.tech/combined/sky130.lib.spice \
  "$HOME/.volare/sky130A/libs.tech/combined/sky130.lib.spice" \
  "$HOME/.ciel/sky130A/libs.tech/combined/sky130.lib.spice" ; do
  if [ -f "$c" ]; then LIB="$c"; break; fi
done
if [ -z "$LIB" ]; then
  echo "ERROR: no encontre sky130.lib.spice. Exporta PDK_ROOT (p.ej. /foss/pdks)."
  exit 1
fi
echo ">> PDK models : $LIB"
echo ">> OTA        : $OTA"
echo ">> Corner     : $CORNER"

case "$MODE" in
  op) TPL="$DECKS/ota_op.spice.in" ;;
  ac) TPL="$DECKS/ota_ac.spice.in" ;;
  *)  echo "Modo invalido: usa 'op' o 'ac'"; exit 1 ;;
esac

# --- rellenar la plantilla ---
RUN="$OUT/_run_${MODE}_${CORNER}.spice"
sed -e "s#__SKY130_LIB__#$LIB#g" \
    -e "s#__OTA__#$OTA#g" \
    -e "s#__CORNER__#$CORNER#g" \
    -e "s#__OUT__#$OUT#g" \
    "$TPL" > "$RUN"

echo ">> Corriendo ngspice ($MODE)..."
ngspice -b "$RUN" -o "$OUT/${MODE}_${CORNER}.log"
echo ">> Log: $OUT/${MODE}_${CORNER}.log"

if [ "$MODE" = "op" ]; then
  echo "----------------------------------------"
  # mostrar el bloque de operating point del log
  sed -n '/Punto de operacion/,/Salida en reposo/p' "$OUT/${MODE}_${CORNER}.log" || true
  grep -A1 "v(vout)" "$OUT/${MODE}_${CORNER}.log" | tail -2 || true
  echo "----------------------------------------"
fi

if [ "$MODE" = "ac" ]; then
  if command -v python3 >/dev/null 2>&1 && [ -f "$OUT/bode.txt" ]; then
    echo ">> Graficando el Bode y midiendo Av0 / GBW / margen de fase..."
    python3 "$HERE/plot_bode.py" "$OUT/bode.txt" "$OUT/bode_${CORNER}.png"
  else
    echo ">> bode.txt en $OUT  (grafica con plot_bode.py)"
  fi
fi

echo ">> Listo."
