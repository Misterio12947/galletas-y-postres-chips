#!/usr/bin/env bash
# Abre el esquematico del OTA en xschem (GUI), sin importar el CWD.
# Lanzalo SIEMPRE desde una terminal (no con doble clic en el gestor de
# archivos): asi xschem conserva su terminal y, si algo falla al arrancar,
# ves el mensaje en vez de que la ventana parpadee y se cierre.
#
# Uso:  ./abrir_xschem.sh
set -e

HERE="$(cd "$(dirname "$0")" && pwd)"
REPO="$(cd "$HERE/../../.." && pwd)"
DESIGN="$REPO/common/analog/ota5t"

if ! command -v xschem >/dev/null 2>&1; then
  echo "ERROR: xschem no esta en el PATH. Carga tu entorno SKY130."
  exit 1
fi

# xschem resuelve mejor la libreria estando en el directorio del diseno.
cd "$DESIGN"
echo ">> Abriendo OTA_5T.sch en xschem (desde $DESIGN)..."
exec xschem OTA_5T.sch
