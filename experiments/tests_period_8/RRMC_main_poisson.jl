function Y_in(t, t0, sig, A::Function, f::Function, y0)
    (s = -log(rand()) / sig; sol = y0)
    while s + t0 < t
        sol += (A(s + t0) * sol .+ f(s + t0)) ./ sig
        s -= log(rand()) / sig
    end
    sol
end

function Y_outer(T, DT, sig, A, f, y0) # step size slow recursion
    y, t = y0, 0.0
    while t < T
        tt = t + DT < T ? t + DT : T
        y = Y_in(tt, t, sig, A, f, y)
        t = tt
    end
    return y
end

using Plots
using Statistics
sig = 1.0
A(s) = s + 1
f(s) = -s^3 - s^2 + s - 1
q = 1.0
t = 1.0
sol(s) = s^2 + 1
nsim1 = 10^3
DTs = exp10.(range(-1, stop=-2, length=100))
# YY = [abs.(Y_outer(t, DT,sig,A,f,q).-sol(t)) for DT in DTs]
t0 = 0.5
YY = [abs.(Y_in(DT + t0, t0, sig, A, f, sol(t0)) .- sol(DT + t0)) for DT in DTs]
DT = 0.1
println(mean(Y_outer(t, DT, sig, A, f, q) .- sol(t) for _ in 1:nsim1))


plot(DTs, YY, st=:scatter, xscale=:log10, yscale=:log10, label="Y(t)")
plot!(DTs, DTs .^ 2, label="dt^2")
plot!(DTs, DTs .^ 1, label="dt")

