# Sintesis ASIC (Synopsys) - Design Compiler

Demo de la **Capsula 6 (Polvorones)** con la herramienta comercial. Mismo
`semaforo`, misma idea que el flujo open source (`flows/opensource/06-sintesis/`):
del RTL a un **netlist de compuertas**, reportando **area, timing y celdas**.

Para que los numeros se puedan comparar con Yosys, usamos la **misma liberty**
(SKY130 HD), compilada a `.db` con Library Compiler.

## Requisitos

- Design Compiler (`dc_shell`) + Library Compiler (`lc_shell`). Confirma que
  esten en el PATH:

  ```bash
  which dc_shell lc_shell
  ```

- La liberty de SKY130 HD (`sky130_fd_sc_hd__tt_025C_1v80.lib`), la misma del
  flujo open source. La ruta cambia segun la maquina (volare la instala bajo
  `ciel/`), asi que localizala:

  ```bash
  find "$HOME" /opt /eda -name 'sky130_fd_sc_hd__tt_025C_1v80.lib' 2>/dev/null | head
  ```

  `PDK_ROOT` es el directorio que **contiene** `sky130A/`. Con el layout de
  `ciel` queda algo asi (ejemplo real en el server del evento):

  ```bash
  export PDK_ROOT=$HOME/pdk/ciel/sky130/versions/<hash>
  # p.ej. .../pdk/ciel/sky130/versions/1689ac3f2dc763876eaf967227c7dfe831b031ae
  ```

> **Alternativa sin SKY130:** si prefieres las librerias educativas que ya trae
> tu instalacion de Synopsys (p. ej. SAED32), cambia `SKY130_DB`/`target_library`
> en `compile.tcl` al `.db` de SAED32 y salta el paso de Library Compiler. Los
> numeros no empataran con Yosys (es otra tecnologia), pero el flujo es identico.

## Correr

```bash
cd flows/synopsys/06-sintesis
export PDK_ROOT=...                 # el directorio que contiene sky130A/ (ver arriba)
./run_dc.sh
```

`run_dc.sh` compila la `.lib` a `.db` la primera vez (Library Compiler, ~1 min)
y luego corre `dc_shell -f compile.tcl`. Tambien puedes hacerlo a mano:

```bash
lc_shell -f lib/compile_lib.tcl     # .lib -> lib/*.db   (solo la 1a vez)
dc_shell -f compile.tcl             # sintesis
```

> Library Compiler tira varios *warnings* al leer la SKY130 (atributos que
> ignora): es normal, mientras genere el `.db` el flujo sigue.

## Que mostrar en vivo

1. El `report_area` y el `report_qor`: **area total** y **numero de celdas**
   (las polvorones del lado comercial).
2. El `report_timing`: la **ruta critica** y su **slack** -> aqui se ve si
   cumple el reloj que pusimos en `semaforo.sdc`.
3. `head netlist.v`: el RTL convertido en **instancias de celdas SKY130**.
4. **Comparar con Yosys** (misma liberty, mismo RTL): los numeros no son
   identicos (cada sintetizador optimiza distinto) pero el concepto es el mismo.

## Resultado de referencia (semaforo, SKY130 HD, CW=8)

| | Yosys (open source) | Design Compiler |
|---|---|---|
| Celdas estandar | 37 | 38 |
| Area total | ~450 um^2 | ~400 um^2 |
| Flip-flops | 11 | 10 |
| Codificacion de estado | one-hot (3 bits) | binaria (2 bits) |
| Slack @ 100 MHz (10 ns) | (Yosys no hace STA) | +7.46 ns (cumple) |

El aprendizaje de la capsula: **mismo RTL, resultados comparables pero no
identicos**. La diferencia de flip-flops es la codificacion de la FSM (el
contador son 8 FFs en ambas); Design Compiler ademas reporta *timing* y aqui el
semaforo cumple el reloj con muchisimo margen (ruta critica ~0.54 ns).

## Que hace `compile.tcl`

```
analyze/elaborate       ; lee y elabora el RTL (aqui se fijan parametros, p.ej. CW)
source semaforo.sdc     ; carga el plazo (create_clock)
compile_ultra           ; sintetiza y optimiza (PPA)
report_area/timing/qor  ; los numeros (van a reports/)
write ... netlist.v     ; el netlist de compuertas
```

## Artefactos (no se versionan)

La corrida deja intermedios en la carpeta que **no** entran al repo (estan en el
`.gitignore` de la raiz): `lib/*.db`, `netlist.v`, `reports/`, `dc.log`,
`command.log`, `lc_command.log`, `lc_output.txt`, `default.svf`, `alib-*/`,
`cksum_dir/`, `SEMAFORO.mr`, `*.pvl`, `*.syn`. Solo se versionan los fuentes:
`compile.tcl`, `semaforo.sdc`, `lib/compile_lib.tcl`, `run_dc.sh` y este README.

## Callback: equivalence checking

`compile_ultra` reorganiza todo. Para **demostrar** que el netlist == RTL se usa
**Formality** (`fm_shell`) o VC Formal (FEV). Es el mismo motor formal de la
**Gelatina** (Capsula 4), ahora comparando RTL vs netlist -- la red de seguridad
de la sintesis.