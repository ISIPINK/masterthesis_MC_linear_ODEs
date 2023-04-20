from random import random as U
def Y_in(t, tn, yn, dyn, h, l):
    sol = yn  # initial conditon
    sol += t**2-tn**2 - (t**5-tn**5)/5  # source
    sol += (t-tn)*yn**2  # 0 order 
    sol += 2*((t**2-tn**2)/2 - tn*(t-tn))*yn*dyn  # 1 order 
    if U()*l < (t-tn)/h:
        S = tn + U()*(t-tn)  # \sim Uniform(T,t)
        sol += l*h*(Y_in(S, tn, yn, dyn, h, l)*
            Y_in(S, tn, yn, dyn, h, l) - yn**2-2*(S-tn)*yn*dyn)
    return sol
def Y_out(t, h, l):
    yn, tn = 0, 0
    while tn < t:
        tt = tn+h if tn+h < t else t
        dyn = yn**2 - tn**4+2*tn
        yn = Y_in(tt, tn, yn, dyn, tt-tn, l)
        tn = tt
    return yn
