import numpy as np
import matplotlib.pyplot as plt
from random import seed


def in_para(time, pos): return 1-time > abs(pos)**2


seed(42)
np.random.seed(42)

nsim = 10*5
dt = 0.001
for _ in range(nsim):
    pos, time = 0, 0
    path = [(time, pos)]
    while in_para(time, pos):
        pos += np.random.normal(0, 1) * np.sqrt(dt)
        time += dt
        path.append((time, pos))
    T, X = zip(*path)
    plt.plot(T, X)
    plt.scatter(T[-1], X[-1], color="blue")


y = np.arange(-1.01, 1, 0.01)
x = 1-y**2

plt.plot(x, y, color="red", label="barrier")
plt.scatter([], [], color="blue", label="first passage")
plt.title("Euler first passage sampling")
plt.xlabel("time")
plt.ylabel("x")
plt.legend()
plt.savefig("latex/main paper/plots/Euler_first_passage_para.png", dpi=300)
# plt.show()
