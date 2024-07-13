using PProf
using Profile
using BenchmarkTools


euler_step(y, t0, t, f) = y + (t - t0) * f(t, y)

function euler_steps(y, t0, t, f, n)
    h = (t - t0) / n
    for _ in 1:n
        y += h * f(t0, y)
        t0 += h
    end
    y
end


function debiased_euler_step(y, t0, t, f, l)
    (l > 0.4) ? error("l must be less than 0.4") : nothing
    if rand() < l
        z = debiased_euler_step(y, t0, (t + t0) / 2, f, l)
        z = debiased_euler_step(z, (t + t0) / 2, t, f, l)
        return (z + euler_step(y, t0, t, f) * (l - 1)) / l
    else
        return euler_step(y, t0, t, f)
    end
end

function debiased_euler_steps(y, t0, t, f, l, n)
    h = (t - t0) / n
    for _ in 1:n
        y = debiased_euler_step(y, t0, t0 + h, f, l)
        t0 += h
    end
    y
end



function A_n(t, n)
    # Create an n x n matrix where each element is -cos(t)
    matrix = fill(0.0, (n, n))
    for i in 1:n
        for j in 1:n
            matrix[i, j] = -cos(t)
        end
    end

    # Set the diagonal elements to 1 + cos(t)
    for i in 1:n
        matrix[i, i] = 1 + cos(t)
    end
    return matrix
end

d = 20
y0 = ones(d)
A(t) = [1+cos(t) -cos(t); cos(t) 1-cos(t)]
A(t) = A_n(t, d)



begin
    Profile.clear()
    @profile begin
        euler_steps(y0, 0.0, 1.0, (t, y) -> A(t) * y, 1000)
    end
    pprof()
end

begin
    Profile.clear()
    @profile begin
        debiased_euler_steps(y0, 0.0, 1.0, (t, y) -> A(t) * y, 0.1, 1000)
    end
    pprof()
end

begin
    bench_res = @benchmark euler_steps(y0, 0.0, 1.0, (t, y) -> A(t) * y, 1000)
    display(bench_res)
end

begin
    bench_res = @benchmark debiased_euler_steps(y0, 0.0, 1.0, (t, y) -> A(t) * y, 0.1, 1000)
    display(bench_res)
end