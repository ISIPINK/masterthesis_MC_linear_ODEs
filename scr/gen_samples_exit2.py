import pandas as pd
import numpy as np
from math import sqrt
import csv
from random import sample
import matplotlib.pyplot as plt

def load_objects():
    file_samples= "../objects/samples_exit.csv"
    df_samples = pd.read_csv(file_samples)
    return df_samples

def improve_sample_boundary(samples_boundary, first_scale=0.5, amount=10000, accuracy = 0.01):
    res = []
    for _ in range(amount):
        scale = first_scale
        pos,time = sample(samples_boundary,1)[0]
        pos,time = sqrt(scale)*pos, scale*time
        positions = [0,pos]
        times = [0, time]
        while sqrt(scale) > accuracy:
            scale =  (1-abs(pos)-time)**2
            dpos,dtime = sample(samples_boundary,1)[0]
            dpos,dtime = sqrt(scale)*dpos, scale*dtime
            pos += dpos
            time += dtime
            positions.append(pos)
            times.append(time)
        res.append((pos,time))
        plt.plot(positions,times)
    plt.show()
    return res

def get_samples_exit():
    df_samples= load_objects()

    with open("../objects/samples_exit_recursive.csv","w") as f:
        write = csv.writer(f)
        write.writerow(["pos","time"])
        #df = df_samples.sample(frac = 0.2)
        #samples = list(zip(df["pos"],df["time"]))
        
        samples = [(0.5,0.5),(-0.5,0.5)]
        tmp =  improve_sample_boundary(samples) 
        tmp =  improve_sample_boundary(tmp) 

        write.writerows(tmp)

if __name__ == "__main__":
    get_samples_exit()
        

