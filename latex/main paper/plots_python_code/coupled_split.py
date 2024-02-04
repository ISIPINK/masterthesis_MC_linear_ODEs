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
        # SS = [b0+(U()+j)*(b1-b0)/len(T) for j in range(len(T))]
        # SS = [b0+U()*(b1-b0) for _ in range(len(T))]
        u = U()
        SS = [b0+(u+j)*(b1-b0)/len(T) for j in range(len(T))]

        GG = np.array([[G(t, S, b0, b1) for S in SS] for t in T])
        sol += l*GG @ bb @ X(SS, y0, y1, b0, b1)

    cc = (U(), U(), U())
    for t, soll in zip(T, sol):
        plt.scatter(t, soll, color=cc)
    return sol


def soltest(t, y0, y1, b0, b1, nsim=10**0, q=20):
    tmp = sum(X([t]*q, y0, y1, b0, b1) for _ in range(nsim))/nsim
    ll = np.arange(b0, b1, 0.01)
    plt.plot(ll, np.exp(ll), color="red", label="exp(t)")
    plt.xlabel("t")
    plt.ylabel("Y(t)")
    plt.legend()
    plt.savefig("latex/main paper/plots/coupled_split.png", dpi=300)
    return tmp


seed(6)
k = 1
print(soltest(0, exp(-k), exp(k), -k, k, 1, 20)[0])
# plt.show()
