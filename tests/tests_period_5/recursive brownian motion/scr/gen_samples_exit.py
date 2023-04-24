import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from math import sqrt
import csv

from boundary import Boundary, Scaled_cone_boundary, Regular_cone_boundary, Parabolic_boundary


def samples_boundary_euler(boundary: Boundary, dt=0.005, n_sims=10000):
    exit_positions = []
    for i in range(n_sims):
        pos, time = 0, 0
        while True:
            pos += np.random.normal(0, 1) * np.sqrt(dt)
            time += dt
            if boundary.is_out(pos, time):
                exit_positions.append((pos, time))
                break
    return exit_positions


def samples_boundary_recursive(boundary: Boundary, n_sims, accuracy):
    file_base_samples = "../objects/base_cone_samples.csv"
    base_samples = pd.read_csv(file_base_samples)
    res = []
    for _ in range(n_sims):
        pos, time = 0, 0
        scale = boundary.get_scale(pos, time)
        while scale > accuracy:
            dpos, dtime = base_samples.sample(1).iloc[0]
            dpos, dtime = scale*dpos, (scale**2)*dtime
            pos += dpos
            time += dtime
            scale = boundary.get_scale(pos, time)
        res.append((pos, time))
    return res


def save_samples_exit(name: str, samples):
    with open(f"../objects/{name}.csv", "w") as f:
        write = csv.writer(f)
        write.writerow(["pos", "time"])
        write.writerows(samples)


def generate_base_cone_samples():
    regular_cone = Regular_cone_boundary()
    samples = samples_boundary_euler(
        boundary=regular_cone,
        dt=0.001,
        n_sims=10000)

    save_samples_exit("base_cone_samples", samples)


def generate_para_example():
    para = Parabolic_boundary()
    para_samples_recursive = samples_boundary_recursive(para, 1000, 0.001)
    para_samples_euler = samples_boundary_euler(para, 0.005, 1000)
    save_samples_exit("para_samples_recursive", para_samples_recursive)
    save_samples_exit("para_samples_euler", para_samples_euler)


if __name__ == "__main__":
    pass
