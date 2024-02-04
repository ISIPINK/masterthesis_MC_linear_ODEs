import matplotlib.pyplot as plt
from random import random as U
from math import exp, sin, cos
import numpy as np
from numba import njit, prange


@njit
def f(x): return exp(x)


@njit
def trapezium(n):
    sol = 0.0
    for j in range(n):
        if j/n > 1:
            print("you")
        sol += (f(j/n)+f((j+1)/n))/2
    return sol/n


@njit
def MCtrapezium(n, l=100):
    sol = 0
    for j in range(n):
        if U()*l < 1:
            x, xx = j/n, (j+1)/n
            S = x + U()*(xx-x)  # \sim Uniform(x,xx)
            sol += l*(f(S)-f(x)-(S-x)*(f(xx)-f(x))*n)/n
    return sol+trapezium(n)


@njit
def exact(a, b): return exp(b)-exp(a)
@njit
def error(s): return (s-exact(0, 1))/exact(0, 1)


def MCtrap_llplot():
    DTS = np.floor(np.power(2, np.arange(0, 23, 0.2))).astype(int)
    errors = np.array(
        [(abs(trapezium(n)-exact(0, 1)))/(exact(0, 1)) for n in DTS])
    MCerrors = np.array(
        [(abs(MCtrapezium(n, 100)-exact(0, 1)))/(exact(0, 1)) for n in DTS])
    plt.plot(np.log(DTS)/np.log(10), np.log(errors) /
             np.log(10), label="OG trap")
    # plt.plot(np.log(DTS)/np.log(10),np.log(errors*0.90)/np.log(10), label = "adj OG trap")
    plt.plot(np.log(DTS)/np.log(10), np.log(MCerrors) /
             np.log(10), label="MC trap")
    dgs = np.arange(2, 3.5, 0.5)
    for l in dgs:
        ref = np.array([pow(1/d, l) for d in DTS])
        plt.plot(np.log(DTS)/np.log(10), np.log(ref)/np.log(10),
                 label=f"$\Delta x$**{l}", linestyle="dashed")

    plt.xlabel(f"-log10($\Delta x$)")
    plt.ylabel("log10(%error)")
    plt.legend()
    # plt.title("log log plot")
    # plt.savefig("../../latex/main paper/plots/MCtrap.png",dpi=300)
    plt.show()


MCtrap_llplot()
