# Ejemplo guía — Semáforo (traffic light FSM)

Este es el circuito que recorre **todas** las cápsulas del evento. La idea
central: **un mismo RTL** alimenta el flujo open source, el flujo
Synopsys/Siemens y la implementación física en la **MinyPLD**.

## Archivos

| Archivo | Qué es |
|---|---|
| `rtl/semaphore.v` | La FSM del semáforo (verde → amarillo → rojo). RTL sintetizable. |
| `rtl/clk_divider.v` | Divisor de reloj para que los LEDs se vean en la tarjeta (solo HW). |
| `rtl/top_minypld.v` | Top para la MinyPLD: conecta divisor + semáforo a los pines. |
| `tb/tb_semaphore.v` | Testbench autocomprobante (Cápsula 3). Checker: 1 luz a la vez. |

## Parámetros

- `T_GREEN`, `T_YELLOW`, `T_RED` — duración de cada estado en *ticks*.
- `CW` — ancho del contador. **Ojo:** el MAX V 5M80Z tiene solo **80 LE**;
  mantén los contadores chicos (ver `docs/minypld/`).

## Cómo se usa en cada flujo

- **Open source:** `flows/opensource/03-verif-funcional` (Icarus + GTKWave).
- **Synopsys:** `flows/synopsys/02-rtl` (lectura en Design Compiler / VCS).
- **Siemens:** `flows/siemens/02-rtl` (lectura en Questa).
- **MinyPLD:** `flows/fpga-minypld/quartus` (síntesis + bitstream).
