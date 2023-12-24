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
        sol += l * GG * X(SS, y0, y1, b0, b1) .* (b1 - b0) ./ n
    end
    sol
end

T = repeat([0], 5)
y0 = exp(-1)
y1 = exp(1)
b0 = -1
b1 = 1
nsim = 10^4
s = sum(X(T, y0, y1, b0, b1, 1.2) for _ in 1:nsim) / nsim .- 1
println("s = ", s)