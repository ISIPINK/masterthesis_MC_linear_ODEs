using Plots
using Roots
using Statistics

euler_step(y, t0, t, f) = y + (t - t0) * f(t0, y)

randomized_euler_step(y, t0, t, f) = y + (t - t0) * f(t0 + (t - t0) * rand(), y)

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
    function dstep(y, t0, t, f, depth=0)
        if rand() < l  #&& depth <= 3
            z = dstep(y, t0, (t + t0) / 2, f, depth + 1)
            z = dstep(z, (t + t0) / 2, t, f, depth + 1)
            return (z + step(y, t0, t, f) * (l - 1)) / l
        else
            return step(y, t0, t, f)
        end
    end
    dstep
end

function convergence_plot(y, t0, t, f, sol, step, label, plt, orderlines=[])
    nn = Int.(round.(10 .^ (0.5:0.05:2.5)))
    # nn = vcat(nn, Int.(round.(10 .^ (2.5:0.2:4))))
    # nn = Int.(round.(10 .^ (1:0.001:4)))
    errors = []
    errors_avg = []
    variances = []
    f_calls = []
    nsim = 100
    for n in nn
        global f_call_count = 0
        # nsim = (n <= 100) ? 1000 : ((n <= 1000) ? 100 : 10)
        # nsim = (n <= 1000) ? 16 : 4
        appsols = [multi_steps(n, step, y, t0, t, f) for _ in 1:nsim]
        error = sum((sol(t) - appsol)^2 for appsol in appsols) / nsim
        error_avg = abs(sol(t) - mean(appsols))
        # error = (sol(t) - multi_steps(n, step, y, t0, t, f))^2 
        varr = var(appsols)
        push!(errors, sqrt(error))
        push!(errors_avg, error_avg)
        push!(f_calls, f_call_count / nsim)
        push!(variances, varr)
        # push!(f_calls, f_call_count )
    end
    scatter!(plt, f_calls, min.(errors, 10^17) .+ eps(), label=label, alpha=0.5)
    scatter!(plt, f_calls, min.(errors_avg, 10^17) .+ eps(), label="avg $label", alpha=0.5)

    if sqrt(variances[end]) > 100 * eps()
        plot!(plt, f_calls, sqrt.(variances) .+ eps(), label="std $label", linestyle=:dash)
        plot!(plt, f_calls, sqrt.(variances ./ nsim) .+ eps(), label="std $label", linestyle=:dash)
    end

    ff = range(minimum(f_calls), maximum(f_calls), length=100)

    for o in orderlines
        plot!(plt, ff, ff .^ (-o) .* errors[end] / ff[end]^(-o), label="o(n^{-$o})", linestyle=:dashdot)
    end
end

println(eps())
# explicit convergence test
begin
    # b(t) = (t < 0.5) ? 1 : 0
    b(t) = (4 * t - round(4 * t) < 0.5) ? 2 : 0
    function f(t, y)
        global f_call_count += 1
        y + b(t) * sin(y) - b(t) * sin(exp(t))
        # (1 + b(t)) * y - b(t) * exp(t)
        # y + sin(y / 2) - sin(exp(t) / 2)
        # y +  2*sin(5*(t+1) * y) -  2*sin(5*(t+1) *exp(t))
        # y + 15 * log(5 * (sin(4 * t) + 1) * abs(y)) - 15 * log(5 * (sin(4 * t) + 1) * exp(t))
        # y
        # sin(2 * pi * (t + 1)^2) * y + (1 - sin(2 * pi * (t + 1)^2)) * exp(t)
        # (1 + t^2) * y + (1 - (1 + t^2)) * exp(t)
        # 5 * y - 4 * exp(t)
    end

    sol(t) = exp(t)


    # Ap(t) = (t < 0.5) ? 1 : -1
    # function f(t, y)
    #     global f_call_count += 1
    #     Ap(t - floor(t)) * y
    # end

    # solp(t) = (t < 0.5) ? exp(t) : exp(1 - t)
    # sol(t) = solp(t - floor(t))


    global f_call_count = 0
    y0 = 1.0
    t0 = 0.0
    t = 2  # Final time to evaluate the solution
    leuler = 0.25
    lmid = 0.1

    plt = plot(title="convergence in steps", ylabel="RMSE", xlabel="amount of functions calls", xscale=:log10, yscale=:log10, legend=:bottomleft)
    convergence_plot(y0, t0, t, f, sol, euler_step, "Euler", plt, [])
    convergence_plot(y0, t0, t, f, sol, rec_debiaser(euler_step, leuler), "debiased Euler", plt, [])
    convergence_plot(y0, t0, t, f, sol, randomized_euler_step, "rand Euler", plt, [])
    convergence_plot(y0, t0, t, f, sol, rec_debiaser(randomized_euler_step, leuler), "debiased randomized Euler", plt, [])
    # convergence_plot(y0, t0, t, f, sol, midpoint_step, "midpoint", plt, [2])
    # convergence_plot(y0, t0, t, f, sol, rec_debiaser(midpoint_step, lmid), "debiased midpoint", plt, [2.5])
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
    t = 2  # Final time to evaluate the solution
    leuler = 0.2
    limpl = 0.1

    plt = plot(xscale=:log10, yscale=:log10, legend=:topright)
    # convergence_plot(y0, t0, t, f, sol, euler_step, "Euler", plt, [])
    # convergence_plot(y0, t0, t, f, sol, rec_debiaser(euler_step, leuler), "debiased Euler", plt, [])
    convergence_plot(y0, t0, t, f, sol, implicit_euler_step, "implicit Euler", plt, [])
    convergence_plot(y0, t0, t, f, sol, rec_debiaser(implicit_euler_step, limpl), "debiased implicit Euler", plt)
    display(plt)
end



function convergence_plot_nsim(y, t0, t, f, sol, step, steps, label, plt, orderlines=[], onsim=3.5)
    nsims = Int.(round.(10 .^ (1:0.2:onsim)))
    errors = []
    for nsim in nsims
        nn = 100
        error = sum(abs(sol(t) - multi_steps_avg(steps, nsim, step, y, t0, t, f))^2 for _ in 1:nn) / nn
        push!(errors, sqrt(error))
    end
    scatter!(plt, nsims, errors, label=label, alpha=0.5)
    for o in orderlines
        plot!(plt, nsims, nsims .^ (-o) .* errors[end] / nsims[end]^(-o), label="o(n^{-$o})", linestyle=:dash)
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

    plt = plot(xscale=:log10, yscale=:log10)
    convergence_plot_nsim(y0, t0, t, f, sol, rec_debiaser(euler_step, leuler), steps, "debiased Euler", plt, [0.5])
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

