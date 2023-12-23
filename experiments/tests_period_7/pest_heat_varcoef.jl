using Distributions
using Dates
using Plots

using BenchmarkTools
using Profile
using PProf

function Yvar(x, t, dx, a0)
    siginv = 1 / (2 / dx^2 - a0)
    g = Geometric(a0 * dx^2 / 2)
    ee = Exponential(siginv)
    (sol = 0; w = 1)
    sourcejump = rand(g)
    while true
        t -= rand(ee)
        t <= 0 && return sol + w * u(x, 0)

        if sourcejump != 0
            x += rand(Bool) ? dx : -dx
            w *= 2 * (siginv / (1 - a0 * dx^2 / 2)) / dx^2
            sourcejump -= 1
            return x <= 0 ? w * u(0, t) + sol :
                   x >= 1 ? w * u(1, t) + sol : continue

        else # this is only done O(tstart) times in an estimator
            sourcejump = rand(g)
            sol += w * f(x, t) * siginv / (a0 * dx^2 / 2)
            w *= (a(x, t) - a0) * siginv / (a0 * dx^2 / 2)
        end
    end
end

yvar(x, t, Δx, nsim, a0) = sum(Yvar(x, t, Δx, a0) for _ in 1:nsim) / nsim

# following should holdl: ut = uxx + au +f  
function u(x, t)
    # sleep(Microsecond(100))  #simulating expensive function call
    return (x * t)^2
end

function f(x, t)
    # sleep(Microsecond(100))  #simulating expensive function call
    return -2 * t^2 + 2 * x^2 * t - (x * t)^3
end


function a(x, t)
    # sleep(Microsecond(100))  #simulating expensive function call
    return x * t
end

a0 = 1
x = 0.5
t = 1
nsim = 10^4
Δx = 0.05

println("error = $(yvar(x, t, Δx, nsim,a0) - u(x, t))")

@benchmark yvar(x, t, Δx, nsim, a0)

Profile.clear()
@profile yvar(x, t, Δx, nsim, a0)


pprof()