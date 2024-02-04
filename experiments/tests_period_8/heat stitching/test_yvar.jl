using Revise
using Plots
using Random
includet("path_generation.jl")
includet("estimator.jl")

# following should hold: ut = uxx + au +f  
u(x, t) = (x * t)^2
f(x, t) = -2 * t^2 + 2 * x^2 * t - 10 * (x * t)^3
a(x, t) = 10 * x * t

u(x, t) = 1.0
f(x, t) = -1.0
a(x, t) = 1.0

Random.seed!(4181)
a0 = 0
am = 10
Δx = 0.01
scales = [sqrt(2.0^(-j)) for j in 0:2:20]
npaths = 20
dpaths = genPathsScalesTriangle(scales, npaths, Δx, a0, am)

x = 0.5
t = 0.15

function squareScale(x, t)
    xx = min(abs(1 - x), abs(x))
    return t < xx^2 ? sqrt(t < 0 ? 0 : t) : xx
end

keys(dpaths)
println(keys(dpaths))
println(squareScale(x, t))

p = plot()
for _ in 1:100
    sol, path = Yvar(x, t, dpaths, squareScale, Δx, a0, am, u, f, a)
    xx = [point[1] for point in path]
    yy = [point[2] for point in path]
    plot!(p, yy, xx, scatter=true, label="")
end
display(p)


nsim = 10^4
sum(Yvar(x, t, dpaths, squareScale, Δx, a0, am, u, f, a) for _ in 1:nsim) / nsim

u(x, t)