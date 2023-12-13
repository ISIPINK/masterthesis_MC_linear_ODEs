using Distributions
using Dates

using BenchmarkTools
using Profile
using PProf

function Ysource(x, t, Δx)
    ee = Exponential(Δx^2 / 2)
    sol = 0
    xold = x
    while true
        xold = x
        if rand() < Δx^2 / 2
            tt = t - rand(ee)  #for the source term but can also be t
            sol += tt > 0 ? f(xold, tt) : 0
        end
        t -= rand(ee)
        x += rand(Bool) ? Δx : -Δx
        return t < 0 ? u(xold, 0) + sol :
               x < 0 ? u(0, t) + sol :
               x > 1 ? u(1, t) + sol : continue
    end
end


function Ysourcejump(x, t, Δx, sourcejump)
    tmp = 0
    xold = x
    if sourcejump == -1
        g = Geometric(Δx^2 / 2)
        sourcejump = rand(g)
    end
    if sourcejump == 0
        g = Geometric(Δx^2 / 2)
        sourcejump = rand(g) + 1
        tt = t + Δx^2 * log(rand()) / 2
        tmp = tt > 0 ? f(xold, tt) : 0
    end
    t += Δx^2 * log(rand()) / 2
    x += rand(Bool) ? Δx : -Δx
    return t < 0 ? u(xold, 0) :
           (x < 0 ? u(0, t) :
            x > 1 ? u(1, t) :
            Ysourcejump(x, t, Δx, sourcejump - 1)) + tmp
end

function Ysourcejumptail(x, t, Δx)
    g = Geometric(Δx^2 / 2)
    ee = Exponential(Δx^2 / 2)
    sol = 0
    xold = x
    sourcejump = rand(g)
    while true
        xold = x
        sourcejump -= 1
        if sourcejump == 0
            sourcejump = rand(g) + 1
            tt = t - rand(ee)
            sol += tt > 0 ? f(xold, tt) : 0
        end
        t -= rand(ee)
        x += rand(Bool) ? Δx : -Δx
        return t < 0 ? u(xold, 0) + sol :
               x < 0 ? u(0, t) + sol :
               x > 1 ? u(1, t) + sol : continue
    end

end

ysource(x, t, Δx, nsim) = sum(Ysource(x, t, Δx) for _ in 1:nsim) / nsim
ysourcejump(x, t, Δx, nsim) = sum(Ysourcejump(x, t, Δx, -1) for _ in 1:nsim) / nsim
ysourcejumptail(x, t, Δx, nsim) = sum(Ysourcejumptail(x, t, Δx) for _ in 1:nsim) / nsim
function u(x, t)
    # sleep(Microsecond(100))  #simulating expensive function call
    return x^2 * t^2
end

function f(x, t)
    # sleep(Microsecond(100))  #simulating expensive function call
    return -2 * t^2 + 2 * x^2 * t
end
x = 0.7
t = 2
nsim = 10^4
Δx = 0.05
println("error = $(ysource(x, t, Δx, nsim) - u(x, t))")
# println("error = $(ysourcejump(x, t, Δx, nsim) - u(x, t))")
println("error = $(ysourcejumptail(x, t, Δx, nsim) - u(x, t))")



@benchmark ysource(x, t, Δx, nsim)
@benchmark ysourcejump(x, t, Δx, nsim)
@benchmark ysourcejumptail(x, t, Δx, nsim)


Profile.clear()
@profile ysource(x, t, Δx, nsim)
@profile ysourcejumptail(x, t, Δx, nsim)

pprof()

