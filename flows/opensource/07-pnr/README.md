# Place & Route (open source) - OpenROAD + SKY130

Demo de la **Capsula 7 (Tres Leches)** en linea de comandos. Toma el netlist del
`semaforo` (de Polvorones) y lo vuelve **geometria**: floorplan -> placement ->
CTS (reloj) -> routing (senal), y escribe el **layout** (DEF + GDS) + reportes.

Las "tres leches" que empapan el diseno colocado: **power** (malla), **clock**
(CTS) y **signal** (routing). Aqui vemos sobre todo clock y signal; la malla de
power (PDN) se menciona pero se omite en esta demo minima.

Es el gemelo open source del lado Synopsys (IC Compiler II, en
`flows/synopsys/07-pnr/`).

## Requisitos

- `openroad` + `yosys` (el PnR y la sintesis).
- `magic` (genera el GDS) y `klayout` (ver el layout). Todo esto ya viene en la
  caja FOSS del evento (`/foss/tools/bin`).
- SKY130 HD (la misma del flujo de sintesis). El script **auto-detecta**
  `.lib`, `techlef`, `lef`, el GDS de celdas y el `magicrc` en `/foss/pdks` y
  `$HOME`, y deriva `PDK_ROOT` solo. Si hace falta, pasa las rutas a mano:

  ```bash
  LIB=/ruta/sky130_fd_sc_hd__tt_025C_1v80.lib \
  TECHLEF=/ruta/sky130_fd_sc_hd__nom.tlef \
  CELLLEF=/ruta/sky130_fd_sc_hd.lef \
  ./run_pnr.sh
  ```

## Correr

```bash
cd flows/opensource/07-pnr
./run_pnr.sh
```

Hace, en orden:
1. **Yosys** sintetiza el netlist (mismo recipe que Polvorones).
2. **OpenROAD** (`pnr.tcl`) corre los 7 pasos marcados (`==> 1/7` ... `7/7`) y
   escribe `results/semaforo.def` + `.odb` + reportes.
3. **Magic** (`def2gds.tcl`) convierte el DEF en `results/semaforo.gds`.

Todo queda en `results/` y el log completo en `pnr.log`.

## Ver el layout en KLayout

El GDS es SKY130, pero KLayout a veces arranca con **otra** tecnologia (p. ej.
el PDK de IHP `sg13g2`) y lo pinta con colores y nombres de capa equivocados. Es
solo cosmetico, pero para verlo bien hay que darle la tech de SKY130:

```bash
cd results
P=$(ls -d /foss/pdks/ciel/sky130/versions/*/sky130A)/libs.tech/klayout/tech
klayout -nn "$P/sky130A.lyt" -l "$P/sky130A.lyp" semaforo.gds
```

- `-nn` carga la **tecnologia** sky130A, `-l` carga los **colores** de sus capas.
- Si ya lo tienes abierto: **File -> Load Layer Properties...** -> `sky130A.lyp`
  -> *Apply to all layouts*.
- Bien cargado se ven li1, met1, met2... en sus colores, las celdas y el routing.

## Que mostrar en vivo

1. El **log por pasos** (`==> 1/7 Floorplan` ... `7/7 Routing`): el pipeline
   fisico avanzando.
2. Los **reportes**: `report_design_area` (area del core) y
   `report_worst_slack` / `report_tns` (timing **ya con parasitos** del routing).
3. El **layout** en KLayout: las celdas colocadas en hileras y el routing en
   capas de metal conectandolas. El mismo `semaforo` que simulamos, ahora fisico.

## Resultado de referencia (CW=8)

- Area del core ~**489 um^2**, die ~41.5 x 41.5 um, utilizacion ~43%.
- Timing: **slack +8.50 ns** sobre un reloj de 10 ns, 0 violaciones.
- El PnR **agrega celdas** que el netlist no tenia: 14 tapcells, 24 endcaps y
  3 buffers de reloj (el CTS). Por eso el area crece respecto a la sintesis.

## Como funciona

`pnr.tcl` (OpenROAD):

```
read_lef (tech + celdas)      ; la forma fisica de cada celda (el LEF)
read_liberty / read_verilog   ; timing + netlist de Polvorones
initialize_floorplan          ; define el area del chip
place_pins                    ; pines de IO en el borde
global/detailed_placement     ; acomoda las celdas en hileras
clock_tree_synthesis (CTS)    ; reparte el reloj parejo a los FFs
global_route + detailed_route ; conecta todo con capas de metal
write_def / write_db          ; el layout (DEF) + la base de datos (ODB)
```

`def2gds.tcl` (Magic): OpenROAD **no** genera GDS; Magic lo arma leyendo
el **tech LEF** (que define los vias del routing), el **GDS de celdas** del PDK
(la geometria real) y el **DEF**, y los funde en `semaforo.gds`. Es el mismo
paso que hace OpenLane.

## Notas

- `PDK_ROOT`: el script lo **deriva de la liberty** y sobre-escribe el del
  entorno. En la caja FOSS el `PDK_ROOT` de sistema apunta mal (`/headless/pdk`),
  y Magic lo necesita bien para encontrar su tech; por eso se fija aqui.
- El tech LEF **tiene que leerse antes del DEF** en Magic: define los vias
  (`M1M2_PR`, `L1M1_PR_MR`...). Sin eso, Magic tira el routing (el GDS sale solo
  con celdas, sin metales).
- `tapcell` va en `catch`: si fallara, el flujo sigue y deja el `.def`.
- La version **interactiva** (visor del layout + metricas) esta en el notebook
  de `flows/opensource/notebooks/`, que renderiza desde el `.def` con Python.
- Los artefactos (`results/`, `pnr.log`, `netlist.v`) estan en el `.gitignore`.

## Callback / relevo

Aqui aparecen los **cables reales** (R y C). Por eso el timing ya no se estima:
se **firma** en el signoff estatico -> **Cajeta (STA)**, la siguiente capsula.
