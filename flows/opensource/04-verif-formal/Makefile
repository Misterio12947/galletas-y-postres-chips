# Verificacion formal del semaforo con SymbiYosys (Capsula 4 - Gelatina)
#
# Requiere: sby (SymbiYosys) + yosys + un solver SMT (yices / boolector / z3).
#           La via facil es oss-cad-suite (trae todo):
#           https://github.com/YosysHQ/oss-cad-suite-build
#
# Uso:
#   make          -> demuestra la propiedad (una sola luz)  -> PASS
#   make bug      -> corre con el bug -> FAIL + contraejemplo
#   make wave     -> abre el contraejemplo del bug en GTKWave
#   make clean    -> borra los directorios de trabajo

.PHONY: all prueba bug wave clean

all: prueba

prueba:
	sby -f prueba.sby

bug:
	sby -f bug.sby

wave:
	gtkwave bug/engine_0/trace.vcd &

clean:
	rm -rf prueba bug
