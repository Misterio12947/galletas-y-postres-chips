# Flujo MinyPLD (FPGA/CPLD)

Implementación en hardware real sobre la tarjeta **MinyPLD** (MAX V 5M80Z),
con **Quartus**. Es el destino físico de la Cápsula 5.

- Proyecto: `quartus/` (`.qsf`, `.sdc`, top en `common/.../top_minypld.v`).
- Guía de la tarjeta y límites (80 LE): `docs/minypld/`.

Ajusta dispositivo, pines y reloj a tu tarjeta antes de compilar (ver
`quartus/README.md`).
