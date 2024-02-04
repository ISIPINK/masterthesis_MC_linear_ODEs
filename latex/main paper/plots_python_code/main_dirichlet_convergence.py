from random import random as U, seed
from math import exp
import numpy as np
import matplotlib.pyplot as plt


def Pb0(t, b0, b1): return (b1-t)/(b1-b0)
def Pb1(t, b0, b1): return (t-b0)/(b1-b0)


def G(t, s, b0, b1): return -(b1-s)*(t-b0) / \
    (b1-b0) if t < s else - (b1-t)*(s-b0)/(b1-b0)


def X(T, y0, y1, b0, b1):
    yy = np.array([y0, y1])
    bb = np.diag([(b1-b0)/len(T)]*len(T))
    PP = np.array([[Pb0(t, b0, b1), Pb1(t, b0, b1)] for t in T])
    sol = PP @ yy
    l = 1.2  # russian roulette rate
    if U()*l < 1:
        SS = [b0+(U()+j)*(b1-b0)/len(T) for j in range(len(T))]
        GG = np.array([[G(t, S, b0, b1) for S in SS] for t in T])
        sol += l*GG @ bb @ X(SS, y0, y1, b0, b1)
    return sol


def soltest(t, y0, y1, b0, b1, nsim=10**0, q=1):
    return sum(X([t]*q, y0, y1, b0, b1) for _ in range(nsim))/nsim


seed(42)
q = 1
K = np.arange(0.1, 2, 0.01)
errors = np.array(
    [abs(soltest(0, exp(-k), exp(k), -k, k, 1, q)[0]-1) for k in K])  # 1 = exp(0)
errors100 = np.array(
    [abs(soltest(0, exp(-k), exp(k), -k, k, 10**2, q)[0]-1) for k in K])

plt.plot(K, np.log(errors)/np.log(10), label="nsim=1")
plt.plot(K, np.log(errors100)/np.log(10), label="nsim=100")
plt.xlabel("k")
plt.ylabel("log10(%error)")
plt.legend()
plt.savefig(
    "latex/main paper/plots/main_dirichlet_convergence.png", dpi=300)
# plt.show()
