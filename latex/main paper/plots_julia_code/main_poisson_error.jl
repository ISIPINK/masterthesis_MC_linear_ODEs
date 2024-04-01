using Plots
using Random
using GLM, DataFrames
using Plots.PlotMeasures

function Yplot(t, sig, A::Function, f::Function, y0)
    (s = -log(rand()) / sig; sol = y0)
    path = []
    while s < t
        push!(path, (s, sol))
        sol += (A(s) * sol .+ f(s)) ./ sig
        s -= log(rand()) / sig
    end
    if length(path) > 0
        push!(paths, path)
    end
    sol
end

a = 1
A(s) = [a 0; 1 a]
q = [1, 0]
f(s) = zero(q)
sol(s) = [exp(a * s), s * exp(a * s)]

Random.seed!(2234)
paths = []
t = 1.0
sigs = [10.0, 1000.0]
nsim1 = 5

markers = [:circle, :square, :diamond, :cross, :xcross, :utriangle, :dtriangle, :rtriangle, :ltriangle, :pentagon, :hexagon, :heptagon, :octagon, :star4, :star5, :star6, :star7, :star8, :vline, :hline]
colors = [:red, :green, :blue, :orange, :purple, :brown, :black, :grey]
pl = plot(layout=(2, 3), size=(1300, 800), xlim=(0, 1),
    bottom_margin=5mm, left_margin=5mm, right_margin=4mm)  # Change layout to 2 rows and 3 columns
ylims = [(-1, 1), (-1 / 4, 1 / 4)]
for i in [1, 2]
    paths = []
    sig = sigs[i]
    y = sum(Yplot(t, sig, A, f, q) for _ in 1:nsim1) / nsim1
    for c in [1, 2]
        ylims!(pl[(i-1)*3+c], ylims[i])
        xx = [p[1] for path in paths for p in path]
        yy = [p[2][c] for path in paths for p in path]
        ols = lm(@formula(y ~ x + x^2), DataFrame(x=xx, y=yy))
        Random.seed!(6421)
        for path in paths
            marker = rand(markers)
            color = rand(colors)
            if i == 1
                for p in path
                    scatter!(pl[(i-1)*3+c], [p[1]], [p[2][c] - sol(p[1])[c]], label="", marker=marker, color=color, alpha=0.5)
                end
            end
            plot!(pl[(i-1)*3+c], [p[1] for p in path], [p[2][c] - sol(p[1])[c] for p in path], label="", alpha=0.5, color=color, linewidth=2)
            xlabel!(pl[(i-1)*3+c], "time")
            ylabel!(pl[(i-1)*3+c], "error")
        end
        tt = range(0, t, length=100)
        hline!(pl[(i-1)*3+c], [0], label="0 error", color=:black, linewidth=3)
        plot!(pl[(i-1)*3+c], tt, predict(ols, DataFrame(x=tt)) .- [sol(t)[c] for t in tt], label="OLS y ~ x+x^2", linewidth=3, color=:red)
        title!(pl[(i-1)*3+c], "error, sig=$sig, component=$c", titiefontsize=10)
        #qqplot of time
        plot!(pl[(i-1)*3+3], sort(rand(length(xx))), sort(xx), title="uniform qqplot of time, sig=$sig", label="", linewidth=3)
        xlabel!(pl[(i-1)*3+3], "uniform")
        ylabel!(pl[(i-1)*3+3], "Poisson process")
    end
end

display(pl)
savefig(pl, "latex/main paper/julia_plots/main_poisson_error.pdf")