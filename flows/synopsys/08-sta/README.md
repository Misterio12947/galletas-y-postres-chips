# STA / Signoff (Synopsys) - PrimeTime

Demo de la **Capsula 8 (Cajeta)** con la herramienta comercial. **Firma** el
timing del `semaforo` leyendo el **netlist ruteado + el SPEF** que genero ICC2
en Tres Leches -> setup y hold con los **parasitos reales** del layout.

Gemelo del lado open source (OpenSTA, en `flows/opensource/08-sta/`).

## Requisitos

- PrimeTime (`pt_shell`).
- Librerias de timing **.db** (NLDM) de SKY130 -> en `pt.tcl` via `link_library`
  (apunta a `.../sky130_fd_sc_hd/db_nldm`). **Confirma el nombre del `.db`.**
- Las salidas de Tres Leches (ICC2): `../07-pnr/results/semaforo_routed.v` y el
  SPEF `../07-pnr/results/semaforo.spef.maxTLU_100.spef`. **Confirma el nombre
  del `.spef`** (lo escribio `write_parasitics`).

## Correr

```bash
cd flows/synopsys/08-sta
./run_pt.sh        # exige que Tres Leches (ICC2) ya haya corrido
```

## Que hace `pt.tcl`

```
set link_library (.db NLDM)       ; timing de las celdas
read_verilog semaforo_routed.v    ; el netlist post-ruteo (de ICC2)
link_design                        ; resuelve las celdas
read_sdc semaforo.sdc              ; el plazo (create_clock)
read_parasitics semaforo.spef      ; los parasitos REALES del layout
update_timing
report_timing -delay_type max/min  ; setup y hold
report_qor
```

## Que mostrar en vivo

1. `report_timing -delay_type max` (**setup**) y `-delay_type min` (**hold**):
   el camino critico y su **slack**.
2. `report_qor`: WNS/TNS globales.
3. **El puente del flujo**: el SPEF que lee PrimeTime lo escribio ICC2 en la
   capsula anterior. PnR produce el SPEF; STA lo firma. Mismo veredicto que el
   lado open source (OpenSTA).

## Notas

- `report_timing`/`report_qor`/`reports/`, `pt.log` y `*.svf` estan en el
  `.gitignore`.
- Si tu `.db` o `.spef` tienen otro nombre, ajusta `link_library` y `SPEF` en
  `pt.tcl` (son las dos lineas marcadas con `<-- confirma`).

## Callback / relevo

Con el timing **firmado**, el chip digital esta listo (RTL -> GDS que cumple el
reloj). Lo que sigue es el mundo **analogico** -> 🧅 Bunuelo (esquematico).
