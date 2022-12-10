from math import sqrt

# triangle 45° ends in time 1
def out_boundary(time,pos):
    return 1-time < abs(pos)

# scale time 0.5 and space 1/sqrt(2)
def out_boundary2(time,pos):
    return 1/2-time < (sqrt(2)/2)*abs(pos)


if __name__ == "__main__":
    #sanity checks
    print(dis_to_boundary(0.2,0.5) )
