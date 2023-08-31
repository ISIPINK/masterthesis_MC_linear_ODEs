from random import random as U
from math import exp
def Y(t, a):
    if t < 1: return 1+a*Y(U()*t, a) if U() < t else 1
    return 1+t*a*Y(U()*t, a)
def YU(t): return Y(t, U())
def Y2U(t):
    a = U()
    return Y(t, a)*Y(t, a)
t, nsim = 3, 10**4
sol = sum(YU(t) for _ in range(nsim))/nsim
sol2 = sum(Y2U(t) for _ in range(nsim))/nsim
s = exp(t)/t - 1/t              # analytic solution
s2 = exp(2*t)/(2*t) - 1/(2*t)   # analytic solution
print(f"E(YU({t}))   is approx {sol},%error = {(sol - s)/s}")
print(f"E(Y2U({t})) is approx {sol2},%error = {(sol2 - s2)/s2}")
# E(YU(3))   is approx 6.5683, %error = 0.0324
# E(Y2U(3)) is approx 64.5843, %error = -0.0370
