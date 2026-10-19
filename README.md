# Galletas y Postres: El camino de diseñar chips

Repositorio de demos del evento. Aquí los **expositores y colaboradores**
suben el código y los archivos de cada etapa del flujo de diseño VLSI, para
los **dos mundos**: open source y comercial (**Synopsys / Siemens**), más la
implementación en la tarjeta **MinyPLD** (Altera/Intel MAX V).

El flujo recorre **dos rieles** de punta a punta:

- **Digital** — del RTL al GDS con el timing firmado.
- **Analógico** — del esquemático al silicio verificado (DRC/LVS/PEX).

> Idea rectora: **un mismo diseño, muchos flujos.** El diseño vive una sola vez
> en `common/`; cada flujo aporta solo sus *scripts* para consumir ese mismo
> diseño.

## Estructura

```
common/                  Diseño compartido (se escribe una vez, lo reusan todos)
  rtl/semaphore/         ← ejemplo digital: el semáforo (RTL + testbench)
  analog/ota5t/          ← ejemplo analógico: un OTA de 5T (sch, netlist, GDS)
flows/
  opensource/            Yosys, Icarus, OpenROAD, Magic, KLayout, ngspice, xschem...
    NN-etapa/            Scripts + README por cápsula
    notebooks/           Notebooks interactivos (Colab), uno por cápsula
  synopsys/              Design Compiler, VCS, PrimeTime, IC Compiler II, IC Validator...
  siemens/               Questa, Oasys, Calibre...
  fpga-minypld/          Quartus para la MinyPLD (MAX V)
docs/                    Convenciones, estructura y guía de la MinyPLD
presentadores/           Una carpeta por expositor (usa la PLANTILLA)
```

Las etapas se numeran igual que las cápsulas del evento:

- **Riel digital:** `02-rtl`, `03-verif-funcional`, `04-verif-formal`,
  `06-sintesis`, `07-pnr`, `08-sta`.
- **Riel analógico:** `09-esquematico`, `10-simulacion`, `11-layout`, `12-pex`.
- **FPGA:** en `flows/fpga-minypld/`.

El flujo **open source** está completo (digital + analógico), cada cápsula con
sus slides, su demo corrible y su notebook. Ver
[`flows/opensource/README.md`](flows/opensource/README.md) para el mapa.

## Arranque rápido

```bash
# Digital — simular el semáforo (Cápsula 3 · Verificación funcional)
cd flows/opensource/03-verif-funcional
make            # compila + corre el testbench, imprime PASS/FAIL
make wave       # abre la onda en GTKWave

# Analógico — abrir el OTA en xschem (Cápsula 9 · Esquemático)
cd flows/opensource/09-esquematico
./abrir_xschem.sh
```

## Cómo contribuir

Lee **[CONTRIBUTING.md](CONTRIBUTING.md)**. En corto: haz una rama, sube tu
demo en la carpeta de su etapa/flujo, y abre un Pull Request. El CI corre el
*lint* y la simulación del RTL automáticamente.

## Importante: nada bajo NDA

**No subas** PDKs de *foundry*, librerías con licencia, binarios de
herramientas comerciales ni reportes que contengan datos protegidos por NDA.
Este repo guarda **código propio y scripts**; el PDK abierto de referencia es
**SKY130**. Ver la lista en `.gitignore` y en CONTRIBUTING.

## Licencia

Código bajo [MIT](LICENSE). Documentación y materiales del evento:
libres de reutilizar citando la fuente.
