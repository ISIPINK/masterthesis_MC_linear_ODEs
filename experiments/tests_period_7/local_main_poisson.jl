using Plots
using Statistics
using Distributions
using GLM, DataFrames


function Y(t, sig, A::Function, f::Function, y0)
    (s = -log(rand()) / sig; sol = y0)
    while s < t
        sol += (A(s) * sol .+ f(s)) ./ sig
        s -= log(rand()) / sig
    end
    sol
end

sig = 1.0
A(s) = s
f(s) = -s^3 + s
q = 1.0
t = 1.0
sol(s) = s^2 + 1
errors = []
nsim1 = 10^3

# convergence in sigma
sigs = exp10.(range(log10(1.0), log10(10000.0), length=10))
RMSEs = []
stds = []
for sig in sigs
    push!(RMSEs, sqrt(mean((Y(t, sig, A, f, q) - sol(t))^2 for _ in 1:nsim1)))
    push!(stds, std(Y(t, sig, A, f, q) for _ in 1:nsim1))
end

plot(sigs, RMSEs, st=:scatter, xscale=:log10, yscale=:log10, label="RMSE")
plot!(sigs, stds, st=:scatter, xscale=:log10, yscale=:log10, label="stds")
ylabel!("RMSE")
xlabel!("sig")
c = 1.5
plot!(sigs, c * sigs .^ -0.5, label="sig^-0.5")
plot!(sigs, c * sigs .^ -1, label="sig^-1")
plot!(sigs, c * sigs .^ -1.5, label="sig^-1.5")

# convergence in nsim
for _ in 1:1000
    e = sum(Y(t, 1, A, f, q) for _ in 1:nsim1) / nsim1 - sol(t)
    push!(errors, e)
end
# println(errors)
display(histogram(errors, bins=100))
sum(errors) / length(errors)
# convergence in t
nsim = 10000
tt = exp10.(range(-2, -4, length=100))
yy1 = abs.(Y.(tt, sig, A, f, q) - sol.(tt))
yy = abs.(mean(Y.(tt, sig, A, f, q) for _ in 1:nsim) - sol.(tt))
yys = [sum(Y.(t, 0.5 / t, A, f, q) for _ in 1:nsim) / nsim for t in tt]
yys = abs.(yys .- sol.(tt))
yys = [Y(t, 1 / t, A, f, q) for t in tt]
yys = abs.(yys - sol.(tt)) .+ eps()

plot(tt, yy, st=:scatter, xscale=:log10, yscale=:log10, label="Y(t)")
# plot!(tt, yy1, st=:scatter, xscale=:log10, yscale=:log10, label="Y(t)1")
# plot!(tt, yys, st=:scatter, xscale=:log10, yscale=:log10, label="Y(t)s")
plot!(tt, tt, label="t")
plot!(tt, tt .^ 1.5, label="t^1.5")
plot!(tt, tt .^ 2, label="t^2")

#test 2
ttss = [exp10(-i) for i in range(1, 4, 50)]
yyss = abs.(Y.(1, 1 ./ ttss, A, f, q) - exp.(ttss)) .+ eps()
plot(ttss, yyss, st=:scatter, xscale=:log10, yscale=:log10, label="Y(t)")



# plot of realizations
using Plots
using Statistics


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

A(s) = s
f(s) = -s^3 + s
q = 1.0
sol(s) = s^2 + 1

# A(s) = 1
# f(s) = 0
# q = 1.0
# sol(s) = exp(s)

t = 1.0
sig = 1000.0
nsim1 = 2 * 10^1
paths = []
for _ in 1:nsim1
    Yplot(t, sig, A, f, q)
end

# Collect all points from all paths into two arrays
x_values = Float64[]
y_values = Float64[]

for path in paths
    append!(x_values, [p[1] for p in path])
    append!(y_values, [p[2] for p in path])
end

# Perform OLS regression
ols = lm(@formula(y ~ x + x^2), DataFrame(x=x_values, y=y_values))



tt = range(0, t, length=100)
pl = plot()

for path in paths
    # plot!(pl, [p[1] for p in path], [p[2]-sol(p[1]) for p in path], label="", st=:scatter, color=:blue, alpha=0.5)
    plot!(pl, [p[1] for p in path], [p[2] - sol(p[1]) for p in path], label="", alpha=0.5)
end
# plot!(pl, tt, sol.(tt), label="sol(t)", linewidth=6, color=:orange)
plot!(pl, tt, predict(ols, DataFrame(x=tt)) - sol.(tt), label="OLS y ~ x+x^2", linewidth=3, color=:red)
title!("error of different realizations")
display(pl)


histogram([p[1] for p in points], bins=100, label="Y(t)")
histogram([p[end] for p in paths], bins=100, label="Y(t)")


endpoints = [p[end][2] for p in paths]
n = length(endpoints)
plot(sort(randn(n)), sort(endpoints), st=:scatter, alpha=0.3, markersize=3)