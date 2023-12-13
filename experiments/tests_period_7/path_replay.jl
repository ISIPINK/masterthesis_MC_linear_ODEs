using Random
using Plots
@inline U() = rand()
@inline B(p) = U() < p

Y(t) = B(t) ? 1 + Y(U() * t) : 1 # this gives acces to all evaluated Y but is slow

function Ytail(t) # doesnt give acces to all evaluated Y but is fast
    sol = 0
    while B(t)
        sol += 1
        t *= U()
    end
    return 1 + sol
end

function Ytailreplay(t, y) # doesnt give acces to all evaluated Y but is fast
    while B(t)
        y -= 1
        t *= U()
    end
    return y
end

function testreplay()
    Random.seed!(1234)  # Set the seed
    y = Ytail(1)
    Random.seed!(1234)  # Set the seed
    e = Ytailreplay(1, y)
    println(e)
end


y(t, nsim) = sum(Y(t) for _ in 1:nsim) / nsim
ytail(t, nsim) = sum(Ytail(t) for _ in 1:nsim) / nsim
Random.seed!(1234)  # Set the seed
println("error = $(y(1,10^6)-ℯ)")
Random.seed!(1234)  # Set the seed
println("error = $(ytail(1,10^6)-ℯ)")

testreplay()