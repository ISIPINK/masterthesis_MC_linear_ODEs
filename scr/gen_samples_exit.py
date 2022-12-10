import numpy as np
import csv
from math import sqrt


from boundary import out_boundary, out_boundary2



def samples_boundary(dt = 0.005, n_sims = 10000):
    exit_positions = []
    for i in range(n_sims):
        pos,time = 0,0
        while True:
            pos += np.random.normal(0, 1) * np.sqrt(dt)
            time +=  dt
            if out_boundary(time,pos):
                exit_positions.append((pos,time))
                break
    return exit_positions

def samples_boundary2(dt = 0.005, n_sims = 10000):
    exit_positions = []
    for i in range(n_sims):
        pos,time = 0,0
        while True:
            pos += np.random.normal(0, 1) * np.sqrt(dt)
            time +=  dt
            if out_boundary2(time,pos):
                exit_positions.append((pos*sqrt(2),time*2))
                break
    return exit_positions

def get_samples_exit():
    np.random.seed(42)
    with open("../objects/samples_exit.csv","w") as f:
        write = csv.writer(f)
        write.writerow(["pos","time"])
        write.writerows(samples_boundary(dt = 0.001))

def get_samples_exit2():
    np.random.seed(42)
    with open("../objects/samples_exit2.csv","w") as f:
        write = csv.writer(f)
        write.writerow(["pos","time"])
        write.writerows(samples_boundary2(dt = 0.001))

if __name__ == "__main__":
    get_samples_exit2()
    

