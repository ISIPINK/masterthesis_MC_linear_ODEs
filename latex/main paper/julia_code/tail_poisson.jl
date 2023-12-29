using LinearAlgebra
function Y(t, sig, A::Function, f::Function, y0) 
    (sol = zero(y0); W = I; s = t + log(rand()) ./ sig)
    while 0 < s
        sol += W * f(s) ./ sig
        W += W * A(s) ./ sig
        s += log(rand()) ./ sig
    end
    sol + W * y0
end