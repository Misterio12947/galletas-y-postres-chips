# RTL (Synopsys) — Cápsula 2 · Churros

Scripts para leer/elaborar el **mismo** RTL (`common/rtl/semaphore/`) en el
flujo Synopsys. **No subas** binarios, librerías con licencia ni logs con
datos protegidos (ver CONTRIBUTING).

## VCS — simulación funcional (Cápsula 3)

`run_vcs.sh` (plantilla, ajústalo a tu instalación):

```bash
vcs -full64 -sverilog -debug_access+all \
    ../../../common/rtl/semaphore/rtl/semaphore.v \
    ../../../common/rtl/semaphore/tb/tb_semaphore.v \
    -o simv
./simv
# Onda en Verdi:
# verdi -ssf dump.fsdb &
```

## Design Compiler — lectura/elaboración (Cápsula 6)

`read.tcl` (plantilla):

```tcl
# Requiere un .lib del PDK ya configurado en target_library (NO se versiona)
read_verilog ../../../common/rtl/semaphore/rtl/semaphore.v
current_design semaphore
link
check_design
# La síntesis completa va en flows/synopsys/06-sintesis/
```

> Estas son plantillas de referencia; cámbialas a los nombres y rutas de tu
> entorno (GCP / Rocky del laboratorio).
