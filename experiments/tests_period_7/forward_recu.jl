function Y(t)
    t += log(rand())
    (t < 0) ? 1 : 2 * Y(t)
end

function Y1(t)
    s = 0
    sol = 1
    while true
        s -= log(rand())
        s > t && break
        sol *= 2
    end
    sol
end

nsim = 10^7
y(t, nsim) = sum(Y(1) for _ in 1:nsim) / nsim
y1(t, nsim) = sum(Y1(1) for _ in 1:nsim) / nsim
println("error = $(y(1,nsim)-ℯ)")
println("error = $(y1(1,nsim)-ℯ)")


function path()
    tmp = Float64[]
    t = 0.0
    while t < 1
        push!(tmp, t)
        t -= log(rand()) / 2
    end
    return tmp
end

function path1()
    tmp = Float64[]
    t = 1.0
    while t > 0
        push!(tmp, t)
        t += log(rand()) / 2
    end
    return tmp
end

using Plots

path_values = path()
path_values1 = path1()
plot(path_values, zero(path_values), st=:scatter)
plot!(path_values1, zero(path_values) .+ 1, st=:scatter)