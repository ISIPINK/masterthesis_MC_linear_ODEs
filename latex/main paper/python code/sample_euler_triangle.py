import numpy as np
def in_triangle(time, pos): return 1-time > abs(pos)
def sample_euler_triangle(dt=0.001):
    pos, time = 0, 0
    while in_triangle(time, pos):
        pos += np.random.normal(0, 1) * np.sqrt(dt)
        time += dt
    return (time, pos)
