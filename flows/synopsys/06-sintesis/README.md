# Sintesis ASIC (Synopsys) - Design Compiler

Demo de la **Capsula 6 (Polvorones)** con la herramienta comercial. Mismo
`semaforo`, misma idea que el flujo open source (`flows/opensource/06-sintesis/`):
del RTL a un **netlist de compuertas**, reportando **area, timing y celdas**.

Para que los numeros se puedan comparar con Yosys, usamos la **misma liberty**
(SKY130 HD), compilada a `.db` con Library Compiler.

## Requisitos

- Design Compiler (`dc_shell`) + Library Compiler (`lc_shell`).
- La liberty de SKY130 HD (`sky130_fd_sc_hd__tt_025C_1v80.lib`), la misma del
  flujo open source. Define `PDK_ROOT`:

  ```bash
  export PDK_ROOT=$HOME/pdk     # donde esta sky130A/libs.ref/...
  ```

> Si prefieres usar las librerias educativas que ya trae tu instalacion de
> Synopsys (p. ej. SAED32), cambia `SKY130_DB`/`target_library` en
> `compile.tcl` a su `.db` y salta el paso de Library Compiler.

## Correr

```bash
cd flows/synopsys/06-sintesis
./run_dc.sh
```

`run_dc.sh` compila la `.lib` a `.db` la primera vez (Library Compiler) y luego
corre `dc_shell -f compile.tcl`. Tambien puedes hacerlo a mano:

```bash
lc_shell -f lib/compile_lib.tcl     # .lib -> lib/*.db   (solo la 1a vez)
dc_shell -f compile.tcl             # sintesis
```

## Que mostrar en vivo

1. El `report_area` y el `report_qor` al final: **area total** y **numero de
   celdas** (las polvorones del lado comercial).
2. El `report_timing`: la **ruta critica** y su **slack** -> aqui se ve si
   cumple el reloj que pusimos en `semaforo.sdc`.
3. `head netlist.v`: el RTL convertido en **instancias de celdas SKY130**.
4. **Comparar con Yosys** (open source): misma liberty, mismo RTL. Los numeros
   no son identicos (cada sintetizador optimiza distinto) pero el **concepto es
   el mismo**. Ese es el punto de la capsula.

## Que hace `compile.tcl`

```
analyze/elaborate  ; lee y elabora el RTL (aqui se fijan parametros, p.ej. CW)
source ...sdc      ; carga el plazo (create_clock)
compile_ultra      ; sintetiza y optimiza (PPA)
report_area/timing/qor ; los numeros
write ... netlist.v    ; el netlist de compuertas
```

## Callback: equivalence checking

`compile_ultra` reorganiza todo. Para **demostrar** que el netlist == RTL se usa
**Formality** (`fm_shell`) o VC Formal (FEV). Es el mismo motor formal de la
**Gelatina** (Capsula 4), ahora comparando RTL vs netlist -- la red de seguridad
de la sintesis.
