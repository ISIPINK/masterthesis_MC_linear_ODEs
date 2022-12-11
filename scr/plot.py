import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
from math import sqrt
from plotnine import *

def plt_exit_points(df_samples):
    plot = (ggplot(df_samples, aes(x = "pos", y ="time"))
            + geom_point())
    print(plot)

def plt_exit_pos(df_samples):
    plot = (ggplot(df_samples, aes(x = "pos"))
            + geom_histogram(bins=len(df_samples)//10 +5))
    print(plot)

def plt_exit_pos_compare(df_samples,df_samples2):
    plot = (ggplot(df_samples, aes(x = "pos"))
            + geom_histogram(alpha = 0.5, bins =100)
            + geom_histogram(data = df_samples2, fill = "red",alpha = 0.5,bins=100))
    print(plot)
    
def para_comparison():
    para_samples_recursive = pd.read_csv("../objects/para_samples_recursive.csv")
    para_samples_euler = pd.read_csv("../objects/para_samples_euler.csv")
    plot = (ggplot(para_samples_euler, aes(x = "pos"))
            + geom_histogram(alpha = 0.5, bins =100)
            + geom_histogram(data = para_samples_recursive, fill = "red",alpha = 0.5,bins=100)
            + ggtitle("distribution of exit pos, Euler vs Recursive"))
    plot.save("../plots/para_comparison.png")

if __name__ == "__main__":
    para_comparison()
