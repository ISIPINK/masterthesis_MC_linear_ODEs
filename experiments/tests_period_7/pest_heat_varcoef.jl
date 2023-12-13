using Distributions
using Dates

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
    while true
        xold = x
        sourcejump -= 1
        if sourcejump == 0
            sourcejump = rand(g) + 1
            tt = t - rand(ee)
            sol += tt > 0 ? put * f(xold, tt) : 0
        end

        t -= rand(ee)
        if rand() < 1 - a0 * Δx^2 / 2
            x += rand(Bool) ? Δx : -Δx
        else
            put *= a0 * a(x, t) * binv * Δx^2 / 2
        end

        return t < 0 ? put * u(xold, 0) + sol :
               x < 0 ? put * u(0, t) + sol :
               x > 1 ? put * u(1, t) + sol : continue

    end

end

yvar(x, t, Δx, nsim, a0) = sum(Yvar(x, t, Δx, a0) for _ in 1:nsim) / nsim

# following should holdl: ut = uxx + (a+a0) u +f  
function u(x, t)
    # sleep(Microsecond(100))  #simulating expensive function call
    return (x * t)^2
end

function f(x, t)
    # sleep(Microsecond(100))  #simulating expensive function call
    return -2 * t^2 + 2 * x^2 * t - (x * t)^3 - (x * t)^2
end

function a(x, t)
    # sleep(Microsecond(100))  #simulating expensive function call
    return x * t
end

x = 0.7
t = 2
nsim = 10^4
Δx = 0.05
a0 = 1
println("error = $(yvar(x, t, Δx, nsim,a0) - u(x, t))")