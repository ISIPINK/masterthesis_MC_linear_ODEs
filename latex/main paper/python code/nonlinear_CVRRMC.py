from random import random as U
def Y_in(t, tn, yn, dyn, D, l):
    sol = yn  # initial conditon
    sol += t**2-tn**2 - (t**5-tn**5)/5  # source
    sol += (t-tn)*yn**2  # 0 order 
    sol += 2*((t**2-tn**2)/2 - tn*(t-tn))*yn*dyn  # 1 order 
    if U()*l < (t-tn)/D:
        S = tn + U()*(t-tn)  # \sim Uniform(T,t)
        sol += l*D*(Y_in(S, tn, yn, dyn, D, l)*
            Y_in(S, tn, yn, dyn, D, l) - yn**2-2*(S-tn)*yn*dyn)
    return sol
def Y_out(t, D, l):
    yn, tn = 0, 0
    while tn < t:
        tt = tn+D if tn+D < t else t
        dyn = yn**2 - tn**4+2*tn
        yn = Y_in(tt, tn, yn, dyn, tt-tn, l)
        tn = tt
    return yn
