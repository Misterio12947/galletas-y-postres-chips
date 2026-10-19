# PEX (open source) - Magic + ngspice

Demo de la **Capsula 12 (Capirotada)**: el **signoff analogico**. El layout
tiene cables con **resistencia (R)** y **capacitancia (C)** que el esquematico
ignoraba. PEX (Parasitic Extraction) las saca del layout y **re-simulamos** para
ver si el OTA **sigue cumpliendo** con esos parasitos encima.

Reusa el layout de [`common/analog/ota5t/`](../../../common/analog/ota5t/)
(Alfajor) y el testbench AC de [Arroz con Leche](../10-simulacion/).

## Requisitos

- **Magic** (extraccion) y **ngspice** (re-simulacion) en el PATH.
- El PDK **SKY130** (los scripts autodetectan `PDK_ROOT`: `/foss/pdks`,
  `$PDK_ROOT`, `~/.volare` o `~/.ciel`).

## Correr

```bash
cd flows/opensource/12-pex

# 1) extraer R/C del layout -> results/OTA_5T_pex.spice
./run_pex.sh

# 2) re-simular con parasitos y comparar vs el ideal
./run_resim_pex.sh ac
```

> Para la comparacion, primero corre el Bode **ideal** en Arroz con Leche:
> `(cd ../10-simulacion && ./run_sim.sh ac)` -> deja `results/bode_tt.txt`.

## Que hace cada paso

### `run_pex.sh` - extraccion (Magic), basado en el del curso
Con Magic, extraccion **solo-C** (capacitancias de acople):
```
gds read OTA_5T.gds ; extract all
ext2spice cthresh 0.01              ; C entre conductores
ext2spice subcircuit top on -o OTA_5T_pex.spice
```
Luego promueve los nodos a **puertos** del subckt (Magic emite `.subckt OTA_5T`
sin puertos): inyecta el orden "golden" del netlist LVS **+ el nodo de sustrato**
(`VSUBS`). Sale un `.subckt OTA_5T VIN VOUT_AMP VINN VINP IB VSS VSUBS` con los
transistores **+ C** parasitas.

> **¿Por que solo-C?** Con `extresist` (R), Magic parte cada net en sub-nodos
> (`VIN_uq0`, `IB_uq0.t0`...) y re-simular una celda **standalone** se vuelve muy
> fragil (nodos de compuerta sin camino DC, sustrato suelto, puertos sin
> promover -- el mismo origen que el mismatch de LVS). La extraccion solo-C deja
> los nodos **limpios** y la **C es la que domina** la caida de ancho de banda;
> la R de estos cables cortos es despreciable. Es una simplificacion didactica
> honesta, no un signoff industrial.

### `run_resim_pex.sh` - re-simulacion (ngspice)
Lee los **puertos reales** del subckt PEX y arma la instancia mapeando cada uno
a su nodo del testbench (VIN->VDD, VOUT_AMP->VOUT, VSS->0, **VSUBS->0**, ...).
Reusa el testbench AC de Arroz con Leche (VDD=1.8, estimulo diferencial, CL=1pF)
con `.option rshunt=1e12` (camino DC para nodos solo-capacitivos), corre
`ac dec 100 1 1G` y vuelca `results/bode_pex.txt`. Luego `plot_pex_compare.py`
grafica **ideal vs con parasitos** y reporta Av0, GBW y margen de fase, y
**cuanto cambia el GBW**.

## Que esperar / que mostrar en vivo

- La **ganancia DC (Av0)** casi no cambia.
- El **ancho de banda (GBW) baja**: la C extra en la salida acerca el polo
  dominante. El margen de fase tambien baja un poco.
- La pregunta de signoff: **¿aun cumple?** Si si -> el diseno es **robusto** y
  esta listo para fabricar.

## Signoff analogico completo

| Check | Capsula | Que garantiza |
|---|---|---|
| DRC | Alfajor | respeta las reglas del fab |
| LVS | Alfajor | el layout es el circuito correcto |
| PEX + re-sim | **aqui** | cumple con los parasitos reales |

Las tres = permiso para fabricar. Es el equivalente analogico del **timing
signoff** (Cajeta) en el digital.

## Callback / cierre

Con el PEX cerramos el **riel analogico** -- y con el, **todo el camino**: del
RTL al GDS firmado (digital) y del esquematico al silicio verificado (analogico).
Eso es disenar un chip. 
