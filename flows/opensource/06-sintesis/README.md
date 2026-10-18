
# Sintesis ASIC (open source) - Yosys + SKY130

Demo de la **Capsula 6 (Polvorones)** en linea de comandos. Toma el RTL del
`semaforo` (el *que*) y lo convierte en un **netlist de compuertas** (el *con
que*), mapeando a **celdas estandar reales de SKY130**. Luego reporta cuantas
celdas uso (las **polvorones**) y cuanta **area**.

Es el gemelo open source del lado Synopsys (Design Compiler, en
`flows/synopsys/06-sintesis/`). **Mismo RTL, misma liberty, dos sintetizadores**
-> se pueden comparar los numeros.

## Requisitos

- `yosys`
- La liberty de SKY130 HD: `sky130_fd_sc_hd__tt_025C_1v80.lib`.
  Se obtiene con el PDK:

  ```bash
  pip install volare
  export PDK_ROOT=$HOME/pdk
  volare enable --pdk sky130 $(volare ls-remote --pdk sky130 | head -1)
  ```

  (o ya la tienes dentro de `oss-cad-suite`). Ajusta `PDK_ROOT`/`LIB` en el
  `Makefile` a tu ruta real.

## Correr

```bash
make synth            # celdas + area (el reporte 'stat' de Yosys)
make netlist          # ademas escribe el netlist de compuertas -> netlist.v
make synth CW=16      # sube el ancho del contador: mas FFs, mas area
make clean
```

## Que mostrar en vivo

1. `make synth` -> al final, el bloque `stat` lista **cuantas celdas de cada
   tipo** (inversores, NANDs, flip-flops...) y el **area** total. Esas son las
   polvorones: celdas del mismo molde, repetidas.
2. `make netlist` + `head netlist.v` -> el RTL ahora es una **lista de
   instancias de celdas SKY130** conectadas. Dejo de ser comportamiento, ahora
   son compuertas.
3. `make synth CW=16` -> mas bits de contador = mas flip-flops = mas area. Se
   siente la "A" del PPA.

## Como funciona (el script de Yosys)

```
read_verilog semaphore.v     ; lee el RTL
chparam -set CW <n> semaforo ; fija el ancho del contador
synth -top semaforo -flatten ; sintesis generica (logica + registros)
dfflibmap -liberty <lib>     ; mapea los flip-flops a celdas reales
abc      -liberty <lib>      ; mapea la logica combinacional a celdas reales
opt_clean                    ; limpia lo que sobro
stat     -liberty <lib>      ; cuenta celdas y area
```

## Callback: equivalence checking

La sintesis **reorganiza y optimiza** todo, pero el netlist debe hacer
*exactamente* lo mismo que el RTL. Eso se **demuestra** (no se simula) con
**equivalence checking**: open source con `eqy` (Yosys), en Synopsys con
`Formality`. Es el mismo motor formal de la **Gelatina** (Capsula 4), ahora
comparando **RTL vs netlist**.

> La version interactiva (grafica de celdas + slider de CW) esta en el notebook
> `flows/opensource/notebooks/` (Polvorones).
