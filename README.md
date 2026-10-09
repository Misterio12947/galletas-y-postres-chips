# 🍮 Galletas y Postres: El camino de diseñar chips

Repositorio de demos del evento. Aquí los **expositores y colaboradores**
suben el código y los archivos de cada etapa del flujo de diseño VLSI, para
los **dos mundos**: open source y comercial (**Synopsys / Siemens**), más la
implementación en la tarjeta **MinyPLD** (Altera/Intel MAX V).

> Idea rectora: **un mismo RTL, muchos flujos.** El código fuente (RTL y
> testbenches) vive una sola vez en `common/`; cada flujo aporta solo sus
> *scripts* para consumir ese mismo código.

## Estructura

```
common/                  Código fuente compartido (RTL, testbenches)
  rtl/semaphore/         ← ejemplo guía: el semáforo (empezamos aquí)
flows/
  opensource/            Yosys, Icarus, OpenROAD, Magic, ngspice...
  synopsys/              Design Compiler, VCS, PrimeTime, IC Validator...
  siemens/               Questa, Oasys, Calibre...
  fpga-minypld/          Quartus para la MinyPLD (MAX V)
docs/                    Convenciones, estructura y guía de la MinyPLD
presentadores/           Una carpeta por expositor (usa la PLANTILLA)
```

Las etapas se numeran igual que las cápsulas del evento:
`01-pdk`, `02-rtl`, `03-verif-funcional`, `04-verif-formal`, `05-fpga`,
`06-sintesis`, `07-pnr`, `08-sta-signoff`, `09-12-analog`.
**Arrancamos por `02-rtl`.**

## Arranque rápido (open source)

```bash
# Simular el semáforo (Cápsula 3 · Verificación funcional)
cd flows/opensource/03-verif-funcional
make            # compila + corre el testbench, imprime PASS/FAIL
make wave       # abre la onda en GTKWave
```

## Cómo contribuir

Lee **[CONTRIBUTING.md](CONTRIBUTING.md)**. En corto: haz una rama, sube tu
demo en la carpeta de su etapa/flujo, y abre un Pull Request. El CI corre el
*lint* y la simulación del RTL automáticamente.

## ⚠️ Importante: nada bajo NDA

**No subas** PDKs de *foundry*, librerías con licencia, binarios de
herramientas comerciales ni reportes que contengan datos protegidos por NDA.
Este repo guarda **código propio y scripts**; el PDK abierto de referencia es
**SKY130**. Ver la lista en `.gitignore` y en CONTRIBUTING.

## Licencia

Código bajo [MIT](LICENSE). Documentación y materiales del evento:
libres de reutilizar citando la fuente.
