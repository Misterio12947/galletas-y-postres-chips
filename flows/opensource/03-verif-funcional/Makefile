# Verificación funcional del semáforo con Icarus Verilog (Cápsula 3 · Flan)
# Uso:
#   make        -> compila + corre el testbench (imprime PASS/FAIL)
#   make wave   -> abre la onda en GTKWave
#   make clean  -> borra temporales

RTL  = ../../../common/rtl/semaphore/rtl/semaphore.v
TB   = ../../../common/rtl/semaphore/tb/tb_semaphore.v
SIM  = sim_sem
VCD  = dump.vcd

.PHONY: all run wave clean

all: run

$(SIM): $(RTL) $(TB)
	iverilog -g2012 -o $(SIM) $(RTL) $(TB)

run: $(SIM)
	vvp $(SIM)

wave: run
	gtkwave $(VCD) &

clean:
	rm -f $(SIM) $(VCD)
