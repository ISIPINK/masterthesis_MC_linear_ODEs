function Y(t, sig, A::Function, f::Function, y0)
    (s = -log(rand()) / sig; sol = y0)
    while s < t
        sol += (A(s) * sol .+ f(s)) ./ sig
        s -= log(rand()) / sig
    end
    sol
end

using Plots
using Statistics
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



while false
    println("test")
end
println("hah")