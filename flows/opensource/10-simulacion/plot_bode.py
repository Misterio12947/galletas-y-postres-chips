#!/usr/bin/env python3
"""Grafica el Bode del OTA desde el bode.txt que escribe ngspice (wrdata) y
reporta Av0 (ganancia DC), GBW (cruce de 0 dB) y margen de fase.

wrdata vuelca, para cada vector real, una pareja (escala, valor). Con
'wrdata bode.txt gain_db ph_deg' salen 4 columnas: freq gain_db freq ph_deg.
Este script es robusto: toma col0=freq, col1=ganancia, ultima col=fase.

Uso:  python3 plot_bode.py results/bode.txt [salida.png]
"""
import sys
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt


def cargar(path):
    datos = np.loadtxt(path)
    datos = np.atleast_2d(datos)
    freq = datos[:, 0]
    gain = datos[:, 1]
    fase = datos[:, -1]           # ultima columna = fase (deg)
    # ordenar por frecuencia por si acaso
    orden = np.argsort(freq)
    return freq[orden], gain[orden], fase[orden]


def cruce_cero(freq, gain):
    """Frecuencia donde la ganancia cruza 0 dB (interpolada en log-f)."""
    for i in range(len(gain) - 1):
        if gain[i] >= 0 >= gain[i + 1]:
            lf0, lf1 = np.log10(freq[i]), np.log10(freq[i + 1])
            g0, g1 = gain[i], gain[i + 1]
            lf = lf0 + (0 - g0) * (lf1 - lf0) / (g1 - g0)
            return 10 ** lf, i
    return None, None


def interp_fase(freq, fase, f):
    return float(np.interp(np.log10(f), np.log10(freq), fase))


def main():
    if len(sys.argv) < 2:
        print("uso: plot_bode.py <bode.txt> [salida.png]"); sys.exit(1)
    path = sys.argv[1]
    out = sys.argv[2] if len(sys.argv) > 2 else "bode.png"

    freq, gain, fase = cargar(path)
    av0 = float(gain[0])                      # ganancia a la frecuencia mas baja
    gbw, _ = cruce_cero(freq, gain)
    if gbw is not None:
        ph_u = interp_fase(freq, fase, gbw)
        pm = 180.0 + ph_u                     # margen de fase
        pm = pm % 360
        if pm > 180:
            pm -= 360
    else:
        ph_u, pm = float("nan"), float("nan")

    print(f"Av0 (ganancia DC) = {av0:6.1f} dB")
    if gbw is not None:
        esc = gbw / 1e6
        print(f"GBW (cruce 0 dB)  = {esc:6.2f} MHz")
        print(f"Fase en el cruce  = {ph_u:6.1f} deg")
        print(f"Margen de fase    = {pm:6.1f} deg   ({'OK' if pm > 45 else 'BAJO'})")
    else:
        print("GBW: la ganancia no cruza 0 dB en el rango simulado.")

    fig, (axg, axp) = plt.subplots(2, 1, figsize=(7.5, 6), sharex=True)
    axg.semilogx(freq, gain, color="#C8742B", lw=2)
    axg.axhline(0, color="#888", lw=0.8, ls="--")
    axg.set_ylabel("Ganancia [dB]")
    axg.grid(True, which="both", alpha=0.3)
    axg.set_title(f"OTA 5T - Bode   Av0={av0:.1f} dB"
                  + (f"   GBW={gbw/1e6:.2f} MHz   PM={pm:.0f} deg" if gbw else ""))
    if gbw is not None:
        axg.plot([gbw], [0], "o", color="#dc2626")
    axp.semilogx(freq, fase, color="#2563eb", lw=2)
    if gbw is not None:
        axp.plot([gbw], [ph_u], "o", color="#dc2626")
    axp.set_ylabel("Fase [deg]")
    axp.set_xlabel("Frecuencia [Hz]")
    axp.grid(True, which="both", alpha=0.3)
    plt.tight_layout()
    plt.savefig(out, dpi=110)
    print(f"Figura -> {out}")


if __name__ == "__main__":
    main()
