using Distributions
using Random


in_triangle(pos, time) = time >= abs(pos) / 2

function genPath(x, t, dx, a0, am, isInside)
    (siginv = 1 / (2 / dx^2 + a0); p_source = am / (am + 2 / dx^2))
    (geom = Geometric(p_source); expon = Exponential(siginv))
    sterm_counter = rand(geom)
    spoints = [(x, t, sterm_counter)] #maybe other data struct
    while isInside(x, t)
        t -= rand(expon)
        if sterm_counter != 0
            sterm_counter -= 1
            x += rand(Bool) ? dx : -dx
        else # this is only done O(am tstart) times in an estimator
            sterm_counter = rand(geom)
            push!(spoints, (x, t, sterm_counter))
        end
    end
    return (spoints, (x, t, sterm_counter))
end

# expensive it is better to implicitly stitch paths
function stitch(path1, path2)
    spoints = copy(path1[1][1:end-1])
    x, t, sterm_counter = path1[1][end]
    endx1, endt1, sterm_counter_over = path1[2]
    begx2, begt2, sterm_counter2 = path2[1][1]
    sterm_counter += sterm_counter2 - sterm_counter_over
    dx = endx1 - begx2
    dt = endt1 - begt2
    push!(spoints, (x, t, sterm_counter))
    for (x, t, sterm_counter) in path2[1][2:end]
        push!(spoints, (x + dx, t + dt, sterm_counter))
    end
    (x, t, sterm_counter) = path2[2]
    return (spoints, (x + dx, t + dt, sterm_counter))
end