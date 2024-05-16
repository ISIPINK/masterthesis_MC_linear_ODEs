using Plots
using Random

function Y(t, sig, A::Function, f::Function, y0)
    (s = -log(rand()) / sig; sol = y0)
    while s < t
        sol += (A(s) * sol .+ f(s)) ./ sig
        s -= log(rand()) / sig
    end
    sol
end

y0 = 1
A(t) = 1
f(t) = 0
sig = 100
nsim = 20

tt = 0:0.001:1
yys = []
p = plot(tt, exp.(tt), label="exp(t)", lw=8, color=:red, ylim=(0.95, 3))

Random.seed!(rand(1:10000))
for _ in 1:nsim
    yy = []
    s = rand(1:1000000)
    for t in tt
        Random.seed!(s)
        push!(yy, Y(t, sig, A, f, y0))
    end
    push!(yys, yy)
    plot!(p, tt, yy, label="", xlabel="t", ylabel="Y(t)", title="Poisson process", lw=2, alpha=0.3)
end
plot!(p, tt, sum(yys) / length(yys), label="avg", xlabel="t", ylabel="Y(t)", title="Poisson process", lw=4, color=:blue)
display(p)