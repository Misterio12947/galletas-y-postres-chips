# Verificación funcional (open source) — Icarus + GTKWave

Demo de la Cápsula 3 (Flan). Simula el semáforo y comprueba que **nunca hay
dos luces encendidas a la vez**.

## Requisitos

```bash
sudo apt-get install -y iverilog gtkwave   # Debian/Ubuntu/Rocky equivalente
```

## Correr

```bash
make          # compila y corre -> debe imprimir ">>> PASS"
make wave     # abre la onda en GTKWave
```

## Qué mostrar en vivo

1. El comando `make` y el `>>> PASS` en consola (el **checker** funcionó).
2. En GTKWave: las señales `green`, `yellow`, `red` turnándose — nunca dos a la vez.
3. Mensaje para el público: *"probamos muchos casos… ¿y TODOS? → eso es la
   Cápsula 4, verificación formal."*

> Plan B si algo falla: basta la corrida de Icarus (es ligera); la onda es
> opcional.
