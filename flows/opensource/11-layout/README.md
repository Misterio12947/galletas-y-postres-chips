# Layout (open source) - Magic / KLayout

Demo de la **Capsula 11 (Alfajor)**: volver el OTA **silicio**. El layout dibuja
las **capas fisicas** (mascaras) que se mandan a fabricar, y se verifica con
**DRC** (reglas del fab) y **LVS** (coincide con el esquematico).

El layout (`OTA_5T.gds`) vive en
[`common/analog/ota5t/`](../../../common/analog/ota5t/) junto al esquematico, y
lo reusa tambien Capirotada (PEX).

## Requisitos

- **KLayout** (ver el layout + correr DRC) y/o **Magic** (editarlo).
- El PDK **SKY130** con los archivos de KLayout
  (`.../sky130A/libs.tech/klayout/`): tech `.lyt`, layer props `.lyp` y el
  runset DRC `sky130A_mr.drc`. Los scripts autodetectan `PDK_ROOT`.

## Ver el layout

```bash
cd flows/opensource/11-layout
./abrir_klayout.sh
```

Abre el GDS **con las capas de SKY130** (tech + `.lyp`), no con el PDK por
defecto. Si lo abres a mano, pasale el tech para no verlo con colores de otro
PDK (nos paso con sg13g2):

```bash
klayout -e -nn <sky130A.lyt> -l <sky130A.lyp> \
   ../../../common/analog/ota5t/OTA_5T.gds
```

## Correr DRC

```bash
./run_drc.sh        # runset SKY130 (KLayout) -> results/OTA_5T_drc.xml
```

Reporta el numero de violaciones. **Nuestro OTA: 0 violaciones** (256 reglas).
Para inspeccionarlas (si hubiera) en KLayout: `Tools -> Marker Browser`.

## El layout por dentro (que mostrar en vivo)

~228 um2 (15.5 x 14.7 um). Dos bloques dentro de **guard rings**:

- **Arriba (nwell):** el espejo PMOS M5/M6.
- **Abajo:** el par diferencial NMOS M3/M4 + el bias M1/M2 + dummies.

Lo clave es el **matching**: cada transistor es un **arreglo de fingers**
(el `m=4` del netlist = 4 dedos), **interdigitados** con su pareja, con
**dummies** en los bordes y **guard rings** alrededor. Hacer zoom al par
diferencial para ver los dedos intercalados.

## Correr LVS (layout vs schematic)

```bash
./run_lvs.sh        # compara el GDS vs el netlist del esquematico
```

Confirma que el layout es **el mismo circuito** que el esquematico (mismos
transistores y conexiones). Usa como referencia el netlist
`common/analog/ota5t/OTA_5T.spice` (el que netlisteamos en Bunuelo) y el runset
LVS de SKY130 (KLayout). Salidas en `results/`: la base `OTA_5T.lvsdb` (se abre
en KLayout con `Tools -> Netlist Browser`) y el netlist extraido del layout.

> ### Estado del LVS en este diseño (importante y honesto)
>
> Sobre el OTA del curso, el LVS **no da MATCH** tal cual, y lo mostramos como
> **flujo** (como se corre y como se lee el resultado), no como un check en
> verde. El dibujo **no** tiene el problema: el DRC esta **limpio** y la
> topologia del layout es **equivalente** al esquematico (los 8 transistores,
> con sus conexiones). El mismatch es de **setup de LVS en una celda standalone**:
>
> - En el **Netlist Browser** (`Tools -> Netlist Browser`, abrir
>   `results/OTA_5T.lvsdb`) se ve:
>   - Avisos **`[must-connect]`** en VIN/VSS/IB/VINP: son redes de
>     alimentacion/bias/IO que la celda conecta por **etiquetas** y que se
>     uniran "mas arriba" (normal en un bloque suelto, no en el chip completo).
>   - Todas las redes en **rojo** ("not matching reference"): el lado
>     esquematico no entrega dispositivos comparables porque el runset lee los
>     `sky130_fd_pr__*` como **subcircuitos** (`Convert subcircuits: false`), no
>     como transistores primitivos.
>
> **Para dejarlo en verde** habria que iterar el setup: que los `sky130_fd_pr__*`
> del netlist se reconozcan como dispositivos y manejar las redes *must-connect*
> de la celda standalone (p.ej. envolverla en un top que una VDD/VSS/bias). Es
> trabajo de EDA sobre un diseño prestado; queda como mejora futura.
>
> **Como leer esta pantalla es, de hecho, la parte didactica:** rojo = no
> empareja, amarillo = red partida. Eso es lo que se enseña en vivo.

## Que mostrar en vivo

1. `./abrir_klayout.sh`: el layout con colores correctos; zoom al matching.
2. `./run_drc.sh`: **0 violaciones** -> el dibujo respeta las reglas del fab.
3. `./run_lvs.sh` + Netlist Browser: mostrar **como se lee un LVS** (rojo = no
   empareja, amarillo = red partida). Ver la nota de estado del LVS arriba.

## Callback / relevo

El OTA ya es **silicio verificado** (DRC + LVS). Pero los cables reales tienen
**R y C** parasitas que el esquematico ignoraba. Hay que extraerlas y
re-simular -> **Capirotada** (PEX).
