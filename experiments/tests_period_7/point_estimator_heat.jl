@inline U() = rand()
@inline B(p) = U() < p
u(x, t) = 2x * t + x^3 / 3 # needs to satisfy the heat equation

# recursive version
function Y(x, t, Δx)
    S = t + Δx^2 * log(U()) / 2
    xnew = x + Δx * (2 * B(0.5) - 1)
    return S < 0 ? u(x, 0) :
           xnew < 0 ? u(0, S) :
           xnew > 1 ? u(1, S) : Y(xnew, S, Δx)
end

# u(x,0) here evaluated at xnew
function Y(x, t, Δx)
    while true
        t += Δx^2 * log(U()) / 2
        x += Δx * (2 * B(0.5) - 1)
        return t < 0 ? u(x, 0) :
               x < 0 ? u(0, t) :
               x > 1 ? u(1, t) : continue
    end
end

y(x, t, Δx, nsim) = sum(Y(x, t, Δx) for _ in 1:nsim) / nsim

x = 0.7
t = 0.8
nsim = 10^4
Δx = 0.05
println("error = $(y(x, t, Δx, nsim) - u(x, t))")




