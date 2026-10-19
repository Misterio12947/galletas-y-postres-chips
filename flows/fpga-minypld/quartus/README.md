# MinyPLD — Quartus (Cápsula 5 · Mazapán)

Implementa el semáforo en la tarjeta **MinyPLD** (Altera/Intel **MAX V
5M80Z**). El top es `top_minypld` (divisor de reloj + semáforo).

## Configuración de esta MinyPLD

El proyecto ya trae el pinout **real** de la tarjeta:

| Parámetro | Valor |
|---|---|
| Dispositivo | `5M80ZE64C5` (MAX V, 64 pines, 80 LE) |
| Reloj | oscilador de **25 MHz** en `PIN_7` (período 40 ns en el `.sdc`) |
| `rst_n` | `PIN_21` (push-button, activo en bajo) |
| `led_red` / `led_yellow` / `led_green` | `PIN_62` / `PIN_63` / `PIN_64` |
| I/O standard | 3.3-V LVTTL |

El divisor (`top_minypld.v`) usa `DIV=12.5M`, `CW=24` → `slow_clk` de **1 Hz**
(verde 5 s, amarillo 2 s, rojo 5 s). Timing: con 40 ns cierra holgado (el
camino crítico del contador es ~29 ns en el 5M80Z C5).

> **Para otra tarjeta** ajusta cuatro cosas: `DEVICE` y las 5 líneas
> `set_location_assignment` en `semaphore.qsf`, el `create_clock -period` en
> `semaphore.sdc`, y el `DIV`/`CW` del divisor en `top_minypld.v` (DIV = medio
> periodo deseado × frecuencia del reloj; `CW = ceil(log2(DIV))`).

**Presupuesto de LE:** el 5M80Z tiene **80 logic elements**. El divisor de
24 bits usa ~24 LE + el FSM del semáforo; entra con margen. Vigila el *fitter*
si agrandas el diseño.

## Compilar y programar

```bash
# Por línea de comandos (o usa la GUI de Quartus):
quartus_map  semaphore
quartus_fit  semaphore
quartus_asm  semaphore        # genera el .pof
# Programar con el USB-Blaster:
quartus_pgm -c USB-Blaster -m JTAG -o "p;output_files/semaphore.pof"
```

## Qué mostrar en vivo

- El **reporte de utilización** (cuántos LE de los 80 usó el semáforo).
- La tarjeta con los LEDs turnándose: **el mismo RTL** que simulamos, ahora
  corriendo en silicio reconfigurable. Mensaje: *"mismo código, dos
  destinos — aquí reprogramable (CPLD), en ASIC sería permanente."*