# Estructura del repositorio

```
common/rtl/<bloque>/          Código fuente compartido (RTL + testbench)
flows/<flujo>/<NN-etapa>/     Scripts por herramienta que consumen common/
presentadores/<nombre>/       Material de cada expositor
docs/                         Convenciones, estructura, guía MinyPLD
```

## Flujos

| Carpeta | Herramientas típicas |
|---|---|
| `flows/opensource/` | Yosys, Icarus, Verilator, OpenROAD, Magic, Netgen, ngspice, SymbiYosys |
| `flows/synopsys/` | VCS, Design Compiler, PrimeTime, IC Validator, StarRC, PrimeSim |
| `flows/siemens/` | Questa, Oasys, Nitro, Calibre |
| `flows/fpga-minypld/` | Quartus (MAX V) |

## Etapas (igual que las cápsulas)

`01-pdk` · `02-rtl` · `03-verif-funcional` · `04-verif-formal` · `05-fpga`
· `06-sintesis` · `07-pnr` · `08-sta-signoff` · `09-12-analog`

**Empezamos por `02-rtl`.** Las demás carpetas se van llenando conforme cada
expositor sube su demo.

## Regla de oro

El **mismo** RTL/testbench se escribe una vez en `common/` y lo reusan todos
los flujos. Si te ves copiando RTL a una carpeta de flujo, deténte: va en
`common/` y el flujo solo lo referencia.
