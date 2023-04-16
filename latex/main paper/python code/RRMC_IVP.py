from random import random as U
def Y_in(t, tn, yn, D):
    S = tn + U()*(t-tn)  # \sim Uniform(T,t)
    return yn + D*Y_in(S, tn, yn, D) if U() < (t-tn)/D else yn
def Y_out(tn, D): # D is out step size
    TT = tn-D if tn-D > 0 else 0  
    return Y_in(tn, TT, Y_out(TT, D), D) if tn > 0 else 1