# Flujo open source

Demos open source por etapa, que consumen el diseno compartido de `common/`.
Cada etapa trae su `README.md`, sus scripts (`run_*.sh`) y, en `notebooks/`, un
notebook interactivo de Colab (autocontenido).

## Riel digital (RTL -> GDS firmado)

| Capsula | Carpeta | Herramientas | Que hace |
|---|---|---|---|
| Churros · RTL | `02-rtl/` | Yosys | ver el esquematico del RTL |
| Flan · Verif. funcional | `03-verif-funcional/` | Icarus + GTKWave | simular el testbench |
| Gelatina · Verif. formal | `04-verif-formal/` | SymbiYosys | probar propiedades |
| Polvorones · Sintesis | `06-sintesis/` | Yosys | RTL -> netlist de compuertas |
| Tres Leches · PnR | `07-pnr/` | OpenROAD + Magic | colocar, rutar, GDS |
| Cajeta · STA | `08-sta/` | OpenSTA | firmar el timing |

(La FPGA Mazapan va en `flows/fpga-minypld/`.)

## Riel analogico (esquematico -> silicio verificado)

Todas alrededor del mismo circuito: un **OTA de 5 transistores** en SKY130,
que vive en [`common/analog/ota5t/`](../../common/analog/ota5t/) y lo reusan
las 4 capsulas.

| Capsula | Carpeta | Herramientas | Que hace |
|---|---|---|---|
| Bunuelo · Esquematico | `09-esquematico/` | xschem | dibujar/netlistear el OTA |
| Arroz con Leche · Simulacion | `10-simulacion/` | ngspice | `.op` + Bode (`.ac`) + corners |
| Alfajor · Layout | `11-layout/` | KLayout + Magic | ver layout, DRC, LVS |
| Capirotada · PEX | `12-pex/` | Magic + ngspice | extraer R/C y re-simular |

### El circuito: OTA de 5T

Par diferencial NMOS (M3/M4) + espejo de carga PMOS (M5/M6) + fuente de cola
por espejo de corriente (M1/M2, bias por `IB`), mas dummies. Sobre SKY130
(`sky130_fd_pr__nfet_01v8` / `pfet_01v8`), ~228 um2. Resultados de referencia:
Av0 = 40.8 dB, GBW = 17.4 MHz, margen de fase = 82 grados (tipico, `tt`).

### Verificacion fisica (Alfajor + Capirotada)

- **DRC** (Alfajor): limpio -- 256 reglas, 0 violaciones.
- **LVS** (Alfajor): se muestra como **flujo** (como correrlo y leer el Netlist
  Browser). En esta celda standalone del curso no da MATCH tal cual por como
  quedaron los labels de alimentacion/bias repartidos en piezas (*must-connect*);
  ver la nota en `11-layout/README.md`.
- **PEX** (Capirotada): extraccion **solo-C** (nodos limpios) + re-simulacion.
  El OTA sigue cumpliendo con los parasitos (GBW baja ~2%: layout compacto,
  polo dominado por la carga externa). Ver `12-pex/README.md`.

> **Nota:** el riel analogico se entrega **solo open source**. El gemelo
> Synopsys (Custom Compiler / PrimeSim / StarRC) queda pendiente de montar.

## Notebooks (`notebooks/`)

Un notebook interactivo por capsula (p.ej. `esquematico_cookies.ipynb`,
`simulacion_cookies.ipynb`, `layout_cookies.ipynb`, `pex_cookies.ipynb`).
Son autocontenidos (datos embebidos) y corren en Colab solo con
`matplotlib` + `ipywidgets` (+ `networkx`/`pandas` segun el caso).
