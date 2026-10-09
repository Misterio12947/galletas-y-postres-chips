#!/usr/bin/env bash
# Crea el repo en GitHub y sube este contenido. Requiere la CLI `gh`
# autenticada (gh auth login). Ejecútalo DESDE la raíz del repo.
#
#   bash scripts/crear-repo.sh <usuario-u-org>/galletas-y-postres-chips [public|private]
set -euo pipefail

REPO="${1:?Uso: crear-repo.sh <owner>/<repo> [public|private]}"
VIS="${2:-private}"      # por defecto privado

git init -b main
git add .
git commit -m "Inicio: estructura del repo + demo RTL (semaforo) y MinyPLD"

# Crea el repo remoto y hace push (gh usa tu sesión autenticada)
gh repo create "$REPO" --"$VIS" --source=. --remote=origin --push

echo "Listo. Repo: https://github.com/$REPO"
echo "Sugerencia: protege 'main' (Settings > Branches) para forzar PRs."
