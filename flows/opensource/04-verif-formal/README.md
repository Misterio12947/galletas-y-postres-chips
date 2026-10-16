# Verificacion formal (open source) - SymbiYosys

Demo de la Capsula 4 (Gelatina) en linea de comandos. Demuestra la propiedad
**"nunca hay dos luces encendidas a la vez"** para todos los casos (hasta la
profundidad del BMC), y con el bug entrega el **contraejemplo**.

Es el gemelo open source del lado Synopsys (VC Formal, en `flows/synopsys/04-verif-formal/`).

## Requisitos

`sby` (SymbiYosys) + `yosys` + un solver SMT (yices / boolector / z3).
Lo mas facil es instalar **oss-cad-suite** (trae todo) y agregarlo al PATH:

```bash
# descarga el tarball linux-x64 de:
#   https://github.com/YosysHQ/oss-cad-suite-build/releases
tar xf oss-cad-suite-linux-x64-*.tgz
export PATH=$PWD/oss-cad-suite/bin:$PATH
sby --version    # verifica
```

## Correr

```bash
make            # demuestra la propiedad -> "PASS"
make bug        # corre con el bug       -> "FAIL" + contraejemplo
make wave       # ver el contraejemplo del bug en GTKWave
make clean      # limpiar
```

## Como funciona

- `formal_top.v` es un **envoltorio** que instancia el semaforo y le agrega la
  propiedad (`assert`) y una **secuencia de reset** para que el analisis parta
  de un estado valido. No se toca el RTL del repo.
- `prueba.sby` lee el RTL correcto (`common/rtl/semaphore/rtl/semaphore.v`) +
  el envoltorio, con `prep -top formal_top`.
- `bug.sby` usa `semaforo_bug.v` (en amarillo enciende tambien el verde) para
  mostrar el contraejemplo.

## Que mostrar en vivo

1. `make` -> SymbiYosys imprime **PASS**: la propiedad se cumple para todos los
   casos, sin testbench.
2. `make bug` -> **FAIL** y la ruta al contraejemplo (`bug/engine_0/trace.vcd`).
3. `make wave` -> en GTKWave se ve el instante exacto: verde y amarillo
   encendidos juntos. El formal no solo dice *que* falla, dice *como* fallar.
