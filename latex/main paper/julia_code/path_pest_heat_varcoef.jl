using Distributions
function YvarPath(x, t, dx, a0)
    siginv = 1 / (2 / dx^2 - a0)
    geom = Geometric(a0 * dx^2 / 2)
    expon = Exponential(siginv)
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
        else
            sterm_counter = rand(geom)
            push!(spoints, (x, t, sterm_counter))
        end
    end
end