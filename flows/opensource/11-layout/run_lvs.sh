#!/usr/bin/env bash
# Alfajor (Capsula 11) - LVS del OTA con el runset de SKY130 (KLayout).
# Compara el LAYOUT (GDS) contra el NETLIST del esquematico (common/analog/ota5t):
# ¿es el mismo circuito? (mismos transistores y conexiones).
#
# Uso (desde flows/opensource/11-layout/):
#   ./run_lvs.sh
set -e

HERE="$(cd "$(dirname "$0")" && pwd)"
REPO="$(cd "$HERE/../../.." && pwd)"
GDS="$REPO/common/analog/ota5t/OTA_5T.gds"
NETLIST="$REPO/common/analog/ota5t/OTA_5T.spice"   # netlist del esquematico (ref)
OUT="$HERE/results"
TOP="OTA_5T"
mkdir -p "$OUT"

if ! command -v klayout >/dev/null 2>&1; then
  echo "ERROR: klayout no esta en el PATH. Carga tu entorno SKY130."; exit 1
fi
for f in "$GDS" "$NETLIST"; do
  [ -f "$f" ] || { echo "ERROR: no encuentro $f"; exit 1; }
done

# --- localizar sky130A y el runset LVS ---
SKY=""
for c in "$PDK_ROOT/sky130A" /foss/pdks/sky130A "$HOME/.volare/sky130A" "$HOME/.ciel/sky130A"; do
  if [ -d "$c" ]; then SKY="$c"; break; fi
done
[ -n "$SKY" ] || { echo "ERROR: no encontre sky130A (exporta PDK_ROOT)."; exit 1; }

RUNSET=""
for c in \
  "$SKY/libs.tech/klayout/lvs/sky130.lvs" \
  "$SKY/libs.tech/klayout/lvs/sky130A.lvs" \
  "$(find "$SKY/libs.tech/klayout" -name '*.lvs' 2>/dev/null | head -1)" ; do
  if [ -n "$c" ] && [ -f "$c" ]; then RUNSET="$c"; break; fi
done
[ -n "$RUNSET" ] || { echo "ERROR: no encontre el runset LVS (*.lvs) bajo $SKY/libs.tech/klayout/lvs/"; exit 1; }

REPORT="$OUT/${TOP}.lvsdb"
EXTRACTED="$OUT/${TOP}_extracted.cir"
echo ">> Layout    : $GDS"
echo ">> Esquematico: $NETLIST"
echo ">> Runset    : $RUNSET"
echo ">> Corriendo LVS (KLayout, batch)..."

klayout -b -r "$RUNSET" \
  -rd input="$GDS" \
  -rd schematic="$NETLIST" \
  -rd report="$REPORT" \
  -rd target_netlist="$EXTRACTED" \
  -rd top_cell="$TOP" \
  -rd thr="$(nproc 2>/dev/null || echo 4)" \
  -rd run_mode=deep \
  -rd spice_net_names=true \
  -rd spice_comments=false \
  -rd net_only=false \
  -rd top_lvl_pins=true \
  -rd combine=false \
  -rd purge=false \
  -rd purge_nets=false \
  -rd no_simplify=false \
  2>&1 | tee "$OUT/lvs.log" || true

echo "----------------------------------------"
# OJO: revisar el FALLO primero -- "don't match" contiene "match".
if grep -qiE "don'?t match|do not match|not match|ERROR *: *Netlists" "$OUT/lvs.log"; then
  echo " LVS: MISMATCH ✗  -> abre $REPORT en KLayout (Tools -> Netlist Browser)"
  echo "      los dispositivos/nets en rojo son los que no cuadran."
elif grep -qiE "Congratulations|Netlists match" "$OUT/lvs.log"; then
  echo " LVS: MATCH ✓  (el layout == el esquematico)"
else
  echo " LVS termino sin veredicto claro. Revisa $OUT/lvs.log"
fi
echo "----------------------------------------"
echo " Base LVS : $REPORT"
echo " Netlist extraido: $EXTRACTED"
