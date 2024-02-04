using Distributions
using Random

# triangle (0,-scale^2), (-+2scale^1,0)
in_triangle(pos, time, scale) = scale^(-2) * time + 1 >= scale^(-1) * abs(pos) / 2

"""
    genPath(dx, a0, am, isInside)

Generate a path based on the given parameters and 
isInside.

# Arguments
- `dx`: The step size for the path.
- `a0`: for small dx this isn't important
- `am`: magnitude of the (a-a0)
- `isInside`: A function that takes the current 
`x` and `t` values and returns a boolean indicating 
whether the current point is inside the desired region.

# Returns
- A tuple containing an array of points in the path and the final point. Each point is a tuple of `(x, t, sterm_counter)`.

# Example
```julia
path, final_point = genPath(0.01, 0, 30, (x, t) -> t >= 0.5)
```
"""

function genPath(dx, a0, am, isInside)
    (x = 0.0; t = 0.0)
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

function genPathsScalesTriangle(scaleValues, npaths, dx, a0, am)
    pathsDictionary = Dict{Float64,Array}()
    dxx = [dx for _ in 1:npaths]
    for scale in scaleValues
        paths = genPath.(dxx, a0, am, (x, t) -> in_triangle(x, t, scale))
        pathsDictionary[scale] = paths
    end
    return pathsDictionary
end
