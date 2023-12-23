using Distributions
function Yvar(x, t, dx, a0)
    siginv = 1 / (2 / dx^2 - a0)
    geom = Geometric(a0 * dx^2 / 2)
    expon = Exponential(siginv)
    (sol = 0; w = 1)
    sourcejump = rand(geom)
    while true
        t -= rand(expon)
        t <= 0 && return sol + w * u(x, 0)
        if sourcejump != 0
            x += rand(Bool) ? dx : -dx
            w *= 2 * (siginv / (1 - a0 * dx^2 / 2)) / dx^2
            sourcejump -= 1
            return x <= 0 ? w * u(0, t) + sol :
                   x >= 1 ? w * u(1, t) + sol : continue
        else # this is only done O(tstart) times in an estimator
            sourcejump = rand(geom)
            sol += w * f(x, t) * siginv / (a0 * dx^2 / 2)
            w *= (a(x, t) - a0) * siginv / (a0 * dx^2 / 2)
        end
    end
end