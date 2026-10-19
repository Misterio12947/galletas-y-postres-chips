# STA / Signoff (open source) - OpenSTA

Demo de la **Capsula 8 (Cajeta)** en linea de comandos. **Firma** el timing del
`semaforo`: revisa **setup** y **hold** en todos los caminos, con los **parasitos
reales** del ruteo. No simula con vectores -- analiza estaticamente.

Gemelo open source del lado Synopsys (PrimeTime, en `flows/synopsys/08-sta/`).

## Requisitos

- `openroad` (trae **OpenSTA** integrado) + `yosys`. Ya vienen en la caja FOSS.
- SKY130 HD (la misma del flujo). El script auto-detecta `.lib`/`techlef`/`lef`.

## Correr

```bash
cd flows/opensource/08-sta
./run_sta.sh
```

Hace: sintetiza el netlist (Yosys), implementa un place + CTS + global route
rapido para tener parasitos reales, escribe el **SPEF** (`results/semaforo.spef`)
y corre el STA (`report_checks` de setup y hold) -> todo a `sta.log`.

## Que mostrar en vivo

1. `report_checks -path_delay max` (**setup**): el camino critico y su **slack**.
2. `report_checks -path_delay min` (**hold**): que ninguna senal llegue demasiado
   temprano.
3. El resumen: **peor slack** y **TNS**. Si el slack es positivo -> **timing
   cerrado** (el semaforo cierra con muchisimo margen).

## Signoff puro (leyendo un SPEF ya hecho)

En un flujo real, STA es un paso **aparte** del PnR: lee un SPEF ya generado.
Con OpenSTA eso es:

```tcl
read_liberty  sky130_fd_sc_hd__tt_025C_1v80.lib
read_verilog  semaforo_routed.v     ;# netlist post-ruteo
link_design   semaforo
read_sdc      semaforo.sdc
read_spef     semaforo.spef          ;# el SPEF de Tres Leches
report_checks -path_delay max
```

Aqui lo hacemos todo en un script para que sea self-contained, pero el concepto
es el mismo: **netlist + SDC + SPEF -> veredicto de timing**.

## Notas

- El SPEF (`results/`), `sta.log` y `netlist.v` estan en el `.gitignore`.
- `estimate_parasitics -global_routing` da los parasitos desde el ruteo global;
  para signoff fino se usaria el ruteo detallado + extraccion, pero para la
  demo el orden de magnitud y el veredicto son los correctos.

## Callback / relevo

Con el timing **firmado**, el chip **digital** esta listo (RTL -> GDS que
cumple el reloj). Lo que sigue es el otro mundo: el **analogico** ->
Bunuelo (esquematico).
