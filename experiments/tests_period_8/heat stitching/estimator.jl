using Distributions
include("path_generation.jl")

function YvarPathMemoExp(path, dx, a0, am, u_bound::Function, f::Function, a::Function)
    spoints, exit = path
    (siginv = 1 / (2 / dx^2 + a0); p_source = am / (am + 2 / dx^2))
    lw_multiplier = log(2 * siginv / (dx^2 * (1 - p_source)))
    (sol = 0; w = exp(spoints[1][3] * lw_multiplier))
    for (x, t, sterm_counter) in spoints[2:end]
        sol += w * f(x, t) * siginv / p_source
        w *= (a(x, t) + a0) * siginv / p_source
        w *= exp(sterm_counter * lw_multiplier)
    end
    (x, t, sterm_counter) = exit # small w can produce NaNs
    w /= sterm_counter > 0 && abs(w) > eps() ? exp(sterm_counter * lw_multiplier) : 1
    sol + w * u_bound(x, t)
end

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