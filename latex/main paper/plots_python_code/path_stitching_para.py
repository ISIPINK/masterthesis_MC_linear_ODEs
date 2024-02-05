from math import sqrt
import random
import numpy as np
import matplotlib.pyplot as plt


def in_triangle(time, pos): return 1-time > abs(pos)


def euler_triangle_path_sample(dt=0.1, nsim=10**3):
    path_sample = []
    for _ in range(nsim):
        pos, time = 0, 0
        path = [(time, pos)]
        while in_triangle(time, pos):
            pos += np.random.normal(0, 1) * np.sqrt(dt)
            time += dt
            path.append((time, pos))
        path_sample.append(path)
    return path_sample


# for p in t_path_sample:
#     x,y = zip(*p)
#     plt.plot(x,y)
# plt.show()

def triangle_scale_in_para(time, pos):
    xx = sqrt(abs(1-time)) - abs(pos)
    tt = abs(1-abs(pos)**2-time)
    return sqrt(tt) if sqrt(tt) < xx else xx


def recursive_para_path_sample(nsim=10**3, accuracy=0.1, max_scale=1, scale_mul=0.9):
    path_sample = []
    stiches = []
    for _ in range(nsim):
        time, pos = 0, 0
        path = [(time, pos)]
        scale = min(triangle_scale_in_para(time, pos), max_scale)
        while scale > accuracy:
            scale *= scale_mul
            dpath = random.sample(t_path_sample, 1)[0]
            # sometimes you can get away with only a ptr and the endpoint
            dpath = [(time + (scale**2)*t, pos + scale*p)
                     for t, p in dpath[1:]]
            time, pos = dpath[-1]
            path += dpath
            scale = min(triangle_scale_in_para(time, pos), max_scale)
            stiches.append((time, pos))
        path_sample.append(path)
    return path_sample, stiches


random.seed(42)
np.random.seed(42)

t_path_sample = euler_triangle_path_sample(0.01, 10**4)
mul_scale = 0.85
r_path_sample, stiches = recursive_para_path_sample(10, 0.01, 1, mul_scale)


for p in r_path_sample:
    x, y = zip(*p)
    plt.plot(x, y, alpha=1)

# x = np.array([0,1,0])*mul_scale**2
# y = np.array([1,0,-1])*mul_scale
# plt.plot(x,y,color="grey",label="first barrier")

x, y = zip(*stiches)
plt.scatter(x, y, color="green", alpha=1, label="stitches")

fp_points = [p[-1] for p in r_path_sample]
x, y = zip(*fp_points)
plt.scatter(x, y, color="blue")

y = np.arange(-1, 1.01, 0.01)
x = 1-y**2
plt.plot(x, y, color="red", label="barrier")

plt.scatter([], [], color="blue", label="first passage")
plt.title("path stitching")
plt.xlabel("time")
plt.ylabel("x")
plt.legend()
plt.savefig("latex/main paper/plots/path_stitching_para.png", dpi=300)
# plt.show()
