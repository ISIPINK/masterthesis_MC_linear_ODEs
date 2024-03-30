using Plots
using Random
using Plots.PlotMeasures

trapezium(f, n) = sum((f(j / n) + f((j + 1) / n)) / 2 for j in 0:n-1) / n

function MCtrapezium(f, n, l=100)
    sol = 0
    for j in 0:n-1
        if rand() * l < 1
            x, xx = j / n, (j + 1) / n
            S = x + rand() * (xx - x) # \sim Uniform(x, xx)
            sol += l * (f(S) - f(x) - (S - x) * (f(xx) - f(x)) * n) / n
        end
    end
    return trapezium(f, n) + sol
end


Random.seed!(4181)
f(x) = exp(x)
nn = round.(Int, exp10.(range(0, 6.5, length=400)))
sol1 = exp(1) - 1
trapezium_error = abs.(trapezium.(f, nn) .- sol1)
mc_trapezium_error = abs.(MCtrapezium.(f, nn, 100) .- sol1)

yticks = 10.0 .^ range(-16, 0, step=2) # adjust the range and step as needed
p = plot(nn, trapezium_error .+ eps(), label="OG trap", xscale=:log10, yscale=:log10, legendfontsize=12, yticks=yticks, xlabel="n", ylabel="error", bottom_margin=2mm)
plot!(p, nn, mc_trapezium_error .+ eps(), label="MC trap", xscale=:log10, yscale=:log10)
plot!(p, nn, nn .^ -2 .+ eps(), label="\$O(n^{-2})\$", xscale=:log10, yscale=:log10, linestyle=:dash)
plot!(p, nn, nn .^ -2.5 .+ eps(), label="\$O(n^{-2.5})\$", xscale=:log10, yscale=:log10, linestyle=:dash)
plot!(p, nn, nn .^ -3 .+ eps(), label="\$O(n^{-3})\$", xscale=:log10, yscale=:log10, linestyle=:dash)

display(p)
savefig(p, "latex/main paper/julia_plots/trap_example.pdf")