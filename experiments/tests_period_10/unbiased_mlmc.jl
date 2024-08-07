
using Plots

# solve y' = f(t,y) , f smooth, y(0) = y0
# explicit euler y_{n+1} = y_n + h f(t_n, y_n) 

# euler_step(y, t0, t, f) = y + (t - t0) * f(t, y)

using Roots

function euler_step(y0, t0, t, f)
    g(y) = y - y0 - (t - t0) * f(t, y)
    find_zero(g, y0)
end


function euler_steps(n, y, t0, t, f)
    h = (t - t0) / n
    for j in 1:n
        y = euler_step(y, t0 + (j - 1) * h, t0 + j * h, f)
    end
    y
end


function reuler_step(y0, t0, t, f, pp)
    x = euler_step(y0, t0, t, f)
    if rand() < pp
        z = reuler_step(y0, t0, (t + t0) / 2, f, pp)
        z = reuler_step(z, (t + t0) / 2, t, f, pp)
        x = z / pp + x * (pp - 1) / pp
    end
    x
end


function reuler_steps(n, y, t0, t, f, pp)
    h = (t - t0) / n
    for j in 1:n
        y = reuler_step(y, t0 + (j - 1) * h, t0 + j * h, f, pp)
    end
    y
end

function reuler_steps_avg(n, nsim, y, t0, t, f, pp)
    sum(reuler_steps(n, y, t0, t, f, pp) for _ in 1:nsim) / nsim
end



p(k, r) = r * (1 - r)^k
d(k, y, t0, t, f) = euler_steps(2^(k + 1), y, t0, t, f) - euler_steps(2^k, y, t0, t, f)
geom(r, count) = (rand() < r) ? count : geom(r, count + 1)


# nsim = 10^3
# r = 0.3
# gg = [geom(r, 0) for _ in 1:nsim]
# # Plot the histogram
# histogram(gg, bins=Int(round(nsim/20)), label="Geometric distribution", xlabel="Number of steps", ylabel="Frequency", title="Geometric distribution of steps")

# # Overlay the theoretical PMF
# rr = minimum(gg):1:maximum(gg)
# plot!(rr, [nsim*p(k, r) for k in rr], label="p(k, 0.99)", linestyle=:dash)

function debiased_euler_step(y, t0, t, f)
    r = 1 - 2^(-3 / 2)
    N = geom(r, 0)
    euler_step(y, t0, t, f) + d(N, y, t0, t, f) / p(N, r)
end

function debiased_euler_steps(n, y, t0, t, f)
    h = (t - t0) / n
    for j in 1:n
        y = debiased_euler_step(y, t0 + (j - 1) * h, t0 + j * h, f)
    end
    y
end

function debiased_euler_steps_avg(n, nsim, y, t0, t, f)
    sum(debiased_euler_steps(n, y, t0, t, f) for _ in 1:nsim) / nsim
end

y0 = 1.0
f(t, y) = -10y + 5 * sin(y) - 5 * sin(exp(-10 * t))
exact_sol(t) = exp(-10 * t)

t0 = 0.0
T = 2  # Final time to evaluate the solution
nsim = 10^0
pp = 0.3
println(debiased_euler_steps_avg(2, nsim, y0, t0, T, f) - exact_sol(T))
println(reuler_steps_avg(10, nsim, y0, t0, T, f, pp) - exact_sol(T))


# tests convergence in steps 
begin

    b(t) = (t < 0.5) ? 1 : 0
    function f(t, y)
        global f_call_count += 1
        # y + b(t)*sin(y) - b(t)*sin(exp(t))
        y + sin(y / 2) - sin(exp(t) / 2)
        # y +  sin(10 * y) -  sin(10 *exp(t))
        # y
    end

    exact_sol(t) = exp(t)

    function f(t, y)
        global f_call_count += 1
        -10y + 5 * sin(y) - 5 * sin(exp(-10 * t))
    end
    exact_sol(t) = exp(-10 * t)

    # Initial condition
    y0 = 1.0
    t0 = 0.0
    T = 0.5  # Final time to evaluate the solution
    nsim = 1
    pp = 0.3

    # Test convergence for different numbers of steps
    nn = Int.(round.(10 .^ (1:0.01:4)))
    errors_de = []
    calls_de = []

    errors_e = []
    calls_e = []

    for n in nn
        global f_call_count = 0
        # error_de = abs(debiased_euler_steps_avg(n, nsim, y0, t0, T, f) - exact_sol(T))
        error_de = abs(reuler_steps(n, y0, t0, T, f, pp) - exact_sol(T)) .+ eps()
        push!(errors_de, error_de)
        push!(calls_de, f_call_count)

        global f_call_count = 0
        error_e = abs(euler_steps(n, y0, t0, T, f) - exact_sol(T)) .+ eps()
        push!(errors_e, error_e)
        push!(calls_e, f_call_count)
    end
    # Plotting the error
    plot(calls_de, errors_de, xaxis=:log, yaxis=:log, label="debiased euler", marker=:circle,
        xlabel="calls of f", ylabel="Error", title="Convergence of Euler Steps", alpha=0.5)
    plot!(calls_e, errors_e, xaxis=:log, yaxis=:log, label="euler", marker=:circle,
        xlabel="calls of f (n)", ylabel="Error", title="Convergence of Euler Steps")
    plot!(nn, nn .^ (-1), label="O(n^{-1})", linestyle=:dash)
    plot!(nn, nn .^ (-1.5), label="O(n^{-1.5})", linestyle=:dash)

end



# test convergence in nsim 
begin

    b(t) = (t < 0.5) ? 1 : 0
    function f(t, y)
        # y + b(t)*sin(y) - b(t)*sin(exp(t))
        # y + sin(y / 2) - sin(exp(t) / 2)
        # y +  sin(10 * y) -  sin(10 *exp(t))
        y
    end

    exact_sol(t) = exp(t)


    function f(t, y)
        global f_call_count += 1
        -10y + 5 * sin(y) - 5 * sin(exp(-10 * t))
        # -10y
    end
    exact_sol(t) = exp(-10 * t)

    # Initial condition
    y0 = 1.0
    t0 = 0.0
    T = 1.0  # Final time to evaluate the solution
    steps = 2
    pp = 0.3

    # Test convergence for different numbers of steps
    nsims = Int.(round.(10 .^ (1:0.5:6)))
    errors_de = []

    for nsim in nsims
        # error_de = abs(debiased_euler_steps_avg(steps, nsim, y0, t0, T, f) - exact_sol(T))
        error_de = abs(reuler_steps_avg(steps, nsim, y0, t0, T, f, pp) - exact_sol(T))
        push!(errors_de, error_de)
    end

    # Plotting the error
    plot(nsims, errors_de, xaxis=:log, yaxis=:log, label="debiased euler", marker=:circle,
        xlabel="nsim", ylabel="Error", title="Convergence of Euler Steps")
    plot!(nsims, nsims .^ (-0.5), label="O(nsim^{-0.5})", linestyle=:dash)

end