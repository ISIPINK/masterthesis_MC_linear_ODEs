using BenchmarkTools
using Profile
using PProf
using Plots

include("path_generation.jl")

function plot_path!(p, path)
    xxpath1 = [point[1] for point in path[1]]
    yypath1 = [point[2] for point in path[1]]

    push!(xxpath1, path[2][1])
    push!(yypath1, path[2][2])

    plot!(p, yypath1, xxpath1, label="")
    plot!(p, yypath1, xxpath1, seriestype=:scatter, label="")
end

Random.seed!(4181)
x = 0.0
t = 1.0
a0 = 0
am = 30

p = plot()
for _ in 1:20
    path1 = genPath(x, t, 0.001, a0, am, in_triangle)
    plot_path!(p, path1)
end
display(p)

p = plot()
path1 = genPath(x, t, 0.001, a0, am, (x, t) -> t >= 0.5)
path2 = genPath(x, t, 0.001, a0, am, (x, t) -> t >= 0.5)
plot_path!(p, path1)
plot_path!(p, path2)
path = stitch(path1, path2)
plot_path!(p, path)
display(p)
