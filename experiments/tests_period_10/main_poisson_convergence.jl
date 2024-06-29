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


function plot_ex(sig, nsim)
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
        plot!(p, tt, yy, label="", xlabel="t", ylabel="Y(t)", lw=2, alpha=0.3)
    end
    plot!(p, tt, sol.(tt), label="sol(t)", lw=8, color=:red)
    plot!(p, tt, sum(yys) / length(yys), label="avg", xlabel="t", ylabel="Y(t)", lw=4, color=:blue)
    plot!(p, title="nsim=$nsim, sig=$sig")
    return p
end

begin
    y0 = 1
    Ap(t) = (t < 0.5) ? 1 : -1
    A(t) = Ap(t - floor(t))
    solp(t) = (t < 0.5) ? exp(t) : exp(1 - t)
    sol(t) = solp(t - floor(t))

    f(t) = 0

    Random.seed!(29)
    p1 = plot_ex(20, 40)
    p2 = plot_ex(200, 4)
    p = plot(p1, p2, layout=(1, 2), size=(900, 350),
        left_margin=5mm, right_margin=5mm, bottom_margin=5mm, top_margin=5mm)
    display(p)
end