# Flujo Synopsys

Scripts (`.tcl`, `.sh`) para el flujo comercial Synopsys, que consumen el RTL
de `common/`. **No subas** binarios, librerías con licencia ni PDKs de
foundry (ver CONTRIBUTING y `.gitignore`).

Mismo diseño que el lado open source (el semáforo), como gemelo comercial de
cada cápsula digital.

| Etapa | Carpeta | Herramienta |
|---|---|---|
| RTL / sim | `02-rtl/` | VCS, Design Compiler (lectura) |
| Síntesis | `06-sintesis/` | Design Compiler (+ Library Compiler para el `.db`) |
| PnR | `07-pnr/` | IC Compiler II |
| STA + signoff | `08-sta/` | PrimeTime (+ IC Validator / StarRC) |
| Analógico | `09-12-analog/` *(pendiente)* | Custom Compiler, PrimeSim, StarRC |

## Qué hay en cada etapa

- **`06-sintesis/`** — `compile.tcl` (analyze/elaborate/`compile_ultra`/reportes/
  `write` del netlist) + `semaforo.sdc`; `lib/compile_lib.tcl` genera el `.db`
  desde el `.lib` de SKY130 con Library Compiler. Gemelo de Yosys.
- **`07-pnr/`** — `run_icc2.tcl`: flujo de referencia en IC Compiler II
  (NDM, corner/mode/scenario, TLUPlus, floorplan → place → CTS → route),
  salidas: netlist ruteado, DEF, SPEF. Gemelo de OpenROAD.
- **`08-sta/`** — `pt.tcl`: firma de timing con PrimeTime leyendo el netlist
  ruteado + el **SPEF** de PnR. Gemelo de OpenSTA.

Cada carpeta trae su `README.md` con cómo correrlo y qué mostrar.

## Analógico (pendiente)

El riel analógico (esquemático → sim → layout → PEX) de momento va **solo open
source** (`flows/opensource/09-esquematico` … `12-pex`). El gemelo Synopsys
(Custom Compiler, PrimeSim, StarRC, IC Validator) queda por montar.

## Nada bajo NDA

Prohibido subir PDKs de foundry, modelos SPICE propietarios, librerías
`.lib`/`.db`/`.lef` con licencia, binarios de EDA o reportes con datos
protegidos. PDK de referencia: **SKY130** (abierto). Ver CONTRIBUTING.