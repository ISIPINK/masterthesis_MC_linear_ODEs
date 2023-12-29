function Yadj(t, sig, A::Function, f::Function, y0, v) # unbiased v'*y
    (sol = 0; s = t + log(rand()) ./ sig)
    while 0 < s
        sol += dot(v, f(s)) ./ sig
        v += v * A(s) ./ sig
        s += log(rand()) ./ sig
    end
    sol + dot(v, y0)
end