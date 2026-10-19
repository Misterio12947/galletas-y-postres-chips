# Estructura del repositorio

```
common/rtl/<bloque>/          Fuentes digitales compartidas (RTL + testbench)
common/analog/<bloque>/       Fuentes analogicas compartidas (esquematico, simbolo,
                              netlist SPICE, GDS) -- p.ej. common/analog/ota5t/
flows/<flujo>/<NN-etapa>/     Scripts por herramienta que consumen common/
flows/<flujo>/notebooks/      Notebooks interactivos (Colab) por etapa
presentadores/<nombre>/       Material de cada expositor
docs/                         Convenciones, estructura, guia MinyPLD
```

## Flujos

| Carpeta | Herramientas tipicas |
|---|---|
| `flows/opensource/` | Yosys, Icarus, Verilator, OpenROAD, Magic, KLayout, Netgen, ngspice, xschem, SymbiYosys |
| `flows/synopsys/` | VCS, Design Compiler, PrimeTime, IC Compiler II, IC Validator, StarRC, PrimeSim |
| `flows/siemens/` | Questa, Oasys, Nitro, Calibre |
| `flows/fpga-minypld/` | Quartus (MAX V) |

## Etapas (igual que las capsulas)

**Riel digital** (RTL -> GDS firmado):
`02-rtl` · `03-verif-funcional` · `04-verif-formal` · `06-sintesis` ·
`07-pnr` · `08-sta`

**Riel analogico** (esquematico -> silicio verificado):
`09-esquematico` · `10-simulacion` · `11-layout` · `12-pex`

(La FPGA va aparte, en `flows/fpga-minypld/`.)

## Regla de oro

El **mismo** diseno se escribe una vez en `common/` y lo reusan todos los
flujos y etapas:

- **Digital:** el RTL/testbench vive en `common/rtl/<bloque>/`.
- **Analogico:** el esquematico/simbolo/netlist/GDS viven en
  `common/analog/<bloque>/` (p.ej. el OTA de 5T en `common/analog/ota5t/`, que
  reusan las 4 capsulas analogicas: esquematico -> sim -> layout -> PEX).

Si te ves copiando un diseno a una carpeta de flujo, detente: va en `common/`
y el flujo solo lo referencia.
