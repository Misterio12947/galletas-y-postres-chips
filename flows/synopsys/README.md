# Flujo Synopsys

Scripts (`.tcl`, `.sh`) para el flujo comercial Synopsys, que consumen el RTL
de `common/`. **No subas** binarios, librerías con licencia ni PDKs de
foundry (ver CONTRIBUTING y `.gitignore`).

| Etapa | Carpeta | Herramienta |
|---|---|---|
| RTL / sim | `02-rtl/` | VCS, Design Compiler (lectura) |
| Síntesis | `06-sintesis/` *(pendiente)* | Design Compiler |
| PnR | `07-pnr/` *(pendiente)* | IC Compiler II |
| STA + signoff | `08-sta-signoff/` *(pendiente)* | PrimeTime, IC Validator, StarRC |
| Analógico | `09-12-analog/` *(pendiente)* | PrimeSim |
