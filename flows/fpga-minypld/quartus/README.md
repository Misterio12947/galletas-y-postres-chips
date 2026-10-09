# MinyPLD — Quartus (Cápsula 5 · Mazapán)

Implementa el semáforo en la tarjeta **MinyPLD** (Altera/Intel **MAX V
5M80Z**). El top es `top_minypld` (divisor de reloj + semáforo).

## ⚠️ Antes de compilar — ajusta a TU tarjeta

1. **Dispositivo:** en `semaphore.qsf`, cambia `DEVICE` al OPN exacto de tu
   5M80Z.
2. **Pines:** reemplaza cada `PIN_XX` por la ubicación real de `clk`, `rst_n`
   y los tres LEDs en tu MinyPLD.
3. **Reloj:** ajusta el periodo en `semaphore.sdc` y el `DIV` del divisor en
   `top_minypld.v` a la frecuencia real de tu reloj.
4. **Presupuesto de LE:** el 5M80Z tiene **80 logic elements**. El divisor
   ÷25M usa ~25 LE; vigila el *fitter*. Si no cabe, usa un reloj ya lento de
   la tarjeta (o el oscilador interno) y reduce/elimina el divisor.

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
