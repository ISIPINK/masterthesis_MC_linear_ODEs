using Revise
includet("path_generation.jl")
includet("estimator.jl")
# following should hold: ut = uxx + au +f  
u(x, t) = (x * t)^2
f(x, t) = -2 * t^2 + 2 * x^2 * t - 10 * (x * t)^3
a(x, t) = 10 * x * t

a0 = 1.0
am = 5.0
x = 0.0
t = 0.8
Δx = 0.01
nsim = 10^4
xx = [x for _ in 1:nsim]

yvarpathmemoexp(Δx, nsim, a0, am, paths) = sum(YvarPathMemoExp(path, Δx, a0, am, u, f, a) for path in paths) / nsim
paths = []
for _ in 1:nsim
    path1 = genPath(x, t, Δx, a0, am, (x, t) -> t >= 0.5)
    path2 = genPath(x, t, Δx, a0, am, (x, t) -> t >= 0.5)
    push!(paths, stitch(path1, path2))
end
println("error = $(yvarpathmemoexp(Δx, nsim,a0,am,paths) - u(x, t))")