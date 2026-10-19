#!/usr/bin/env python3
"""Compara el Bode IDEAL (sin parasitos) vs el PEX (con R/C del layout) y reporta
Av0, GBW y margen de fase de cada uno, y cuanto cambia el GBW.

Formato de entrada = el de ngspice `wrdata` (col0=freq, col1=gain_dB, ultima=fase).

Uso:  plot_pex_compare.py <ideal.txt|""> <pex.txt> [salida.png]
"""
import sys
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt


def cargar(path):
    d = np.atleast_2d(np.loadtxt(path))
    f, g, p = d[:, 0], d[:, 1], d[:, -1]
    o = np.argsort(f)
    return f[o], g[o], p[o]


def cruce0(f, g):
    for i in range(len(g) - 1):
        if g[i] >= 0 >= g[i + 1]:
            lf = np.log10(f[i]) + (0 - g[i]) * (np.log10(f[i+1]) - np.log10(f[i])) / (g[i+1] - g[i])
            return 10 ** lf
    return None


def metricas(f, g, p):
    av0 = float(g[0])
    fu = cruce0(f, g)
    if fu is None:
        return av0, None, None
    phu = float(np.interp(np.log10(fu), np.log10(f), p))
    pm = (180 + phu) % 360
    if pm > 180:
        pm -= 360
    return av0, fu, pm


def main():
    ideal_path = sys.argv[1] if len(sys.argv) > 1 else ""
    pex_path = sys.argv[2]
    out = sys.argv[3] if len(sys.argv) > 3 else "bode_compare.png"

    fp, gp, pp = cargar(pex_path)
    a_p, fu_p, pm_p = metricas(fp, gp, pp)

    fig, (axg, axp) = plt.subplots(2, 1, figsize=(7.5, 6), sharex=True)

    tiene_ideal = bool(ideal_path) and ideal_path not in ("", '""')
    if tiene_ideal:
        fi, gi, pi = cargar(ideal_path)
        a_i, fu_i, pm_i = metricas(fi, gi, pi)
        axg.semilogx(fi, gi, color="#9aa0a6", lw=2, ls="--", label="ideal (sin parasitos)")
        axp.semilogx(fi, pi, color="#9aa0a6", lw=2, ls="--", label="ideal")
        print("            Av0 [dB]   GBW [MHz]   PM [deg]")
        print(f"  ideal   : {a_i:7.1f}   {('%.2f'%(fu_i/1e6)) if fu_i else '  -':>9}   {('%.0f'%pm_i) if pm_i else ' -':>7}")
        print(f"  con PEX : {a_p:7.1f}   {('%.2f'%(fu_p/1e6)) if fu_p else '  -':>9}   {('%.0f'%pm_p) if pm_p else ' -':>7}")
        if fu_i and fu_p:
            dd = 100 * (fu_p - fu_i) / fu_i
            print(f"  -> GBW cambia {dd:+.1f}%  (los parasitos {'bajan' if dd < 0 else 'suben'} el ancho de banda)")
    else:
        print(f"  con PEX : Av0={a_p:.1f} dB" + (f"  GBW={fu_p/1e6:.2f} MHz  PM={pm_p:.0f} deg" if fu_p else "  (no cruza 0 dB)"))

    axg.semilogx(fp, gp, color="#C8742B", lw=2, label="con PEX (R+C reales)")
    axg.axhline(0, color="#888", lw=0.8, ls="--")
    if fu_p:
        axg.plot([fu_p], [0], "o", color="#dc2626")
    axg.set_ylabel("Ganancia [dB]"); axg.grid(True, which="both", alpha=0.3); axg.legend(fontsize=8)
    axg.set_title("OTA 5T - Bode: ideal vs con parasitos (PEX)")
    axp.semilogx(fp, pp, color="#C8742B", lw=2, label="con PEX")
    axp.set_ylabel("Fase [deg]"); axp.set_xlabel("Frecuencia [Hz]")
    axp.grid(True, which="both", alpha=0.3); axp.legend(fontsize=8)
    plt.tight_layout(); plt.savefig(out, dpi=110)
    print(f"Figura -> {out}")


if __name__ == "__main__":
    main()
