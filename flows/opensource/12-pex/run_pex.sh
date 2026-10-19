#!/usr/bin/env bash
# Capirotada (Capsula 12) - PEX: extrae R/C parasitos del layout con Magic.
# Adaptado del run_pex.sh del curso. Lee el GDS de common/ y escribe el netlist
# parasitado en results/. Nucleo Magic (ext2spice) identico al original.
#
# Uso (desde flows/opensource/12-pex/):
#   ./run_pex.sh
set -e
set +H

HERE="$(cd "$(dirname "$0")" && pwd)"
REPO="$(cd "$HERE/../../.." && pwd)"
DESIGN="$REPO/common/analog/ota5t"
CELL="OTA_5T"
GDS="$DESIGN/$CELL.gds"
LVS="$DESIGN/$CELL.spice"          # para el orden "golden" de puertos
OUT="$HERE/results"
PEX="$OUT/${CELL}_pex.spice"
mkdir -p "$OUT"

if ! command -v magic >/dev/null 2>&1; then
  echo "ERROR: magic no esta en el PATH. Carga tu entorno SKY130."; exit 1
fi
for f in "$GDS" "$LVS"; do [ -f "$f" ] || { echo "ERROR: falta $f"; exit 1; }; done

# --- orden golden de puertos (del .subckt del netlist LVS) ---
SUBCKT_LINE="$(grep -i '^\.subckt' "$LVS" | head -n1)"
GOLDEN_PORTS="$(echo "$SUBCKT_LINE" | awk '{$1="";$2="";print $0}' | xargs)"
echo ">> Puertos golden: $GOLDEN_PORTS"

# --- PDK: localizar sky130A y el magicrc ---
SKY=""
for c in "$PDK_ROOT/sky130A" /foss/pdks/sky130A "$HOME/.volare/sky130A" "$HOME/.ciel/sky130A"; do
  [ -d "$c" ] && { SKY="$c"; break; }
done
[ -n "$SKY" ] || { echo "ERROR: no encontre sky130A (exporta PDK_ROOT)."; exit 1; }
export PDK_ROOT="${SKY%/sky130A}"
MAGICRC="$(find "$SKY/libs.tech/magic" -name 'sky130A.magicrc' 2>/dev/null | head -1)"
[ -n "$MAGICRC" ] || { echo "ERROR: no encontre sky130A.magicrc"; exit 1; }
echo ">> PDK_ROOT : $PDK_ROOT"
echo ">> magicrc  : $MAGICRC"

# --- correr Magic desde results/ (los .ext/.sim temporales caen aqui) ---
cd "$OUT"
rm -f ${CELL}*.ext ${CELL}*.sim ${CELL}*.nodes ${CELL}*.res.ext
TCL="run_magic_pex_${CELL}.tcl"
cat > "$TCL" <<EOF
gds flatten yes
gds read $GDS
load ${CELL}
select top cell

extract all

# Extraccion SOLO-C: capacitancias de acople (sin extresist).
# Asi los nodos quedan LIMPIOS (VIN, VINP, IB, VSS...) en vez de partirse en
# sub-nodos _uq0/.t* -- mucho mas facil de re-simular. La C domina la caida de
# ancho de banda; la R de estos cables cortos es despreciable.
ext2spice cthresh 0.01
ext2spice subcircuit top on
ext2spice -o ${CELL}_pex.spice

quit
EOF

echo ">> Extrayendo parasitos con Magic..."
magic -dnull -noconsole -rcfile "$MAGICRC" "$TCL" > magic_pex.log 2>&1 || {
  echo "ERROR: Magic fallo. Revisa $OUT/magic_pex.log"; exit 1; }

# --- post-proceso: promover nodos a PUERTOS del subckt ---
if [ -f "${CELL}_pex.spice" ]; then
  sed -i 's/\*\*.*//g' "${CELL}_pex.spice"

  # Fusionar fragmentos de un mismo net (VIN_uq0 -> VIN, IB_uq0 -> IB,
  # VSS_uq1 -> VSS...). Esta celda standalone tiene cada label repartido en
  # piezas no unidas por metal (se conectarian "mas arriba" en la jerarquia);
  # aqui las unimos para poder re-simular. Es el mismo origen que el must-connect
  # del LVS. Sin esto, la corriente de bias (IB) nunca llega al diodo (IB_uq0).
  sed -i -E 's/_uq[0-9]+//g' "${CELL}_pex.spice"

  # Detectar el nodo de sustrato (bulk de los nfet, p.ej. VSUBS) para exponerlo
  # y poder aterrizarlo en el testbench.
  SUBNODE="$(grep -m1 'nfet_01v8' "${CELL}_pex.spice" | awk '{print $5}')"
  PORTS="$GOLDEN_PORTS"
  if [ -n "$SUBNODE" ] && ! echo " $PORTS " | grep -q " $SUBNODE "; then
    PORTS="$PORTS $SUBNODE"
  fi
  echo ">> Puertos a exponer: $PORTS"

  # Magic emite '.subckt OTA_5T' sin puertos (los labels quedan como nodos
  # internos). Inyectamos la lista de puertos reemplazando esa linea completa.
  sed -i -E "s/^[.]subckt[[:space:]]+${CELL}([[:space:]].*)?$/.subckt ${CELL} ${PORTS}/I" "${CELL}_pex.spice"
else
  echo "ERROR: Magic no genero el netlist PEX."; exit 1
fi

rm -f "$TCL" ${CELL}*.ext ${CELL}*.sim ${CELL}*.nodes ${CELL}*.res.ext
echo "----------------------------------------"
echo " Netlist PEX (devices + C parasitas): $PEX"
echo " C extraidas: $(grep -ciE '^C' "$PEX" || echo 0)   (extraccion solo-C)"
echo " subckt: $(grep -i '^\.subckt' "$PEX" | head -1)"
echo "----------------------------------------"
echo ">> Ahora re-simula con parasitos:  ./run_resim_pex.sh ac"
