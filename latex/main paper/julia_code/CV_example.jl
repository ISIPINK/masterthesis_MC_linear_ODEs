function Y(t) # correct for t<1
    u = rand()
    1 + t + t^2 / 2 + (rand() < t ? Y(u * t) - 1 - u * t : 0)
end