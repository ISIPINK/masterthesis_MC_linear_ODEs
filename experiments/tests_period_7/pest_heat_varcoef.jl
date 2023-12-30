using Distributions
using Dates
using Plots

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


# following should holdl: ut = uxx + au +f  
function u(x, t)
    # sleep(Microsecond(100))  #simulating expensive function call
    return (x * t)^2
end

function f(x, t)
    # sleep(Microsecond(100))  #simulating expensive function call
    return -2 * t^2 + 2 * x^2 * t + 10 * (x * t)^3
end


function a(x, t)
    # sleep(Microsecond(100))  #simulating expensive function call
    return -10 * x * t
end

yvar(x, t, Δx, nsim, a0, am) = sum(Yvar(x, t, Δx, a0, am, u, f, a) for _ in 1:nsim) / nsim

a0 = 10.0
am = 10.0
x = 0.5
t = 1.0
Δx = 0.01
nsim = 10^4

println("error = $(yvar(x, t, Δx, nsim,a0,am) - u(x, t))")

@benchmark yvar(x, t, Δx, nsim, a0)

Profile.clear()
@profile yvar(x, t, Δx, nsim, a0)


pprof()


struct hop
    sourcepoints::AbstractArray
    steps::Int64
    finished::Bool
end

function YvarPath(x, t, dx, a0)
    siginv = 1 / (2 / dx^2 + a0)
    g = Geometric(1 - 2 * siginv / dx^2)
    ee = Exponential(siginv)
    sourcejump = rand(g)
    source_points = [(x, t, sourcejump)]
    while true
        t -= rand(ee)
        t <= 0 && return (source_points, (x, t, sourcejump))

        if sourcejump != 0
            x += rand(Bool) ? dx : -dx
            sourcejump -= 1
            return x <= 0 ? (source_points, (x, t, sourcejump)) :
                   x >= 1 ? (source_points, (x, t, sourcejump)) : continue

        else
            sourcejump = rand(g)
            push!(source_points, (x, t, sourcejump))
        end
    end
end

using Plots

xx = repeat([0.5], 2 * 10^1)
x = 0.5
t = 0.15
Δx = 0.001
a0 = 30

tpaths = YvarPath.(xx, t, Δx, a0)
tpaths[1]
p = plot()

colors = [:red, :green, :blue, :yellow, :purple, :cyan, :magenta, :orange, :pink, :teal, :violet, :lime, :gold, :silver, :maroon, :navy]

for (i, tpath) in enumerate(tpaths)
    xxpath1 = [point[1] for point in tpath[1]]
    yypath1 = [point[2] for point in tpath[1]]

    push!(xxpath1, tpath[2][1])
    push!(yypath1, tpath[2][2])

    plot!(p, yypath1, xxpath1, color=colors[i%length(colors)+1], label="")
    plot!(p, yypath1, xxpath1, seriestype=:scatter, color=colors[i%length(colors)+1], label="")
end

display(p)

xxend = [tpath[2][1] for tpath in tpaths]
yyend = [tpath[2][2] for tpath in tpaths]

plot(xxend, yyend,
    seriestype=:scatter, xlims=(-0.1, 1.1), ylims=(-0.1, 1.1))


