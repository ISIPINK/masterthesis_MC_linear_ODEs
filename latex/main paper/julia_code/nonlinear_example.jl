function Y(t) # Y(u)^2 != Y(u) * Y(u) !!!
    t > 2 && error("doesn't support t > 2")
    S1 = rand() * (t - 1) + 1
    rand() < t - 1 ? -1 + Y(S1) * Y(S1) : -1
end # Y(t) = 0 or Y(t) = -1