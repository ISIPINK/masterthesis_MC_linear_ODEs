using Distributions
using Dates
using Plots
using Random

using BenchmarkTools
using Profile
using PProf

function Yvar(x, t, dx, a0, am, u_bound::Function, f::Function, a::Function)
    siginv = 1 / (2 / dx^2 + a0)
    (p_source = am / (am + 2 / dx^2); p_avg = 1 - p_source)
    (geom = Geometric(p_source); expon = Exponential(siginv))
    (sol = 0; w = 1)
    sterm_counter = rand(geom)
    while true
        t -= rand(expon)
        t <= eps() && return sol + w * u_bound(x, 0)
        if sterm_counter != 0
            x += rand(Bool) ? dx : -dx
            w *= 2 * siginv / (dx^2 * p_avg)
            sterm_counter -= 1
            return x - eps() <= 0 ? w * u_bound(0, t) + sol :
                   x + eps() >= 1 ? w * u_bound(1, t) + sol : continue
        else # this is only done O(am tstart) times in an estimator
            sterm_counter = rand(geom)
            sol += w * f(x, t) * siginv / p_source
            w *= (a(x, t) + a0) * siginv / p_source
        end
    end
end

function genPath(x, t, dx, a0, am)
    (siginv = 1 / (2 / dx^2 + a0); p_source = am / (am + 2 / dx^2))
    (geom = Geometric(p_source); expon = Exponential(siginv))
    sterm_counter = rand(geom)
    spoints = [(x, t, sterm_counter)] #maybe other data struct
    while true
        t -= rand(expon)
        t <= eps() && return (spoints, (x, t, sterm_counter))
        if sterm_counter != 0
            x += rand(Bool) ? dx : -dx
            sterm_counter -= 1
            return x - eps() <= 0 ? (spoints, (x, t, sterm_counter)) :
                   x + eps() >= 1 ? (spoints, (x, t, sterm_counter)) :
                   continue
        else # this is only done O(am tstart) times in an estimator
            sterm_counter = rand(geom)
            push!(spoints, (x, t, sterm_counter))
        end
    end
end

function YvarPath(x, t, dx, a0, am, u_bound::Function, f::Function, a::Function)
    spoints, exit = genPath(x, t, dx, a0, am)
    (siginv = 1 / (2 / dx^2 + a0); p_source = am / (am + 2 / dx^2))
    w_multiplier = 2 * siginv / (dx^2 * (1 - p_source))
    (sol = 0; w = w_multiplier^spoints[1][3])
    for (x, t, sterm_counter) in spoints[2:end]
        sol += w * f(x, t) * siginv / p_source
        w *= (a(x, t) + a0) * siginv / p_source
        w *= w_multiplier^sterm_counter
    end
    (x, t, sterm_counter) = exit # small w can produce NaNs
    w /= sterm_counter > 0 && abs(w) > eps() ? w_multiplier^sterm_counter : 1
    t >= eps() ? sol + w * u_bound(x, t) : sol + w * u_bound(x, 0)
end

function YvarPathMemo(x, t, dx, a0, am, u_bound::Function, f::Function, a::Function, path)
    spoints, exit = path
    (siginv = 1 / (2 / dx^2 + a0); p_source = am / (am + 2 / dx^2))
    w_multiplier = 2 * siginv / (dx^2 * (1 - p_source))
    (sol = 0; w = w_multiplier^spoints[1][3])
    for (x, t, sterm_counter) in spoints[2:end]
        sol += w * f(x, t) * siginv / p_source
        w *= (a(x, t) + a0) * siginv / p_source
        w *= w_multiplier^sterm_counter
    end
    (x, t, sterm_counter) = exit # small w can produce NaNs
    w /= sterm_counter > 0 && abs(w) > eps() ? w_multiplier^sterm_counter : 1
    t >= eps() ? sol + w * u_bound(x, t) : sol + w * u_bound(x, 0)
end

function YvarPathMemoExp(x, t, dx, a0, am, u_bound::Function, f::Function, a::Function, path)
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
    t >= eps() ? sol + w * u_bound(x, t) : sol + w * u_bound(x, 0)
end


# following should holdl: ut = uxx + au +f  
function u(x, t)
    # sleep(Microsecond(100))  #simulating expensive function call
    return (x * t)^2
end

function f(x, t)
    # sleep(Microsecond(100))  #simulating expensive function call
    return -2 * t^2 + 2 * x^2 * t - 10 * (x * t)^3
end


function a(x, t)
    # sleep(Microsecond(100))  #simulating expensive function call
    return 10 * x * t
end

yvar(x, t, Δx, nsim, a0, am) = sum(Yvar(x, t, Δx, a0, am, u, f, a) for _ in 1:nsim) / nsim
yvarpath(x, t, Δx, nsim, a0, am) = sum(YvarPath(x, t, Δx, a0, am, u, f, a) for _ in 1:nsim) / nsim
yvarpathmemo(x, t, Δx, nsim, a0, am, paths) = sum(YvarPathMemo(x, t, Δx, a0, am, u, f, a, path) for path in paths) / nsim
yvarpathmemoexp(x, t, Δx, nsim, a0, am, paths) = sum(YvarPathMemoExp(x, t, Δx, a0, am, u, f, a, path) for path in paths) / nsim

# am = 100 , nsim = 10^6 -> memory estimate = 400 MiB linear scaling in nsim, am has weird scaling for large Δx
a0 = 0.0
am = 10.0
x = 0.5
t = 1.0
Δx = 0.01
nsim = 10^5

Random.seed!(4499)
println("error = $(yvar(x, t, Δx, nsim,a0,am) - u(x, t))")
Random.seed!(4499)
println("error = $(yvarpath(x, t, Δx, nsim,a0,am) - u(x, t))")
Random.seed!(4499)
xx = [x for _ in 1:nsim]
paths = genPath.(xx, t, Δx, a0, am);
println(Base.summarysize(paths) / 1024^2, " megabytes")
println("error = $(yvarpathmemo(x, t, Δx, nsim,a0,am,paths) - u(x, t))")
println("error = $(yvarpathmemoexp(x, t, Δx, nsim,a0,am,paths) - u(x, t))")

Random.seed!(4499)
@benchmark yvar(x, t, Δx, nsim, a0, am)
Random.seed!(4499)
@benchmark yvarpath(x, t, Δx, nsim, a0, am)
Random.seed!(4499)
@benchmark paths = genPath.(xx, t, Δx, a0, am)

@benchmark yvarpathmemo(x, t, Δx, nsim, a0, am, paths)
@benchmark yvarpathmemoexp(x, t, Δx, nsim, a0, am, paths)

path = genPath(x, t, Δx, a0, am)
@benchmark Yvar(x, t, Δx, a0, am, u, f, a)
@benchmark YvarPath(x, t, Δx, a0, am, u, f, a)
@benchmark YvarPathMemo(x, t, Δx, a0, am, u, f, a, path)

Profile.clear()
@profile yvar(x, t, Δx, nsim, a0, am)
pprof()

Profile.clear()
@profile yvarpath(x, t, Δx, nsim, a0, am)
pprof()

Profile.clear()
@profile yvar(x, t, Δx, nsim, a0, am)
Random.seed!(4499)
xx = [x for _ in 1:nsim]
@profile genPath.(xx, t, Δx, a0, am)
pprof()

Profile.clear()
Random.seed!(4499)
xx = [x for _ in 1:nsim]
paths = genPath.(xx, t, Δx, a0, am)
@profile yvarpathmemo(x, t, Δx, nsim, a0, am, paths)
pprof()
# we think we allocating to much

Random.seed!(4499)
xx = [x for _ in 1:nsim]
paths = genPath.(xx, t, Δx, a0, am)
Profile.clear()
@profile yvarpathmemoexp(x, t, Δx, nsim, a0, am, paths)
@profile yvarpathmemo(x, t, Δx, nsim, a0, am, paths)
pprof()