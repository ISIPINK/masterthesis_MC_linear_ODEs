using Random
using Plots

function Y_fast(t, T, yT, DT)
    sol = yT * (1 + (1 - T) * (t - T) + (t^2 - T^2) / 2)
    l = 1 # russian roulette rate l>1
    if rand() * l < (t - T) / DT
        S = T + rand() * (t - T)  #\sim Uniform(T,t)
        sol += l * DT * (Y_fast(S, T, yT, DT) - yT * (1 + S - T))
    end
    return sol
end

function Y_slow(T, DT) # step size slow recursion
    y, t = 1.0, 0.0
    while t < T
        tt = t + DT < T ? t + DT : T
        y = Y_fast(tt, t, y, tt - t)
        t = tt
    end
    return y
end

solX(T, DT, nsim) = sum(Y_slow(T, DT) for _ in 1:nsim) / nsim


T = 10
DTS = 0.5 .^ range(1, stop=14, step=0.05)
Ns = [1, 100]

Random.seed!(1234)
errors_dict = Dict()
for nsim in Ns
    errors = [(abs(solX(T, d, nsim) - exp(T))) / (exp(T)) for d in DTS]
    errors_dict[nsim] = errors
end

p = plot(yscale=:log10, xscale=:log10,
    legend=:bottomright, legendfontsize=12,
    xlabel="h", ylabel="%error",
    xticks=10.0 .^ range(-5, stop=1, step=0.5), # Add x ticks in log scale
    yticks=10.0 .^ range(-14, stop=1, step=2)) # Add y ticks in log scale

for (nsim, errors) in errors_dict
    plot!(p, DTS, errors, label="nsim$nsim")
end

dgs = range(2, stop=3, step=0.5)
for l in dgs
    plot!(p, DTS, DTS .^ l / 5, label="\$O(h^{$l})\$", linestyle=:dash)
end
display(p)
savefig(p, "latex/main paper/julia_plots/CV_RRMC_IVP.pdf")