from random import random as U
from math import exp
import numpy as np
def Pb0(t,b0,b1): return (b1-t)/(b1-b0)
def Pb1(t,b0,b1): return (t-b0)/(b1-b0)
def G(t,s,b0,b1): return -(b1-s)*(t-b0)/(b1-b0) if t<s else - (b1-t)*(s-b0)/(b1-b0) 
def X(T,y0,y1,b0,b1): 
    yy = np.array([y0,y1])
    bb = np.diag([(b1-b0)/len(T)]*len(T))
    PP = np.array([[Pb0(t,b0,b1),Pb1(t,b0,b1)] for t in T])
    sol = PP @ yy
    l = 1.04 # russian roulette rate
    if U()*l<1: 
        u = U()
        SS = [b0+(u+j)*(b1-b0)/len(T) for j in range(len(T))]
        GG = np.array([[G(t,S,b0,b1) for S in SS] for t in T]) 
        sol += l*GG @ bb @ X(SS,y0,y1,b0,b1)
    return sol 