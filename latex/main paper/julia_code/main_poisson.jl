function Y(t, sig, A::Function, y0)
    (s = -log(rand()) / sig; sol = y0)
    while s < t
        sol += A(s) * sol ./ sig
        s -= log(rand()) / sig
    end
    sol
end