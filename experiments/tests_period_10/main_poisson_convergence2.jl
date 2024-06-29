using Plots
using Random
using Plots.PlotMeasures

function Y(t, sig, A::Function, f::Function, y0)
    (s = -log(rand()) / sig; sol = y0)
    while s < t
        sol += (A(s) * sol .+ f(s)) ./ sig
        s -= log(rand()) / sig
    end
    sol
end


function plot_ex(sig, nsim, com)
    tt = 0:0.1:10
    yys = []
    p = plot()

    Random.seed!(rand(1:10000))
    for _ in 1:nsim
        yy = []
        s = rand(1:1000000)
        for t in tt
            Random.seed!(s)
            push!(yy, Y(t, sig, A, f, y0))
        end
        push!(yys, yy)
        plot!(p, tt, [y[com] for y in yy], label="", xlabel="t", ylabel="Y(t)", lw=2, alpha=0.3)
    end
    plot!(p, tt, [s[com] for s in sol.(tt)], label="sol(t)", lw=8, color=:red)
    plot!(p, tt, [s[com] for s in sum(yys) / length(yys)], label="avg", xlabel="t", ylabel="Y(t)", lw=4, color=:blue)
    plot!(p, title="nsim=$nsim, sig=$sig")
    return p
end

begin
    y0 = [1; 1]
    A(t) = [1+cos(t) -cos(t); cos(t) 1-cos(t)]
    sol(t) = [exp(t); exp(t)]

    f(t) = zeros(size(y0))

    Random.seed!(24)
    p1 = plot_ex(20, 40, 1)
    display(p1)
end