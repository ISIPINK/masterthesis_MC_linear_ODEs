function X(t, a)
    (q = [1, 0]; A = [a 0; 1 a])
    (sol = q; W = [1.0 0.0; 0.0 1.0])
    while rand() < t
        W = W * A
        sol += W * q
        t *= rand()
    end
    sol
end