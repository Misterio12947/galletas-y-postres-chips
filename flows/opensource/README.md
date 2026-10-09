# Flujo open source

Scripts open source por etapa, que consumen el RTL de `common/`. Arrancamos
con RTL y verificación funcional; las demás etapas se agregan conforme avanza
el evento.

| Etapa | Carpeta | Herramientas |
|---|---|---|
| RTL | `02-rtl/` | Yosys (ver esquemático) |
| Verif. funcional | `03-verif-funcional/` | Icarus + GTKWave |
| Verif. formal | `04-verif-formal/` *(pendiente)* | SymbiYosys |
| Síntesis | `06-sintesis/` *(pendiente)* | Yosys |
| PnR | `07-pnr/` *(pendiente)* | OpenROAD / OpenLane |
| STA + signoff | `08-sta-signoff/` *(pendiente)* | OpenSTA, Magic, Netgen |
| Analógico | `09-12-analog/` *(pendiente)* | xschem, ngspice, Magic |
