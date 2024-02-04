from random import random as U, seed
from math import exp
import matplotlib.pyplot as plt
import numpy as np


def H(x): return 0 if x < 0 else 1


points = []


def Y(t):
    sol = exp(1)-1
    l = 2
    if U()*l < 1:
        S = U()
        sol += l*Y(S)*(H(t-S) + S - 1)
    global points
    points += [(t, sol)]
    return sol


def sol(t, nsim): return sum(Y(t) for _ in range(nsim))/nsim


seed(42)
sss = sol(0.5, 3*10**2)
# print((sss-exp(0.5))/exp(0.5))
ll = np.arange(0, 1, 0.01)
pp = np.exp(ll)
qq = [exp(1)-1 for _ in ll]

x, y = zip(*points)
plt.scatter(x, y, label="(t,Y(t))", alpha=0.5)
# plt.ylim(-3,6)
plt.plot(ll, pp, color="red", label="exp(t)")
plt.plot(ll, qq, color="green", linewidth=3, label="e-1")
plt.legend(loc="upper left")
plt.xlabel("t")
base = exp(1)-1
plt.ylim(-5 + base, 5+base)
plt.ylabel("Y(t)")
plt.savefig("latex/main paper/plots/ydy_int.png", dpi=300)
plt.show()
