function Y(x, t, Δx)
    xold = x
    t += Δx^2 * log(rand()) / 2
    x += rand(Bool) ? Δx : -Δx
    return t < 0 ? u(xold, 0) :
           x < 0 ? u(0, t) :
           x > 1 ? u(1, t) : Y(x, t, Δx)
end

function Ytail(x, t, Δx)
    while true
        xold = x
        t += Δx^2 * log(rand()) / 2
        x += rand(Bool) ? Δx : -Δx
        return t < 0 ? u(xold, 0) :
               x < 0 ? u(0, t) :
               x > 1 ? u(1, t) : continue
    end
end


y(x, t, Δx, nsim) = sum(Y(x, t, Δx) for _ in 1:nsim) / nsim
ytail(x, t, Δx, nsim) = sum(Ytail(x, t, Δx) for _ in 1:nsim) / nsim

u(x, t) = 2x * t + x^3 / 3 # needs to satisfy the heat equation
# u(x, t) = exp(-t) * sin(x)
x = 0.7
t = 0.8
nsim = 10^4
Δx = 0.05
println("error = $(y(x, t, Δx, nsim) - u(x, t))")
println("errortail = $(ytail(x, t, Δx, nsim) - u(x, t))")

using BenchmarkTools

@benchmark y(x, t, Δx, nsim)
@benchmark ytail(x, t, Δx, nsim)



function Ysource(x, t, Δx)
    xold = x
    tt = t + Δx^2 * log(rand()) / 2  #for the source term but can also be t
    t += Δx^2 * log(rand()) / 2
    x += rand(Bool) ? Δx : -Δx
    return t < 0 ? u(xold, 0) :
           (x < 0 ? u(0, t) :
            x > 1 ? u(1, t) :
            Ysource(x, t, Δx)) +
           (rand() < Δx^2 / 2 ? f(xold, tt) : 0)
end

using Distributions

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
        tmp = f(xold, tt)
    end
    t += Δx^2 * log(rand()) / 2
    x += rand(Bool) ? Δx : -Δx
    return t < 0 ? u(xold, 0) :
           (x < 0 ? u(0, t) :
            x > 1 ? u(1, t) :
            Ysourcejump(x, t, Δx, sourcejump - 1)) + tmp
end

ysource(x, t, Δx, nsim) = sum(Ysource(x, t, Δx) for _ in 1:nsim) / nsim
ysourcejump(x, t, Δx, nsim) = sum(Ysourcejump(x, t, Δx, -1) for _ in 1:nsim) / nsim

u(x, t) = x^2 * t^2 # needs to satisfy the heat equation
f(x, t) = -2 * t^2 + 2 * x^2 * t # needs to satisfy the heat equation 
x = 0.7
t = 0.7
nsim = 10^4
Δx = 0.05
println("error = $(ysource(x, t, Δx, nsim) - u(x, t))")
println("error = $(ysourcejump(x, t, Δx, nsim) - u(x, t))")

using Plots
g = Geometric(Δx^2 / 2)
histogram(rand(g, 10^5), normalize=:pdf)

using BenchmarkTools

@benchmark y(x, t, Δx, nsim)
@benchmark ytail(x, t, Δx, nsim)
