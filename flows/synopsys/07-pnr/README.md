# Place & Route (Synopsys) - IC Compiler II

Demo de la **Capsula 7 (Tres Leches)** con la herramienta comercial. Mismo
`semaforo`, misma idea que el flujo open source (OpenROAD, en
`flows/opensource/07-pnr/`): del netlist a un **layout** con
floorplan -> placement -> CTS -> routing, y escribe el layout + el **SPEF**
(parasitos) para el signoff.

`run_icc2.tcl` es **un solo script de referencia** (no uno por etapa), con la
estructura del flujo SKY130 del Microprocessor_PLC.

## Requisitos

- IC Compiler II (`icc2_shell`).
- Librerias de referencia **NDM** + technology file (`.tf`) + **TLUPlus**
  (parasitos) + mapa de capas. ICC2 no lee LEF/liberty crudos: usa librerias
  ya preparadas. Las rutas estan en el bloque SETUP de `run_icc2.tcl`
  (apuntan a `/home/SHARE-DATA/technology/pdksy/sky130`).
- El **netlist** a nivel de compuertas mapeado a SKY130 (de Polvorones).

## Correr

```bash
cd flows/synopsys/07-pnr
cp ../06-sintesis/netlist.v .     # el netlist de DC (o run_icc2.sh lo sintetiza)
./run_icc2.sh
```

## Que hace `run_icc2.tcl` (un solo script)

```
# setup: NDM + tech + TLUPlus + mapa + db_nldm
create_lib (-technology .tf -ref_libs .ndm)
read_verilog + link_block                 ; aqui nace el bloque actual
create_corner + read_parasitic_tech + set_parasitic_parameters   ; parasitos (TLUPlus)
create_mode + create_scenario + read_sdc  ; modo/escenario + el plazo
connect_pg_net -auto                       ; conecta power/ground
initialize_floorplan + place_pins          ; floorplan
place_opt                                  ; placement
clock_opt                                  ; CTS (arbol de reloj) + opt
route_auto + route_opt                     ; routing
report_qor / report_timing / report_utilization
write_def / write_gds / write_verilog      ; el layout + netlist ruteado
write_parasitics (SPEF) / write_sdc        ; signoff -> alimenta PrimeTime (Cajeta)
```

Entre etapas hace `save_block -as post_<etapa>` (floorplan / placement / cts /
route), util para abrir cualquier paso en el GUI de ICC2.

## Resultado de referencia (CW=8)

| | OpenROAD (OSS) | ICC2 (Synopsys) |
|---|---|---|
| Area de celdas | ~489 um^2 | ~405 um^2 |
| Utilizacion | ~43% | ~50.6% |
| Slack @ 100 MHz | +8.50 ns | +7.49 ns |
| Violaciones | 0 | 0 |

Mismo RTL y misma tecnologia SKY130; los numeros no son identicos porque cada
herramienta inserta celdas fisicas distintas (OpenROAD agrego tapcells/endcaps
y buffers de CTS, 38->80 celdas; este flujo ICC2 minimo se quedo en 38). El
concepto y el flujo son el mismo -- ese es el gancho de la capsula.

## Notas

- **~2800 warnings `POW-080`**: son de power/ground. Esta demo **no** construye
  una malla de potencia (PG ring/straps), asi que ICC2 avisa, pero el routing de
  senal completa. Para un signoff "limpio" se agrega un paso de PG; como
  referencia del flujo asi esta bien.
- Sintaxis util de ICC2 (nos mordio): `write_def`/`write_verilog` van con el
  **nombre posicional**; `write_parasitics`/`write_sdc` usan `-output`.
- Los artefactos (`*.dlib/`, `results/`, `reports/`, `icc2.log`, `netlist.v`)
  estan en el `.gitignore`.

## Callback / relevo

El **SPEF** (`results/semaforo.spef`) lleva los parasitos reales del layout: es
justo lo que lee PrimeTime para **firmar** el timing -> **Cajeta (STA)**, la
siguiente capsula.