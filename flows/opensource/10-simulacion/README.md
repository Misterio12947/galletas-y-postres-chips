# Simulacion (open source) - ngspice

Demo de la **Capsula 10 (Arroz con Leche)**: **cocinar** el OTA. Aqui no hay 0s
y 1s -- ngspice resuelve la **fisica** de cada transistor con los modelos reales
de SKY130 y dice si el amplificador **sirve**.

Reusa el OTA de [`common/analog/ota5t/`](../../../common/analog/ota5t/) (lo
mismo que netlisteamos en Bunuelo).

## Requisitos

- **ngspice** en el PATH.
- El PDK **SKY130** con los modelos combinados
  (`$PDK_ROOT/sky130A/libs.tech/combined/sky130.lib.spice`). `run_sim.sh` lo
  autodetecta en `/foss/pdks`, `$PDK_ROOT`, `~/.volare` o `~/.ciel`.

## Correr

```bash
cd flows/opensource/10-simulacion

./run_sim.sh op          # punto de operacion: gm, Id, Vds de M3-M6
./run_sim.sh ac          # respuesta en frecuencia (Bode) -> results/bode_tt.png
./run_sim.sh ac ss       # el mismo Bode en el corner lento (process corner)
./run_sim.sh ac ff       # en el corner rapido
```

`run_sim.sh` rellena la plantilla del deck (`decks/*.spice.in`) con el PDK y el
**corner**, corre ngspice en modo batch (`-b`) y deja todo en `results/`.

## Que miden las dos pruebas

### `op` - punto de operacion (`decks/ota_op.spice.in`)
Bias: `VDD=1.8 V`, entradas a `0.9 V`, `IB=12 uA`. Imprime `Id`, `gm`, `Vds` y
`Vdsat` de los 4 transistores del core. **Que revisar en vivo:**
- Todos en **saturacion**: `|Vds| > |Vdsat|` (si no, el OTA no amplifica).
- **Matching**: M3 =~ M4 y M5 =~ M6 (mismo Id/gm). Si no, hay offset.

### `ac` - respuesta en frecuencia (`decks/ota_ac.spice.in`)
Estimulo **diferencial** (+-0.5 AC) alrededor de 0.9 V, carga `CL=1 pF`. Barre
`ac dec 100 1 1G` y vuelca el Bode a `results/bode.txt`. Luego `plot_bode.py`
dibuja ganancia y fase y reporta:
- **Av0** -- ganancia DC (dB)
- **GBW** -- frecuencia donde la ganancia cruza 0 dB
- **Margen de fase** -- estabilidad (sano si > 45-60 grados)

## Corners (PVT)

El mismo deck, otra libreria de modelos. Cambia el **corner** (segundo
argumento): `tt` (tipico), `ss` (lento), `ff` (rapido), `sf`, `fs`. El diseno
es bueno solo si cumple **en todos**, no solo en `tt`. Compara los
`results/bode_<corner>.png`.

## Ver el esquematico del testbench (opcional, GUI)

Los testbenches originales del curso estan como `.sch` de xschem:

```bash
xschem OTA_tb.sch         # el de punto de operacion (.op con lecturas gm/id)
xschem OTA_5T_ac_tb.sch   # el de AC (grafica el Bode dentro de xschem)
```

> Lanzalos desde una **terminal** (no doble clic), igual que en Bunuelo.

## Que mostrar en vivo

1. `./run_sim.sh op`: senalar que todo esta en saturacion y que M3=~M4, M5=~M6.
2. `./run_sim.sh ac`: abrir `results/bode_tt.png` -> leer Av0, GBW y margen de fase.
3. `./run_sim.sh ac ss` y comparar: en el corner lento baja la ganancia / el GBW.

## Callback / relevo

El OTA **amplifica, es estable y aguanta corners**. Pero sigue siendo
esquematico. Falta dibujarlo capa por capa -> 🍰 **Alfajor** (layout).
