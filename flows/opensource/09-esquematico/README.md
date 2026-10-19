# Esquematico (open source) - xschem

Demo de la **Capsula 9 (Bunuelo)**: el arranque del **riel analogico**. Aqui no
hay RTL ni sintesis -- el circuito se **dibuja a mano**, transistor por
transistor, y se describe con un **netlist SPICE** (no Verilog).

Circuito de ejemplo para todo el riel analogico: un **OTA de 5 transistores**
(Operational Transconductance Amplifier) sobre SKY130.

El diseno compartido vive en [`common/analog/ota5t/`](../../../common/analog/ota5t/)
y lo reusan las cuatro capsulas analogicas (esquematico -> sim -> layout -> PEX).

## Requisitos

- **xschem** en el PATH, configurado con la libreria xschem de SKY130
  (`sky130_fd_pr`, via `XSCHEM_LIBRARY_PATH`).
- El PDK **SKY130** (los simbolos `nfet_01v8`/`pfet_01v8` se resuelven de ahi).

## Correr

```bash
cd flows/opensource/09-esquematico
./run_netlist.sh        # netlistea el .sch -> results/OTA_5T.spice
```

Para **dibujar / ver** el esquematico en la GUI:

```bash
cd flows/opensource/09-esquematico
./abrir_xschem.sh      # entra al dir del diseno y abre xschem
```

>  **Lanza xschem desde una terminal**, no con doble clic en el gestor de
> archivos: asi conserva su terminal y, si algo falla al arrancar, ves el error
> en vez de que la ventana "parpadee y se cierre". El wrapper ya hace el `cd` al
> directorio del diseno, donde xschem resuelve mejor la libreria de SKY130.

## El circuito: OTA de 5T (con polarizacion por corriente)

Puertos: `VIN` (alimentacion), `VSS` (tierra), `VINP`/`VINN` (entradas
diferenciales), `IB` (corriente de polarizacion de entrada), `VOUT_AMP` (salida).

| Bloque | Transistores | Que hace |
|---|---|---|
| Par diferencial (NMOS) | M3, M4 | comparan `VINP` contra `VINN` |
| Espejo de carga (PMOS) | M5, M6 | carga activa; convierte la diferencia en voltaje de salida |
| Fuente de cola (NMOS) | M2 | fija la corriente de polarizacion del par |
| Espejo de bias (NMOS) | M1, M2 | copian `IB` hacia la cola |
| Dummies | M7, M8 | ajuste/decoupling (L minimo) |

Tamanos del core: `L=1 um`, `W=2.5-6 um`, multiplicador `m=4`. El `L` grande da
mas ganancia (menos efecto de canal corto); el disenador elige estos tamanos a
mano -- ahi esta el "diseno" analogico.

## Que hace `run_netlist.sh`

```
xschem -n -s -q -b -o results OTA_5T.sch   ; netlistea en modo batch
# -> results/OTA_5T.spice : cada transistor = una linea
#    (nodos conectados + modelo del PDK + W/L/m)
```

El netlist resultante es identico al de referencia en `common/analog/ota5t/`.
Esa es la **salida** de esta capsula y la **entrada** de la siguiente.

## Que mostrar en vivo

1. Abrir el `.sch` en xschem: los 3 bloques (par diferencial, espejo, cola).
2. Generar el netlist y abrir el `.spice`: senalar que **cada FET es una linea**
   con sus nodos, su modelo (`sky130_fd_pr__nfet_01v8`) y sus `W/L/m`.
3. El puente: este netlist es lo que simulara **Arroz con Leche** (ngspice).

## Gemelo comercial

El equivalente Synopsys es **Custom Compiler** (editor de esquematicos GUI):
se instancian los `nfet`/`pfet` del PDK, se conectan y se exporta un netlist
CDL/SPICE que luego consume **PrimeSim**. Mismo circuito, misma salida.

## Callback / relevo

Con el OTA **dibujado y netlisteado**, falta probarlo: ganancia, barridos y
corners. Eso es **Arroz con Leche** (simulacion).

