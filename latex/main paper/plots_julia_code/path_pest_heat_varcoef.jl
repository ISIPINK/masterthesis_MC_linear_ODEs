using Random
using Distributions
using Plots
using Plots.PlotMeasures


function genPath(x, t, dx, a0, am)
    (siginv = 1 / (2 / dx^2 + a0); p_source = am / (am + 2 / dx^2))
    (geom = Geometric(p_source); expon = Exponential(siginv))
    sterm_counter = rand(geom)
    spoints = [(x, t, sterm_counter)] #maybe other data struct
    while true
        t -= rand(expon)
        t <= eps() && return (spoints, (x, t, sterm_counter))
        if sterm_counter != 0
            x += rand(Bool) ? dx : -dx
            sterm_counter -= 1
            return x - eps() <= 0 ? (spoints, (x, t, sterm_counter)) :
                   x + eps() >= 1 ? (spoints, (x, t, sterm_counter)) :
                   continue
        else # this is only done O(am tstart) times in an estimator
            sterm_counter = rand(geom)
            push!(spoints, (x, t, sterm_counter))
        end
    end
end

function generate_plot(xx, t, Δx, a0, am, plot_title)
    tpaths = genPath.(xx, t, Δx, a0, am)
    colors = [:red, :green, :blue, :purple, :cyan, :magenta, :orange, :pink, :teal, :violet, :lime, :gold, :silver, :maroon, :navy]
    markers = [:circle, :square, :diamond, :cross, :xcross, :utriangle, :dtriangle, :rtriangle, :ltriangle, :pentagon, :hexagon, :heptagon, :octagon, :star4, :star5, :star6, :star7, :star8]

    p = plot([t, 0, 0, t], [0, 0, 1, 1], color=:red, label="")
    for (i, tpath) in enumerate(tpaths)
        xxpath1 = [point[1] for point in tpath[1]]
        yypath1 = [point[2] for point in tpath[1]]

        push!(xxpath1, tpath[2][1])
        push!(yypath1, tpath[2][2])

        plot!(p, yypath1, xxpath1, color=colors[i%length(colors)+1], label="")
        plot!(p, yypath1, xxpath1, seriestype=:scatter, color=colors[i%length(colors)+1], markershape=markers[i%length(markers)+1], label="")
    end
    xlabel!(p, "Time")
    ylabel!(p, "Position")
    title!(p, plot_title)
    return p
end

Random.seed!(4181)

amount_samples = 20
xx = repeat([0.5], amount_samples)
x = 0.5
t = 0.15
a0 = 0
am = 30

p1 = generate_plot(xx, t, 0.1, a0, am, "Paths with Δx = 0.1")
p2 = generate_plot(xx, t, 0.001, a0, am, "Paths with Δx = 0.001")

p = plot(p1, p2, layout=(1, 2), size=(1000, 400), left_margin=10mm, bottom_margin=5mm, top_margin=5mm, right_margin=10mm)
display(p)
savefig(p, "latex/main paper/julia_plots/paths_pest_heat_varcoef.pdf")