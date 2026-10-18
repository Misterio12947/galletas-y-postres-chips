# Sintesis ASIC del semaforo con Yosys + SKY130 (Capsula 6 - Polvorones)
#
# Gemelo open source del lado Synopsys (Design Compiler, en
# flows/synopsys/06-sintesis/). MISMO RTL y MISMA liberty (SKY130 HD),
# para poder comparar celdas y area entre los dos sintetizadores.
#
# Requiere: yosys + la liberty de SKY130 (sky130_fd_sc_hd__tt_025C_1v80.lib).
#   La liberty viene con el PDK:  volare enable --pdk sky130
#   o dentro de oss-cad-suite. Ajusta LIB/PDK_ROOT a tu instalacion.
#
# Uso:
#   make synth              -> sintetiza y reporta celdas + area (stat)
#   make netlist            -> ademas escribe el netlist (netlist.v)
#   make synth CW=16        -> sube el ancho del contador y mira crecer el area
#   make clean
#
# El conteo de celdas que imprime 'stat' son las POLVORONES: celdas
# estandar del mismo molde, repetidas.

RTL := ../../../common/rtl/semaphore/rtl/semaphore.v
TOP := semaforo
CW  ?= 8
PDK_ROOT ?= /content/pdk
LIB ?= $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib

SYNTH := read_verilog $(RTL); chparam -set CW $(CW) $(TOP); \
         synth -top $(TOP) -flatten; \
         dfflibmap -liberty $(LIB); abc -liberty $(LIB); opt_clean

.PHONY: synth netlist clean

synth:
	yosys -p "$(SYNTH); stat -liberty $(LIB)"

netlist:
	yosys -p "$(SYNTH); write_verilog -noattr netlist.v; stat -liberty $(LIB)"

clean:
	rm -f netlist.v
