using Distributions
function YvarPath(x, t, dx, a0, am)
    (siginv = 1 / (2 / dx^2 + a0); p_source = am / (am + 2 / dx^2))
    (geom = Geometric(p_source); expon = Exponential(siginv))
    sterm_counter = rand(geom)
    spoints = [(x, t, sterm_counter)] #maybe other data struct
    while true
        t -= rand(expon)
        t <= eps() && return (spoints, (x, t, sterm_counter))
        if sterm_counter != 0
            x += rand(Bool) ? dx : -dx
            sterm_counter -= 1
            return x - eps() <= 0 ? (spoints, (x, t, sterm_counter)) :
                   x + eps() >= 1 ? (spoints, (x, t, sterm_counter)) :
                   continue
        else # this is only done O(am tstart) times in an estimator
            sterm_counter = rand(geom)
            push!(spoints, (x, t, sterm_counter))
        end
    end
end