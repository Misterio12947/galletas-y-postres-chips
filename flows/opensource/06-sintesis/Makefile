# Sintesis ASIC del semaforo con Yosys + SKY130 (Capsula 6 - Polvorones)
#
# Gemelo open source del lado Synopsys (Design Compiler, en
# flows/synopsys/06-sintesis/). MISMO RTL y MISMA liberty (SKY130 HD),
# para comparar celdas y area entre los dos sintetizadores.
#
# Uso:
#   make synth              -> sintetiza, reporta celdas+area y guarda synth.log
#   make netlist            -> ademas escribe el netlist (netlist.v + netlist.log)
#   make synth CW=16        -> sube el ancho del contador y mira crecer el area
#   make clean
#
# La liberty se AUTO-DETECTA en las rutas tipicas (ciel / volare /
# oss-cad-suite / imagenes FOSS). Si no la encuentra, pasala a mano:
#   make synth LIB=/ruta/a/sky130_fd_sc_hd__tt_025C_1v80.lib
# o apunta  PDK_ROOT=...  a donde este el directorio sky130A/.
#
# El conteo de celdas que imprime 'stat' son las POLVORONES: celdas
# estandar del mismo molde, repetidas.

RTL := ../../../common/rtl/semaphore/rtl/semaphore.v
TOP := semaforo
CW  ?= 8

.DEFAULT_GOAL := synth

# --- Auto-deteccion de la liberty SKY130 HD (tt, 25C, 1.80V) ----------
# Toma la primera ruta que EXISTA (wildcard descarta las que no estan).
# Se puede forzar con  LIB=...  o con  PDK_ROOT=...
LIBREL := sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
LIB ?= $(firstword $(wildcard \
  $(PDK_ROOT)/sky130A/libs.ref/$(LIBREL) \
  /foss/pdks/ciel/sky130/versions/*/sky130A/libs.ref/$(LIBREL) \
  /foss/pdks/sky130A/libs.ref/$(LIBREL) \
  $(HOME)/.ciel/sky130/versions/*/sky130A/libs.ref/$(LIBREL) \
  $(HOME)/.volare/sky130/versions/*/sky130A/libs.ref/$(LIBREL) \
  $(HOME)/.volare/sky130A/libs.ref/$(LIBREL) \
  $(HOME)/pdk/sky130A/libs.ref/$(LIBREL)))

SYNTH := read_verilog $(RTL); chparam -set CW $(CW) $(TOP); \
         synth -top $(TOP) -flatten; \
         dfflibmap -liberty $(LIB); abc -liberty $(LIB); opt_clean

.PHONY: synth netlist clean check-lib

# Verifica que haya liberty ANTES de llamar a yosys (mensaje claro si no).
check-lib:
	@if [ -z "$(LIB)" ] || [ ! -f "$(LIB)" ]; then \
	  echo "ERROR: no encontre la liberty SKY130 (sky130_fd_sc_hd__tt_025C_1v80.lib)."; \
	  echo "       Pasala a mano:  make $(or $(MAKECMDGOALS),synth) LIB=/ruta/....lib"; \
	  echo "       o define PDK_ROOT apuntando a donde esta sky130A/."; \
	  exit 1; \
	fi
	@echo ">> Liberty: $(LIB)"

synth: check-lib
	yosys -l synth.log -p "$(SYNTH); stat -liberty $(LIB)"
	@echo ">> Reporte completo en: synth.log"

netlist: check-lib
	yosys -l netlist.log -p "$(SYNTH); write_verilog -noattr netlist.v; stat -liberty $(LIB)"
	@echo ">> Netlist en: netlist.v   |   reporte en: netlist.log"

clean:
	rm -f netlist.v synth.log netlist.log
