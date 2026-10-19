# Cómo contribuir

¡Gracias por sumar tu demo, expositor! Esta guía mantiene el repo ordenado
para que 12 cápsulas × 2 rieles (digital y analógico) no se vuelvan un caos.

## Flujo de trabajo (Git)

1. **Clona** y crea una rama con tu nombre y etapa:
   ```bash
   git clone https://github.com/<ORG-O-USUARIO>/galletas-y-postres-chips.git
   git checkout -b demo/<tu-nombre>-<etapa>     # ej. demo/cesar-rtl
   ```
2. Coloca tus archivos en la carpeta correcta (ver abajo).
3. Haz commit y push, y **abre un Pull Request** a `main`.
4. El CI corre *lint* + simulación del RTL. Cuando pase y haya una revisión, se mergea.

> Rama protegida: `main` no acepta push directo; todo entra por PR.

## ¿Dónde va mi archivo?

- **¿Es el diseño fuente compartido?** → `common/`.
  - **Digital** (RTL o testbench) → `common/rtl/<bloque>/`.
  - **Analógico** (esquemático `.sch`/`.sym`, netlist SPICE, GDS) →
    `common/analog/<bloque>/`.

  En ambos casos es agnóstico a la herramienta: lo reusan **todos** los flujos
  y etapas. Si te ves copiando el diseño a una carpeta de flujo, deténte: va en
  `common/` y el flujo solo lo referencia.
- **¿Es un script de una herramienta** (Makefile, `.tcl`, `.ys`, `.sdc`,
  `.qsf`, `run_*.sh`)? → `flows/<flujo>/<NN-etapa>/`.
  - `flows/opensource/` · `flows/synopsys/` · `flows/siemens/` · `flows/fpga-minypld/`
- **¿Es un notebook interactivo** de una cápsula? → `flows/<flujo>/notebooks/`.
- **¿Es material tuyo de expositor** (notas, diapositivas, imágenes)? →
  `presentadores/<tu-nombre>/` (copia `presentadores/PLANTILLA/`).

## Convenciones

- Nombres de archivos y módulos en `snake_case`, sin acentos ni espacios.
- **Evita palabras reservadas** de Verilog/SystemVerilog en nombres de módulo
  (p. ej. `semaphore` es reservada → usamos `semaforo`). Mantén las fuentes
  Verilog en ASCII.
- Un `README.md` corto por carpeta nueva: qué es, cómo correrlo, qué mostrar.
- Comentarios en español; que el código se explique solo.
- Mantén los ejemplos guía como referencia de estilo: el **semáforo**
  (`common/rtl/semaphore/`) en digital y el **OTA de 5T**
  (`common/analog/ota5t/`) en analógico.
- Los artefactos generados (netlists, GDS de salida, logs, reportes, `results/`)
  **no se versionan**: van en `.gitignore`. Versiona scripts y fuentes, no
  salidas.

## Qué NO subir (NDA / licencias)

Prohibido por licencia o NDA:

- PDKs de *foundry* (TSMC, GF, etc.), modelos SPICE propietarios.
- Librerías `.lib`/`.db`/`.lef` con licencia; binarios de EDA comercial.
- Reportes o logs que revelen datos protegidos.

Usa **SKY130** (abierto) como PDK de referencia. Si dudas, pregunta antes de
hacer commit. El `.gitignore` ya bloquea muchos de estos, pero la
responsabilidad final es de quien sube.

## Checklist del PR

- [ ] Mi demo corre localmente (el RTL compila / el testbench o la simulación corre).
- [ ] Agregué un `README.md` en la carpeta nueva.
- [ ] El diseño fuente va en `common/`; el flujo solo lo referencia.
- [ ] No incluí nada bajo NDA, binarios pesados ni artefactos generados.
- [ ] El CI está en verde.
