# RTL (open source) — Cápsula 2 · Churros

El RTL vive en `common/rtl/semaphore/`. Esta carpeta es para *scripts* open
source que operan sobre ese RTL sin sintetizar aún (p. ej. ver el esquemático
elaborado).

## Demo rápida: ver el RTL elaborado en Yosys

```bash
yosys -p "read_verilog ../../../common/rtl/semaphore/rtl/semaphore.v; \
          proc; opt; show -format svg -prefix semaphore_rtl"
```

Genera `semaphore_rtl.svg`: muxes y flip-flops, **todavía sin celdas del
PDK**. Ese es el mensaje de la cápsula: describimos el *qué*, no el *cómo*.
