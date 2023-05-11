import numpy as np
import random
def triangle_scale_in_para(time, pos):
    xx = np.sqrt(1-time) - abs(pos)
    tt = abs(1-abs(pos)**2-time)
    return np.sqrt(tt) if np.sqrt(tt) < xx else xx
# requires precomputed triangle_sample
def sample_recursive_para(accuracy=0.01, scale_mul=0.9):
    time, pos = 0, 0
    scale = triangle_scale_in_para(time, pos)
    while scale > accuracy:
        scale *= scale_mul
        dtime, dpos = random.sample(triangle_sample, 1)[0]
        dtime, dpos = (scale**2)*dtime, scale*dpos
        pos += dpos
        time += dtime
        scale = triangle_scale_in_para(time, pos)
    return (time, pos)
