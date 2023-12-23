function MCtrapezium(f, n, l=100)
    sol = 0
    for j in 0:n-1
        if rand() * l < 1
            x, xx = j / n, (j + 1) / n
            S = x + rand() * (xx - x) # \sim Uniform(x, xx)
            sol += l * (f(S) - f(x) - n * (S - x) * (f(xx) - f(x))) / n
        end
    end
    return trapezium(f, n) + sol
end