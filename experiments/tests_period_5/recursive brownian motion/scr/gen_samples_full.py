import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from math import sqrt
from random import sample
import pickle

from boundary import Boundary, Scaled_cone_boundary, Regular_cone_boundary, Parabolic_boundary 

def full_samples_boundary_euler(boundary:Boundary, dt = 0.01, n_sims = 1000):
    paths = []
    for i in range(n_sims):
        pos,time = 0,0
        path = [(pos,time)]
        while True:
            pos += np.random.normal(0, 1) * np.sqrt(dt)
            time +=  dt
            path.append((pos,time))
            if boundary.is_out(pos,time):
                paths.append(path)
                break
    return paths

def full_samples_boundary_recursive(boundary:Boundary, n_sims, accuracy):
    base_full_samples = load_full_samples("base_cone_full_samples") 

    paths = []
    for _ in range(n_sims):
        pos,time= 0,0
        path = [(pos,time)]
        scale = boundary.get_scale(pos,time)
        while scale > accuracy:
            dpath = sample(base_full_samples,1)[0]
            # sometimes you can get away with only a ptr and the endpoint
            dpath = [(pos + scale*p,time + (scale**2)*t) for p,t in dpath[1:]] 
            pos,time = dpath[-1]
            path += dpath
            scale = boundary.get_scale(pos,time)
        paths.append(path)
    return paths

def save_full_samples(name:str, full_samples):
    with open(f"../objects/{name}.bin","wb") as f:
        pickle.dump(full_samples, f)


def load_full_samples(name:str)-> list:
    with open(f"../objects/{name}.bin", "rb") as data:
        return pickle.load(data)

def plot_full_samples(full_samples):
    for path in full_samples:
        positions, times = zip(*path)
        plt.plot(positions,times)
    plt.title("plt of paths")
    plt.show()

def plot_full_samples_endpos(full_samples,bins=50):
    endpos = [path[-1][0] for path in full_samples]
    plt.hist(endpos, bins=bins)
    plt.title("hist of endpos")
    plt.show()

def generate_base_cone_full_samples():
    regular_cone = Regular_cone_boundary()
    full_samples = full_samples_boundary_euler(
            boundary = regular_cone,
            dt = 0.001, 
            n_sims= 1000)

    save_full_samples("base_cone_full_samples",full_samples)

def plot_para_example():
    para = Parabolic_boundary()

    para_full_samples_recursive = full_samples_boundary_recursive(para,1000,0.01)
    plot_full_samples(sample(para_full_samples_recursive,100))
    plot_full_samples_endpos(sample(para_full_samples_recursive,1000))

    para_full_samples_euler = full_samples_boundary_euler(para,0.001,1000)
    plot_full_samples(sample(para_full_samples_euler,100))
    plot_full_samples_endpos(sample(para_full_samples_euler,1000))


if __name__ == "__main__":
    plot_para_example()

    
    

