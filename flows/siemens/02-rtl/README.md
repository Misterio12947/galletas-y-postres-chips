# RTL (Siemens) — Cápsula 2 · Churros

Scripts para el **mismo** RTL (`common/rtl/semaphore/`) en el flujo Siemens
(Questa). **No subas** binarios ni librerías con licencia (ver CONTRIBUTING).

## Questa — simulación funcional (Cápsula 3)

`run_questa.do` (plantilla):

```tcl
vlib work
vlog -sv ../../../common/rtl/semaphore/rtl/semaphore.v \
         ../../../common/rtl/semaphore/tb/tb_semaphore.v
vsim -c tb_semaphore -do "run -all; quit"
# Modo gráfico para ver ondas:
# vsim tb_semaphore -do "add wave -r /*; run -all"
```

Correr en consola:

```bash
vsim -c -do run_questa.do
```

> Plantilla de referencia; ajústala a tu instalación de Questa en el
> laboratorio.
