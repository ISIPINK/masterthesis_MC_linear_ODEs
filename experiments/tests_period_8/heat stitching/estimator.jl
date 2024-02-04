using Distributions
include("path_generation.jl")

function YvarPathMemoExp(path, dx, a0, am, u_bound::Function, f::Function, a::Function)
    spoints, exit = path
    (siginv = 1 / (2 / dx^2 + a0); p_source = am / (am + 2 / dx^2))
    lw_multiplier = log(2 * siginv / (dx^2 * (1 - p_source)))
    (sol = 0; w = exp(spoints[1][3] * lw_multiplier))
    for (x, t, sterm_counter) in spoints[2:end]
        sol += w * f(x, t) * siginv / p_source
        w *= (a(x, t) + a0) * siginv / p_source
        w *= exp(sterm_counter * lw_multiplier)
    end
    (x, t, sterm_counter) = exit # small w can produce NaNs
    w /= sterm_counter > 0 && abs(w) > eps() ? exp(sterm_counter * lw_multiplier) : 1
    sol + w * u_bound(x, t)
end


function Yvar(x, t, dpaths, scale_bound, dx, a0, am, u_bound, f, a)
    points = [(x, t, 0)]
    scales = keys(dpaths)
    (sol = 0; w = 1)
    (siginv = 1 / (2 / dx^2 + a0); p_source = am / (am + 2 / dx^2))
    lw_multiplier = log(2 * siginv / (dx^2 * (1 - p_source)))

    while true
        fscales = filter(s -> s <= scale_bound(x, t), scales)
        if isempty(fscales)
            break
        else
            scale = maximum(fscales)
        end

        #incorrect resampling the same path introduces bias

        path = dpaths[scale][rand(1:length(dpaths[scale]))]
        println("new path")
        spoints, exit = path
        w *= exp(spoints[1][3] * lw_multiplier)
        for (dx, dt, sterm_counter) in spoints[2:end]
            sol += w * f(x + dx, t + dt) * siginv / p_source
            w *= (a(x + dx, t + dt) + a0) * siginv / p_source
            w *= exp(sterm_counter * lw_multiplier)
            push!(points, (x + dx, t + dt, sterm_counter))
        end
        (dx, dt, sterm_counter) = exit # small w can produce NaNs
        push!(points, (x + dx, t + dt, sterm_counter))
        (x += dx; t += dt)
        w /= sterm_counter > 0 && abs(w) > eps() ? exp(sterm_counter * lw_multiplier) : 1

        println("(x,t) = ", x, "   ", t)
    end
    println("(x,t,scale) = ", x, "   ", t, "   ", scale_bound(x, t))
    return sol + w * u_bound(x, t), points
end