using Distributions
using Dates
using Plots

using BenchmarkTools
using Profile
using PProf

function Yvar(x, t, Δx, a0)
    binv = 1 / (2 / Δx^2 - a0)
    g = Geometric(binv)
    ee = Exponential(binv)
    sol = 0
    put = 1
    xold = x
    sourcejump = rand(g)
    common_multiplier = 2 * (binv / (1 - a0 * Δx^2 / 2)) / Δx^2
    while true
        xold = x
        sourcejump -= 1
        if sourcejump == 0
            sourcejump = rand(g) + 1
            tt = t - rand(ee)
            sol += tt > 0 ? put * f(xold, tt) : 0
        end

        t -= rand(ee)
        if t < 0
            return put * u(xold, 0) + sol
        end

        if rand() < 1 - a0 * Δx^2 / 2
            x += rand(Bool) ? Δx : -Δx
            put *= common_multiplier # note that this can easly be calculated for multiple loops
        else
            put *= (a(x, t) - a0) * binv / (a0 * Δx^2 / 2) # this has only be done O(1) in an estimator
        end

        return x < 0 ? put * u(0, t) + sol :
               x > 1 ? put * u(1, t) + sol : continue

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
t = 2
nsim = 10^4
Δx = 0.05

println("error = $(yvar(x, t, Δx, nsim,a0) - u(x, t))")

@benchmark yvar(x, t, Δx, nsim, a0)

Profile.clear()
@profile yvar(x, t, Δx, nsim, a0)


pprof()