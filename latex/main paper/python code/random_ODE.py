from random import random as U
from math import exp
def X(t, a):
    if t < 1: return 1+a*X(U()*t, a) if U() < t else 1
    return 1+t*a*X(U()*t, a)
def eY(t): return X(t, U())
def eY2(t):
    A = U()
    return X(t, A)*X(t, A)
t, nsim = 3, 10**4
sol = sum(eY(t) for _ in range(nsim))/nsim
sol2 = sum(eY2(t) for _ in range(nsim))/nsim
s = exp(t)/t - 1/t              # analytic solution
s2 = exp(2*t)/(2*t) - 1/(2*t)   # analytic solution
print(f"E(Y({t}))   is approx {sol},%error = {(sol - s)/s}")
print(f"E(Y^2({t})) is approx {sol2},%error = {(sol2 - s2)/s2}")
# E(Y(3))   is approx 6.5683, %error = 0.0324
# E(Y^2(3)) is approx 64.5843, %error = -0.0370
