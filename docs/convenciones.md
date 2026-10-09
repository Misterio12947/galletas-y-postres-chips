# Convenciones

## Nombres

- Archivos y módulos: `snake_case`, sin acentos ni espacios.
- Testbenches: `tb_<modulo>.v`. Tops de tarjeta: `top_<destino>.v`.
- Ramas: `demo/<nombre>-<etapa>` (ej. `demo/cesar-rtl`).

## RTL

- Verilog-2001/SystemVerilog sintetizable. Comentarios en español.
- Parametriza lo que cambie entre simulación y tarjeta (tiempos, anchos).
- Reset asíncrono activo en bajo (`rst_n`) salvo justificación.

## Testbench

- Autocomprobante: debe imprimir `>>> PASS` o `>>> FAIL`. El CI busca el PASS.
- Incluye al menos un *checker* (no solo volcar ondas).

## READMEs

- Uno corto por carpeta nueva: qué es, cómo correrlo, qué mostrar en vivo.

## No subir (NDA/licencias)

- PDKs de foundry, `.lib`/`.db`/`.lef` con licencia, binarios de EDA, logs con
  datos protegidos. PDK de referencia: **SKY130** (abierto).
