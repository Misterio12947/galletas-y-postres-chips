# La MinyPLD en el evento

Tarjeta de desarrollo con un CPLD **Altera/Intel MAX V 5M80Z** (80 logic
elements), usada como destino en hardware de la Cápsula 5 (FPGA/CPLD).

## Por qué la MinyPLD para esta demo

- El semáforo es chico y **cabe de sobra** en un CPLD pequeño: perfecto para
  mostrar "el mismo RTL corriendo en silicio real" sin una FPGA cara.
- Es reprogramable: el contraste exacto con el ASIC (permanente) que queremos
  enseñar.

## Datos de esta tarjeta

| Parámetro | Valor |
|---|---|
| Dispositivo (OPN) | `5M80ZE64C5` (MAX V, 64 pines, 80 LE) |
| Reloj | oscilador de **25 MHz** en `PIN_7` |
| Reset | `PIN_21` (push-button, activo en bajo) |
| LED rojo / amarillo / verde | `PIN_62` / `PIN_63` / `PIN_64` |
| I/O standard | 3.3-V LVTTL |

Con el divisor a `DIV=12.5M` / `CW=24`, el `slow_clk` queda en **1 Hz**
(verde 5 s → amarillo 2 s → rojo 5 s). El detalle completo del proyecto está
en [`flows/fpga-minypld/quartus/README.md`](../../flows/fpga-minypld/quartus/README.md).

## Límites a tener presentes

- **80 LE** es poco: mantén contadores chicos. El divisor de 24 bits + el FSM
  del semáforo entran con margen; un divisor más ancho puede no caber. Si tu
  tarjeta tiene un reloj ya lento, úsalo y reduce el divisor.
- Revisa siempre el **reporte de utilización** del *fitter* tras compilar.
- En MAX V, un reloj dividido generado en lógica (como `slow_clk`) deja un
  warning benigno de "clock unconstrained" en el Timing Analyzer; no afecta el
  diseño (ese dominio corre a 1 Hz). El signoff que importa es el del reloj de
  entrada (25 MHz), que cierra.

## Archivos relacionados

- RTL del top: `common/rtl/semaphore/rtl/top_minypld.v`
- Proyecto Quartus: `flows/fpga-minypld/quartus/`

> Pendiente: subir una **foto del montaje** de la tarjeta programada con el
> semáforo corriendo.