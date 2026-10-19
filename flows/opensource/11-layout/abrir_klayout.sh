#!/usr/bin/env bash
# Abre el layout del OTA en KLayout con las capas de SKY130 (tech + layer props).
# Asi se ve con los colores correctos, no con el PDK por defecto (p.ej. sg13g2).
#
# Uso (desde flows/opensource/11-layout/):
#   ./abrir_klayout.sh
set -e

HERE="$(cd "$(dirname "$0")" && pwd)"
REPO="$(cd "$HERE/../../.." && pwd)"
GDS="$REPO/common/analog/ota5t/OTA_5T.gds"

if ! command -v klayout >/dev/null 2>&1; then
  echo "ERROR: klayout no esta en el PATH. Carga tu entorno SKY130."; exit 1
fi
if [ ! -f "$GDS" ]; then
  echo "ERROR: no encuentro el GDS en $GDS"; exit 1
fi

# --- localizar el directorio sky130A del PDK ---
SKY=""
for c in "$PDK_ROOT/sky130A" /foss/pdks/sky130A "$HOME/.volare/sky130A" "$HOME/.ciel/sky130A"; do
  if [ -d "$c" ]; then SKY="$c"; break; fi
done
if [ -z "$SKY" ]; then
  echo "AVISO: no encontre sky130A; abro sin tech (puede verse con colores raros)."
  exec klayout -e "$GDS"
fi

# --- tech (.lyt) y layer properties (.lyp) de sky130 ---
LYT="$(find "$SKY/libs.tech/klayout" -name 'sky130A.lyt' 2>/dev/null | head -1)"
LYP="$(find "$SKY/libs.tech/klayout" -name 'sky130A.lyp' 2>/dev/null | head -1)"

echo ">> GDS : $GDS"
echo ">> tech: ${LYT:-<no encontrado>}"
echo ">> lyp : ${LYP:-<no encontrado>}"

ARGS=(-e)
[ -n "$LYT" ] && ARGS+=(-nn "$LYT")
[ -n "$LYP" ] && ARGS+=(-l "$LYP")
exec klayout "${ARGS[@]}" "$GDS"
