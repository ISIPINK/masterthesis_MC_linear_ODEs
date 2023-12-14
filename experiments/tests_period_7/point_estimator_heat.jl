function Y(x, t, Δx)
    xold = x
    t += Δx^2 * log(rand()) / 2
    x += rand(Bool) ? Δx : -Δx
    return t <= 0 ? u(xold, 0) :
           x <= 0 ? u(0, t) :
           x >= 1 ? u(1, t) : Y(x, t, Δx)
end

function Ytail(x, t, Δx)
    while true
        xold = x
        t += Δx^2 * log(rand()) / 2
        x += rand(Bool) ? Δx : -Δx
        return t <= 0 ? u(xold, 0) :
               x <= 0 ? u(0, t) :
               x >= 1 ? u(1, t) : continue
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






