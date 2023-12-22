function Y(t) # correct for t<1
    u = rand()
    rand() < t ? 1 + (Y(u * t) + Y(u * t)) / 2 : 1
end