using BenchmarkTools
using Profile
using PProf
using Plots
using Revise

includet("path_generation.jl")

function plot_path!(p, path)
    xxpath1 = [point[1] for point in path[1]]
    yypath1 = [point[2] for point in path[1]]

    push!(xxpath1, path[2][1])
    push!(yypath1, path[2][2])

    plot!(p, yypath1, xxpath1, label="")
    plot!(p, yypath1, xxpath1, seriestype=:scatter, label="")
end

Random.seed!(4181)
a0 = 0
am = 10
Δx = 0.001
scales = [sqrt(2.0^(-j)) for j in 0:6]
npaths = 20
dpaths = genPathsScalesTriangle(scales, npaths, Δx, a0, am)
scale = scales[3]

p = plot()
for path in dpaths[scale]
    plot_path!(p, path)
end
display(p)

p = plot()
path1 = genPath(Δx, a0, am, (x, t) -> t >= -0.5)
path2 = genPath(Δx, a0, am, (x, t) -> t >= -0.5)
plot_path!(p, path1)
plot_path!(p, path2)
path = stitch(path1, path2)
plot_path!(p, path)
display(p)
