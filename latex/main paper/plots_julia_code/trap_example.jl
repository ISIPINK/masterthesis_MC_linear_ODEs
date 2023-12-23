using Plots
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


f(x) = exp(x)
nn = round.(Int, exp10.(range(0, 6.5, length=200)))
sol = exp(1) - 1
trapezium_error = abs.(trapezium.(f, nn) .- sol) .+ eps()
mc_trapezium_error = abs.(MCtrapezium.(f, nn, 100) .- sol) .+ eps()
p = plot(nn, trapezium_error, label="trapezium", xscale=:log10, yscale=:log10)
plot!(p, nn, mc_trapezium_error, label="MCtrapezium", xscale=:log10, yscale=:log10)
display(p)
savefig(p, "latex/main paper/julia_plots/trap_example.pdf")