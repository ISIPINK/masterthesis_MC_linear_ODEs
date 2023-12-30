using Distributions
function Yvar(x, t, dx, a0, am, u_bound::Function, f::Function, a::Function)
    siginv = 1 / (2 / dx^2 + a0)
    (p_source = am / (am + 2 / dx^2); p_avg = 1 - p_source)
    (geom = Geometric(p_source); expon = Exponential(siginv))
    (sol = 0; w = 1)
    sterm_counter = rand(geom)
    while true
        t -= rand(expon)
        t <= eps() && return sol + w * u_bound(x, 0)
        if sterm_counter != 0
            x += rand(Bool) ? dx : -dx
            w *= 2 * siginv / (dx^2 * p_avg)
            sterm_counter -= 1
            return x - eps() <= 0 ? w * u_bound(0, t) + sol :
                   x + eps() >= 1 ? w * u_bound(1, t) + sol : continue
        else # this is only done O(am tstart) times in an estimator
            sterm_counter = rand(geom)
            sol += w * f(x, t) * siginv / p_source
            w *= (a(x, t) + a0) * siginv / p_source
        end
    end
end