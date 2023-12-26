using Distributions
function Yvar(x, t, dx, a0, u_bound::Function, f::Function, a::Function)
    siginv = 1 / (2 / dx^2 - a0)
    geom = Geometric(a0 * dx^2 / 2)
    expon = Exponential(siginv)
    (sol = 0; w = 1)
    sterm_counter = rand(geom)
    while true
        t -= rand(expon)
        t <= eps() && return sol + w * u_bound(x, 0)
        if sterm_counter != 0
            x += rand(Bool) ? dx : -dx
            w *= 2 * (siginv / (1 - a0 * dx^2 / 2)) / dx^2
            sterm_counter -= 1
            return x - eps() <= 0 ? w * u_bound(0, t) + sol :
                   x + eps() >= 1 ? w * u_bound(1, t) + sol : continue
        else # this is only done O(a0 tstart) times in an estimator
            sterm_counter = rand(geom)
            sol += w * f(x, t) * siginv / (a0 * dx^2 / 2)
            w *= (a(x, t) - a0) * siginv / (a0 * dx^2 / 2)
        end
    end
end