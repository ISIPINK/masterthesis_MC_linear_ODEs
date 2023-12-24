function sample_path(t)
    res = [float(t)]
    while rand() < t
        t *= rand()
        push!(res, t)
    end
    res
end

function X(t, a)
    (q = [1.0, 0.0]; A = [a 0.0; 1.0 a])
    (sol = zero(q); path = sample_path(t))
    while !isempty(path)
        t = path[end]
        sol = q + A * sol
        pop!(path)
    end
    sol
end