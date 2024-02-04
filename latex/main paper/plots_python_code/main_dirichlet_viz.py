from random import random, seed
from math import exp
import numpy as np
import matplotlib.pyplot as plt


def Pb0(t, b0, b1): return (b1-t)/(b1-b0)
def Pb1(t, b0, b1): return (t-b0)/(b1-b0)


def G(t, s, b0, b1): return -(b1-s)*(t-b0) / \
    (b1-b0) if t < s else - (b1-t)*(s-b0)/(b1-b0)


def pltaa(t, y0, y1, b0, b1, nsim, ax):
    points = []

    def Y(t, y0, y1, b0, b1):
        sol = Pb0(t, b0, b1)*y0 + Pb1(t, b0, b1)*y1
        l = 1.2  # russian roulette rate
        if random()*l < 1:
            S = b0+random()*(b1-b0)
            sol += l*G(t, S, b0, b1) * Y(S, y0, y1, b0, b1)*(b1-b0)
        points.append((t, sol))
        return sol

    def soltest(t, y0, y1, b0, b1, nsim=10**3): return sum(Y(t,
                                                             y0, y1, b0, b1) for _ in range(nsim))/nsim
    sss = soltest(t, y0, y1, b0, b1, nsim)
    # print(sss)
    x, y = zip(*points)
    ax.scatter(x, y, label='(t,Y(t))', alpha=0.5)
    ll = np.arange(b0, b1, 0.01)
    ax.plot(ll, np.exp(ll), color="red", label='exp(t)')
    ax.set_xlabel('t')
    ax.set_ylabel('Y(t)')
    ax.set_title(f'Plot for k = {k}')
    ax.legend(loc='upper left')


seed(42)
fig, axs = plt.subplots(2, 3, figsize=(15, 10))
k_values = [0.5, 1, 1.1, 1.2, 1.5, 2]
for i, k in enumerate(k_values):
    ax = axs[i//3, i % 3]
    pltaa(0, exp(-k), exp(k), -k, k, 75, ax)
plt.tight_layout()
plt.savefig(
    "latex/main paper/plots/main_dirichlet_viz.png", dpi=300)
# plt.show()
