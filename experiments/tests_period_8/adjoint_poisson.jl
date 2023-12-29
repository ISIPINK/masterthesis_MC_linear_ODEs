using BenchmarkTools

using LinearAlgebra
function Y(t, sig, A::Function, f::Function, y0) #tail
    (sol = zero(y0); W = I; s = t + log(rand()) ./ sig)
    while 0 < s
        sol += W * f(s) ./ sig
        W += W * A(s) ./ sig
        s += log(rand()) ./ sig
    end
    sol + W * y0
end

function Yadj(t, sig, A::Function, f::Function, y0, v) # unbiased v'*y
    (sol = 0; s = t + log(rand()) ./ sig)
    while 0 < s
        sol += dot(v, f(s)) ./ sig
        v += v * A(s) ./ sig
        s += log(rand()) ./ sig
    end
    sol + dot(v, y0)
end

y0 = [1.0, 0.0]
v = [1.0 1.0]
A(s) = [1 0.0; 1.0 1]
f(s) = zero(y0)
sig = 1.0
t = 1.0
sol(s) = [exp(s); exp(s)]
soladj(s) = 2 * exp(s)
nsim = 10^5
println(size(v))
@benchmark y = sum(Y(t, sig, A, f, y0) for i in 1:nsim) / nsim
y = sum(Y(t, sig, A, f, y0) for i in 1:nsim) / nsim
println(y - sol(t))

@benchmark yadj = sum(Yadj(t, sig, A, f, y0, v) for i in 1:nsim) / nsim
yadj = sum(Yadj(t, sig, A, f, y0, v) for i in 1:nsim) / nsim
println(yadj - soladj(t))
