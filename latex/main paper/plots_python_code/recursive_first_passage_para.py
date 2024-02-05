import matplotlib.pyplot as plt
from random import seed, sample
import numpy as np


def in_triangle(time, pos): return 1-time > abs(pos)


def sample_euler_triangle(dt=0.001):
    pos, time = 0, 0
    while in_triangle(time, pos):
        pos += np.random.normal(0, 1) * np.sqrt(dt)
        time += dt
    return (time, pos)


def triangle_scale_in_para(time, pos):
    xx = np.sqrt(1-time) - abs(pos)
    tt = abs(1-abs(pos)**2-time)
    dtt = np.sqrt(tt)
    return min(dtt, xx)

# requires precomputed triangle_sample


def sample_recursive_para(accuracy=0.01, scale_mul=0.9):
    time, pos = 0, 0
    scale = triangle_scale_in_para(time, pos)
    while scale > accuracy:
        scale *= scale_mul
        dtime, dpos = sample(triangle_sample, 1)[0]
        dtime, dpos = (scale**2)*dtime, scale*dpos
        pos += dpos
        time += dtime
        scale = triangle_scale_in_para(time, pos)
    return (time, pos)


seed(42)
np.random.seed(42)

triangle_sample = [sample_euler_triangle(dt=0.001) for _ in range(5*10**3)]

fig, axs = plt.subplots(1, 2, figsize=(10, 5))

y = np.arange(-1, 1.01, 0.01)
x = 1 - y**2
axs[1].plot(x, y, color="red", label="barrier")

rsample = [sample_recursive_para(0.01, 0.9) for _ in range(5*10**4)]
T, X = zip(*rsample)
axs[1].scatter(T, X, alpha=1, color="blue")

# Plot the scatter plot on the right
axs[1].scatter([], [], color="blue", label="first passage")
axs[1].set_title("recursive first passage sampling")
axs[1].set_xlabel("time")
axs[1].set_ylabel("x")
axs[1].set_ylim(-1.05, 1.05)
axs[1].legend()

# Plot the histogram on the left
axs[0].hist(X, bins=500, orientation="horizontal", color="blue")
axs[0].set_title("first passage X")
axs[0].set_ylabel("x")
axs[0].set_ylim(-1.05, 1.05)
axs[0].set_xlabel("count")

plt.subplots_adjust(wspace=0.3)
plt.savefig("latex/main paper/plots/recursive_first_passage_para.png", dpi=300)
# plt.show()
