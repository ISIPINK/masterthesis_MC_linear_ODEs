from random import random as U
from collections import deque
import numpy as np
def sample_path(t):
    res = deque([t])
    while U() < t:
        t *= U()
        res.append(t)
    return res
def X(t, a) -> np.array:
    q, A = np.array([1.0, 0.0]), np.array([[a, 0.0], [1.0, a]])
    X, path = np.zeros(2), sample_path(t)
    while path:
        t = path[-1]
        X = q + (A @ X if t < 1 else t * A @ X)
        path.pop()
    return X
def sol(t, a, nsim): return sum(X(t, a) for _ in range(nsim))/nsim
print(f"x(1,1) = {sol(1,1,10**3)}")
# x(1,1) = [2.721 2.725]