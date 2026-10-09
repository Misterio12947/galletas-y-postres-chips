# Cómo contribuir

¡Gracias por sumar tu demo, expositor! Esta guía mantiene el repo ordenado
para que 12 cápsulas × 2 flujos no se vuelvan un caos.

## Flujo de trabajo (Git)

1. **Clona** y crea una rama con tu nombre y etapa:
   ```bash
   git clone https://github.com/<ORG-O-USUARIO>/galletas-y-postres-chips.git
   git checkout -b demo/<tu-nombre>-<etapa>     # ej. demo/cesar-rtl
   ```
2. Coloca tus archivos en la carpeta correcta (ver abajo).
3. Haz commit y push, y **abre un Pull Request** a `main`.
4. El CI corre *lint* + simulación. Cuando pase y haya una revisión, se mergea.

> Rama protegida: `main` no acepta push directo; todo entra por PR.

## ¿Dónde va mi archivo?

- **¿Es código fuente RTL o un testbench?** → `common/rtl/<bloque>/`.
  Es agnóstico a la herramienta: lo reusan todos los flujos.
- **¿Es un script de una herramienta** (Makefile, `.tcl`, `.ys`, `.sdc`,
  `.qsf`)? → `flows/<flujo>/<NN-etapa>/`.
  - `flows/opensource/` · `flows/synopsys/` · `flows/siemens/` · `flows/fpga-minypld/`
- **¿Es material tuyo de expositor** (notas, diapositivas, imágenes)? →
  `presentadores/<tu-nombre>/` (copia `presentadores/PLANTILLA/`).

## Convenciones

- Nombres de archivos y módulos en `snake_case`, sin acentos ni espacios.
- Un `README.md` corto por carpeta nueva: qué es, cómo correrlo, qué mostrar.
- Comentarios en español; que el código se explique solo.
- Mantén el ejemplo guía (semáforo) como referencia de estilo.

## ⚠️ Qué NO subir (NDA / licencias)

Prohibido por licencia o NDA:

- PDKs de *foundry* (TSMC, GF, etc.), modelos SPICE propietarios.
- Librerías `.lib`/`.db`/`.lef` con licencia; binarios de EDA comercial.
- Reportes o logs que revelen datos protegidos.

Usa **SKY130** (abierto) como PDK de referencia. Si dudas, pregunta antes de
hacer commit. El `.gitignore` ya bloquea muchos de estos, pero la
responsabilidad final es de quien sube.

## Checklist del PR

- [ ] Mi RTL compila / mi testbench corre localmente.
- [ ] Agregué un `README.md` en la carpeta nueva.
- [ ] No incluí nada bajo NDA ni binarios pesados.
- [ ] El CI está en verde.
