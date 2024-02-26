using Distributions
using Plots
using LinearAlgebra

Pb0(t, b0, b1) = (b1 - t) / (b1 - b0)
Pb1(t, b0, b1) = (t - b0) / (b1 - b0)
G(t, s, b0, b1) = (t < s) ?
                  -(b1 - s) * (t - b0) / (b1 - b0) :
                  -(b1 - t) * (s - b0) / (b1 - b0)

function X(T::Array, y0, y1, b0, b1, l)
    PP = hcat([Pb0(t, b0, b1) for t in T], [Pb1(t, b0, b1) for t in T])
    sol = PP * [y0, y1]
    if rand() * l < 1
        (u = rand(); n = length(T))
        SS = [b0 + (u + j) * (b1 - b0) / n for j in 0:n-1]
        GG = reshape([G(t, S, b0, b1) for t in T, S in SS], n, n)
        sol += l * GG * X(SS, y0, y1, b0, b1, l) .* (b1 - b0) ./ n
    end
    push!(errors, norm(sol - exp.(T)))
    sol
end

errors = []
tmp = fill(0.0, 20)
X(tmp, exp(-1.0), exp(1.0), -1.0, 1.0, 1.001)

plot(errors, yscale=:log10)