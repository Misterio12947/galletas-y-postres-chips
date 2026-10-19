#!/usr/bin/env bash
# Alfajor (Capsula 11) - DRC del layout del OTA con el runset de SKY130 (KLayout).
# Revisa que el GDS respete las reglas de fabricacion. Reporte -> results/.
#
# Uso (desde flows/opensource/11-layout/):
#   ./run_drc.sh
set -e

HERE="$(cd "$(dirname "$0")" && pwd)"
REPO="$(cd "$HERE/../../.." && pwd)"
GDS="$REPO/common/analog/ota5t/OTA_5T.gds"
OUT="$HERE/results"
TOP="OTA_5T"
mkdir -p "$OUT"

if ! command -v klayout >/dev/null 2>&1; then
  echo "ERROR: klayout no esta en el PATH. Carga tu entorno SKY130."; exit 1
fi
if [ ! -f "$GDS" ]; then
  echo "ERROR: no encuentro el GDS en $GDS"; exit 1
fi

# --- localizar sky130A y el runset DRC ---
SKY=""
for c in "$PDK_ROOT/sky130A" /foss/pdks/sky130A "$HOME/.volare/sky130A" "$HOME/.ciel/sky130A"; do
  if [ -d "$c" ]; then SKY="$c"; break; fi
done
if [ -z "$SKY" ]; then echo "ERROR: no encontre sky130A (exporta PDK_ROOT)."; exit 1; fi

RUNSET=""
for c in \
  "$SKY/libs.tech/klayout/drc/sky130A_mr.drc" \
  "$SKY/libs.tech/klayout/drc/sky130_mr.drc" \
  "$(find "$SKY/libs.tech/klayout" -name '*_mr.drc' 2>/dev/null | head -1)" ; do
  if [ -n "$c" ] && [ -f "$c" ]; then RUNSET="$c"; break; fi
done
if [ -z "$RUNSET" ]; then
  echo "ERROR: no encontre el runset DRC (sky130A_mr.drc) bajo $SKY/libs.tech/klayout/drc/"
  echo "       Revisa tu instalacion o corre el DRC desde KLayout (Tools -> DRC)."
  exit 1
fi

REPORT="$OUT/${TOP}_drc.xml"
echo ">> GDS    : $GDS"
echo ">> Runset : $RUNSET"
echo ">> Corriendo DRC (KLayout, batch)..."
klayout -b -r "$RUNSET" \
  -rd input="$GDS" \
  -rd report="$REPORT" \
  -rd top_cell="$TOP" \
  -rd feol=true -rd beol=true -rd offgrid=true \
  2>&1 | tee "$OUT/drc.log" || true

# --- contar violaciones en el reporte XML ---
if [ -f "$REPORT" ]; then
  N=$(grep -c "<item>" "$REPORT" || true)
  echo "----------------------------------------"
  echo " Violaciones DRC: $N"
  [ "$N" = "0" ] && echo " -> LIMPIO ✓  (el layout respeta las reglas del fab)" \
                 || echo " -> revisa $REPORT en KLayout (Tools -> Marker Browser)"
  echo "----------------------------------------"
  echo " Reporte: $REPORT"
else
  echo "AVISO: no se genero el reporte. Revisa $OUT/drc.log"
fi
