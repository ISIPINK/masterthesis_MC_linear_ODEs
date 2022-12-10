import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
from plotnine import *

def load_objects():
    file_samples= "../objects/samples_exit.csv"
    file_samples2= "../objects/samples_exit2.csv"
    file_samples_recursive= "../objects/samples_exit_recursive.csv"
    df_samples = pd.read_csv(file_samples)
    df_samples2 = pd.read_csv(file_samples2)
    df_samples_recursive = pd.read_csv(file_samples_recursive)
    return df_samples, df_samples2, df_samples_recursive


def plt_exit_points(df_samples):
    plot = (ggplot(df_samples, aes(x = "pos", y ="time"))
            + geom_point())
    print(plot)

def plt_exit_pos(df_samples):
    plot = (ggplot(df_samples, aes(x = "pos"))
            + geom_density())
    print(plot)

def plt_exit_pos_compare(df_samples,df_samples2):
    plot = (ggplot(df_samples, aes(x = "pos"))
            + geom_density()
            + geom_density(data = df_samples2, color = "red"))
    print(plot)
    
def plt_exit_pos_compare_abs(df_samples,df_samples2):
    df_samples["abspos"]=abs(df_samples["pos"])
    df_samples2["abspos"]=abs(df_samples2["pos"])
    plot = (ggplot(df_samples, aes(x = "abspos"))
            + geom_density()
            + geom_density(data = df_samples2, color = "red"))
    print(plot)

if __name__ == "__main__":
    np.random.seed(42)
    df_samples, df_samples2, df_samples_recursive = load_objects()
    plt_exit_pos_compare(df_samples,df_samples2)
    plt_exit_pos_compare_abs(df_samples,df_samples_recursive)

    
