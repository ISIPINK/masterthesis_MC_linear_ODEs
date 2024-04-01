using Plots
using Random
using LinearAlgebra
using Plots.PlotMeasures

function Y(t, sig, A::Function, f::Function, y0)
    (s = -log(rand()) / sig; sol = y0)
    while s < t
        sol += (A(s) * sol .+ f(s)) ./ sig
        s -= log(rand()) / sig
    end
    sol
end

a = 1
A(s) = [a 0; 1 a]
q = [1, 0]
f(s) = zero(q)
sol(s) = [exp(a * s), s * exp(a * s)]
sig = 1.0
t = 1.0


Random.seed!(2234)
xticks = 10.0 .^ range(1, 4, step=1)
yticks = 10.0 .^ range(-4, 0, step=1)
sigs = exp10.(range(1, 4, length=1000))
errors = [norm(Y(t, sig, A, f, q) - sol(t)) for sig in sigs]
p1 = plot(sigs, errors, st=:scatter, xscale=:log10, yscale=:log10, label="error", alpha=0.5)
plot!(p1, sigs, 5 * sigs .^ -0.5, label="\$O(sig^{-0.5})\$", linewidth=4)
plot!(p1, sigs, 5 * sigs .^ -1, label="\$O(sig^{-1})\$", linewidth=4)
xticks!(p1, xticks)  # Set xticks
yticks!(p1, yticks)  # Set yticks
xlabel!(p1, "sig")
ylabel!(p1, "norm(error)")

nsims = exp10.(range(1, 4, length=1000))
errors = [norm(sum(Y(t, sig, A, f, q) for _ in 1:nsim) / nsim - sol(t)) for nsim in nsims]
p2 = plot(nsims, errors, st=:scatter, xscale=:log10, yscale=:log10, label="error", alpha=0.5)
plot!(p2, nsims, 5 * nsims .^ -0.5, label="\$O(nsim^{-0.5})\$", linewidth=4)
plot!(p2, nsims, 5 * nsims .^ -1, label="\$O(nsim^{-1})\$", linewidth=4)
xticks!(p2, xticks)  # Set xticks
yticks!(p2, yticks)  # Set yticks
xlabel!(p2, "nsim")
ylabel!(p2, "norm(error)")

p = plot(p1, p2, layout=(1, 2), size=(1000, 400), bottom_margin=5mm, left_margin=5mm)  # Combine both plots
display(p)
savefig(p, "latex/main paper/julia_plots/main_poisson_convergence.pdf")
