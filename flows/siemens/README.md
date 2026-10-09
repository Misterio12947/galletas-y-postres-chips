# Flujo Siemens

Scripts (`.do`, `.tcl`, `.sh`) para el flujo comercial Siemens EDA, que
consumen el RTL de `common/`. **No subas** binarios ni librerías con licencia
(ver CONTRIBUTING y `.gitignore`).

| Etapa | Carpeta | Herramienta |
|---|---|---|
| RTL / sim | `02-rtl/` | Questa |
| Síntesis | `06-sintesis/` *(pendiente)* | Oasys-RTL |
| PnR | `07-pnr/` *(pendiente)* | Nitro / Aprisa |
| Signoff | `08-sta-signoff/` *(pendiente)* | Calibre (DRC/LVS) |
