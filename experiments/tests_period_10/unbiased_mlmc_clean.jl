using Plots
using Roots

euler_step(y, t0, t, f) = y + (t - t0) * f(t, y)

function midpoint_step(y, t0, t, f)
    z = y + (t - t0) * f(t0, y) / 2
    y + (t - t0) * f((t + t0) / 2, z)
end


function implicit_euler_step(y0, t0, t, f)
    find_zero(y -> y - y0 - (t - t0) * f(t, y), y0)
end


function multi_steps(n, step, y, t0, t, f)
    h = (t - t0) / n
    for j in 1:n
        y = step(y, t0 + (j - 1) * h, t0 + j * h, f)
    end
    y
end

function multi_steps_avg(n, nsim, step, y, t0, t, f)
    sum(multi_steps(n, step, y, t0, t, f) for _ in 1:nsim) / nsim
end

function rec_debiaser(step, l)
    (l > 0.45) ? error("l must be less than 0.45") : nothing
    function dstep(y, t0, t, f)
        if rand() < l
            z = dstep(y, t0, (t + t0) / 2, f)
            z = dstep(z, (t + t0) / 2, t, f)
            return (z + step(y, t0, t, f) * (l - 1)) / l
        else
            return step(y, t0, t, f)
        end
    end
    dstep
end

function convergence_plot(y, t0, t, f, sol, step, label, plt, orderlines=[])
    nn = Int.(round.(10 .^ (1:0.002:4)))
    errors = []
    f_calls = []
    for n in nn
        global f_call_count = 0
        error = abs(sol(t) - multi_steps(n, step, y, t0, t, f))
        push!(errors, error)
        push!(f_calls, f_call_count)
    end
    scatter!(plt, f_calls, min.(errors, 10^5), label=label, alpha=0.5)
    ff = range(minimum(f_calls), maximum(f_calls), length=100)
    for o in orderlines
        plot!(plt, ff, ff .^ (-o), label="o(n^{-$o})", linestyle=:dash)
    end
end


# explicit convergence test
begin
    b(t) = (t < 0.5) ? 1 : 0
    function f(t, y)
        global f_call_count += 1
        # y + b(t)*sin(y) - b(t)*sin(exp(t))
        # y + sin(y / 2) - sin(exp(t) / 2)
        # y +  sin(10 * y) -  sin(10 *exp(t))
        # y
        # sin(2 * pi * t) * y + (1 - sin(2 * pi * t)) * exp(t)
        (1 + t^2) * y + (1 - (1 + t^2)) * exp(t)
        # 5 * y - 4 * exp(t)
    end

    sol(t) = exp(t)
    global f_call_count = 0
    y0 = 1.0
    t0 = 0.0
    t = 2  # Final time to evaluate the solution
    leuler = 0.2
    lmid = 0.1

    plt = plot(xscale=:log10, yscale=:log10, legend=:bottomleft)
    convergence_plot(y0, t0, t, f, sol, euler_step, "Euler", plt, [])
    convergence_plot(y0, t0, t, f, sol, rec_debiaser(euler_step, leuler), "debiased Euler", plt, [])
    convergence_plot(y0, t0, t, f, sol, midpoint_step, "midpoint", plt, [])
    convergence_plot(y0, t0, t, f, sol, rec_debiaser(midpoint_step, lmid), "debiased midpoint", plt, [1, 1.5, 2, 2.5])
    display(plt)
end
# implicit convergence test
# implicit euler uses extra function calls to solve an equation
# which messes with the convergence
# acceleration by a better guess should be significant
begin
    b(t) = (t < 0.5) ? 1 : 0
    function f(t, y)
        global f_call_count += 1
        # y + b(t)*sin(y) - b(t)*sin(exp(t))
        # y + sin(y / 2) - sin(exp(t) / 2)
        -100 * y + 101 * exp(t)
        # 3 * y - 2 * exp(t)
        # y + sin(10 * y) - sin(10 * exp(t))
        # y
    end

    sol(t) = exp(t)
    global f_call_count = 0
    y0 = 1.0
    t0 = 0.0
    t = 1  # Final time to evaluate the solution
    leuler = 0.2
    limpl = 0.25

    plt = plot(xscale=:log10, yscale=:log10, legend=:topright)
    # convergence_plot(y0, t0, t, f, sol, euler_step, "Euler", plt, [])
    # convergence_plot(y0, t0, t, f, sol, rec_debiaser(euler_step, leuler), "debiased Euler", plt, [])
    convergence_plot(y0, t0, t, f, sol, implicit_euler_step, "implicit Euler", plt, [])
    convergence_plot(y0, t0, t, f, sol, rec_debiaser(implicit_euler_step, limpl), "debiased implicit Euler", plt, [1, 1.5])
    display(plt)
end



function convergence_plot_nsim(y, t0, t, f, sol, step, steps, label, plt, orderlines=[], onsim=5)
    nsims = Int.(round.(10 .^ (1:0.03:onsim)))
    errors = []
    for nsim in nsims
        error = abs(sol(t) - multi_steps_avg(steps, nsim, step, y, t0, t, f))
        push!(errors, error)
    end
    scatter!(plt, nsims, errors, label=label, alpha=0.5)
    for o in orderlines
        plot!(plt, nsims, nsims .^ (-o), label="o(n^{-$o})", linestyle=:dash)
    end
end


begin
    b(t) = (t < 0.5) ? 1 : 0
    function f(t, y)
        global f_call_count += 1
        # y + b(t)*sin(y) - b(t)*sin(exp(t))
        # y + sin(y / 2) - sin(exp(t) / 2)
        # y +  sin(10 * y) -  sin(10 *exp(t))
        # sin(2 * pi * t) * y + (1 - sin(2 * pi * t)) * exp(t)
        (1 + t^2) * y + (1 - (1 + t^2)) * exp(t)
        # y
    end

    sol(t) = exp(t)

    global f_call_count = 0
    y0 = 1.0
    t0 = 0.0
    t = 2  # Final time to evaluate the solution
    steps = 4
    leuler = 0.2
    lmid = 0.1
    limpl = 0.2

    plt = plot(xscale=:log10, yscale=:log10)
    convergence_plot_nsim(y0, t0, t, f, sol, rec_debiaser(euler_step, leuler), steps, "debiased Euler", plt, [])
    convergence_plot_nsim(y0, t0, t, f, sol, rec_debiaser(midpoint_step, lmid), steps, "debiased midpoint", plt, [0.5])

    display(plt)
end

begin
    b(t) = (t < 0.5) ? 1 : 0
    function f(t, y)
        global f_call_count += 1
        # y + b(t)*sin(y) - b(t)*sin(exp(t))
        # y + sin(y / 2) - sin(exp(t) / 2)
        # y +  sin(10 * y) -  sin(10 *exp(t))
        # -100 * y + 101 * exp(t)
        (1 + t^2 / 2) * y + (1 - (1 + t^2 / 2)) * exp(t)
        # y
    end

    sol(t) = exp(t)

    global f_call_count = 0
    y0 = 1.0
    t0 = 0.0
    t = 2  # Final time to evaluate the solution
    steps = 10
    limpl = 0.2

    plt = plot(xscale=:log10, yscale=:log10)
    convergence_plot_nsim(y0, t0, t, f, sol, rec_debiaser(implicit_euler_step, limpl), steps, "debiased implicit Euler", plt, [0.5], 4.5)
    display(plt)
end

