# La MinyPLD en el evento

Tarjeta de desarrollo con un CPLD **Altera/Intel MAX V 5M80Z** (80 logic
elements), usada como destino en hardware de la Cápsula 5 (FPGA/CPLD).

## Por qué la MinyPLD para esta demo

- El semáforo es chico y **cabe de sobra** en un CPLD pequeño: perfecto para
  mostrar "el mismo RTL corriendo en silicio real" sin una FPGA cara.
- Es reprogramable: el contraste exacto con el ASIC (permanente) que queremos
  enseñar.

## Límites a tener presentes

- **80 LE** es poco: mantén contadores chicos. Un divisor de reloj grande
  puede no caber; si tu tarjeta tiene reloj lento, úsalo y reduce el divisor.
- Revisa siempre el **reporte de utilización** del *fitter* tras compilar.

## Archivos relacionados

- RTL del top: `common/rtl/semaphore/rtl/top_minypld.v`
- Proyecto Quartus: `flows/fpga-minypld/quartus/`

> Pendiente por llenar con datos de TU tarjeta: OPN exacto, mapa de pines,
> frecuencia de reloj y foto del montaje. Súbelo aquí cuando lo tengas.
