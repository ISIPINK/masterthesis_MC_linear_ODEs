from math import sqrt
from abc import ABC, abstractmethod

class Boundary(ABC):

    @abstractmethod
    def get_scale(self,pos,time):
        """
        gets a scale such that scale,scale**2 triangle fits
        picture would help
        """
        pass

    @abstractmethod
    def is_out(self,pos,time):
        """
        tells if a point is outside the boundary
        """

class Regular_cone_boundary(Boundary):
    """
    A picture would be clearer ...
    """
    def is_out(self,pos,time):
        return 1-time < abs(pos)

    def get_scale(self,pos,time):
        return 1-time - abs(pos)

class Scaled_cone_boundary(Boundary):
    """
    this one is just for testing
    """
    def is_out(self,pos,time):
        return 1/2-time < (sqrt(2)/2)*abs(pos)

    def get_scale(self,pos,time):
        return 0.5-time - (sqrt(2)/2)*abs(pos)

class Parabolic_boundary(Boundary):
    """
    parabool that goes through (-1,0), (0,1), (1,0) (x,time)
    """
    def is_out(self,pos,time):
        return 1-time < abs(pos)**2

    def get_scale(self,pos,time):
        xx = sqrt(1-time)- abs(pos)
        tt = 1-abs(pos)**2-time
        return tt if tt**2>xx else xx

