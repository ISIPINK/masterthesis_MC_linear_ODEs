using Plots
using Random

Random.seed!(1234)

k = 1000
kbreak = 700
xx = [i <= kbreak ? rand() : 0.1 for i in 1:k]
xx = shuffle(xx)

ssol = sum(xx) / length(xx)
n = 100
approx_rand(n) = sum(xx[rand(1:k)] for _ in 1:n) / n
approx_rand2(n) = sum(shuffle(xx)[1:n]) / n
appeox_rand3(p, app) = sum(rand() < p ? (xx[i] - (1 - p) * app) / p : app for i in 1:n) / n
approx_det(n) = (sum(xx[1:n]) + 0.5 * (k - n)) / k

function approx_rand3_eval(p, app)
    evals = 0
    sum = 0
    for i in 1:length(xx)
        if rand() < p
            sum += (xx[i] - (1 - p) * app) / p
            evals += 1
        else
            sum += app
        end
    end
    return sum / length(xx), evals
end




Random.seed!(1234)
nn = [100, 300, 500, 700, 900]
p = plot(
    yscale=:log10,
    xticks=100:100:900,
    yticks=[10^-1, 10^-2, 10^-3, 10^-4],
    legend=:bottomleft
)
ylabel!(p, "Fout")
xlabel!(p, "Samples")
title!(p, "Convergentie optelling algoritmes")
scatter!(p, [], [], color=:blue, label="met vervanging", alpha=0.5)
scatter!(p, [], [], color=:green, label="zonder vervanging", alpha=0.5)
scatter!(p, [], [], color=:orange, label="Russische roulette", alpha=0.5)
scatter!(p, [], [], color=:black, label="deterministisch")


nsim = 20

for n in nn
    for _ in 1:nsim
        error = abs(approx_rand(Integer(n)) - ssol) + eps()
        scatter!(p, (n - k / 25, error), label="", color=:blue, alpha=0.5, markersize=5)
    end
end

for n in nn
    for _ in 1:nsim
        error = abs(approx_rand2(Integer(n)) - ssol) + eps()
        scatter!(p, (n, error), label="", color=:green, alpha=0.5, markersize=5)
    end
end

for n in nn
    error = abs(approx_det(Integer(n)) - ssol) + eps()
    scatter!(p, (n, error), label="", color=:black, markersize=6)
end

for n in nn
    for _ in 1:nsim
        app, evals = approx_rand3_eval(n / k, 1 / 2)
        error = abs(app - ssol) + eps()
        scatter!(p, (evals + k / 25, error), label="", color=:orange, alpha=0.5, markersize=5)
    end
end

p2 = histogram(xx, bins=30, label="xi")
layout = @layout([a{0.7w} b{0.3w}])
pp = plot(p, p2, layout=layout, size=(600, 400))

display(pp)
# savefig(pp, "latex/presentation 2 (dutch)/imgs/convergence_sums.pdf")
