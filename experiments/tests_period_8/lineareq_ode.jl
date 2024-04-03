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

a = 1.5
AA = [2 1; 0 -1]
b = [1, 0]
A(s) = -a * AA' * AA .+ (rand() - 0.5) / 3
q = [0.55, -0.05]
f(s) = a * AA' * b
sol(s) = AA \ b
print(sol(1))

Random.seed!(2234)
paths = []
t = 6
sigs = [5.0, 100.0]
nsim1 = 20

markers = [:circle, :square, :diamond, :cross, :xcross, :utriangle, :dtriangle, :rtriangle, :ltriangle, :pentagon, :hexagon, :heptagon, :octagon, :star4, :star5, :star6, :star7, :star8, :vline, :hline]
colors = [:red, :green, :blue, :orange, :purple, :brown, :black, :grey]
pl = plot(layout=(2, 3), size=(1300, 800),
    bottom_margin=5mm, left_margin=5mm, right_margin=4mm)  # Change layout to 2 rows and 3 columns
for i in [1, 2]
    paths = []
    sig = sigs[i]
    y = sum(Yplot(t, sig, A, f, q) for _ in 1:nsim1) / nsim1
    for c in [1, 2]
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
        hline!(pl[(i-1)*3+c], [0], label="0 error", color=:black, linewidth=3)
        title!(pl[(i-1)*3+c], "error, sig=$sig, component=$c", titiefontsize=10)
    end
end

display(pl)