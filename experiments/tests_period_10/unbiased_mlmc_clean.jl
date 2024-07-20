using Plots
using Roots
using Statistics

euler_step(y, t0, t, f) = y + (t - t0) * f(t0, y)

rand_euler_step(y, t0, t, f) = y + (t - t0) * f(t0 + (t - t0) * rand(), y)

function midpoint_step(y, t0, t, f)
    z = y + (t - t0) * f(t0, y) / 2
    y + (t - t0) * f((t + t0) / 2, z)
end

function rand_midpoint_step(y, t0, t, f)
    dt = (t - t0) * rand()
    z = y + dt * f(t0, y)
    y + (t - t0) * f(t0 + dt, z)
end

function implicit_euler_step(y0, t0, t, f)
    find_zero(y -> y - y0 - (t - t0) * f(t, y), y0)
end

function implicit_midpoint_step(y0, t0, t, f)
    find_zero(y -> y - y0 - (t - t0) * f((t + t0) / 2, (y0 + y) / 2), y0)
end

function implicit_rand_midpoint_step(y0, t0, t, f)
    u = rand()
    find_zero(y -> y - y0 - (t - t0) * f(t0 + (t - t0) * u, (1 - u) * y0 + u * y), y0)
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

function rec_debiaser(step, l; depthlimit=15)
    (l > 0.40) ? error("l must be less than 0.5 but we enforce 0.40") : nothing
    function dstep(y, t0, t, f, depth=0)
        rounded_depth_limit = (depthlimit - floor(depthlimit) < rand()) ? ceil(depthlimit) : floor(depthlimit)
        if rand() < l && depth <= rounded_depth_limit
            z = dstep(y, t0, (t + t0) / 2, f, depth + 1)
            z = dstep(z, (t + t0) / 2, t, f, depth + 1)
            return (z + step(y, t0, t, f) * (l - 1)) / l
        else
            return step(y, t0, t, f)
        end
    end
    dstep
end

struct IVP
    f::Function  # The problem function 'f'
    sol::Function  # The solution function 'sol'
    y0::Float64  # Initial condition for 'y'
    t0::Float64  # Initial time
    t::Float64  # Final time
end

function IVP_lin_const_coef(; y0=1.0, t0=0.0, t=1.0, alpha=1.0)
    function f(t, y)
        global f_call_count += 1
        alpha * y + (1 - alpha) * exp(t)
    end
    sol(t) = exp(t)
    IVP(f, sol, y0, t0, t)
end

function IVP_lin_var_coef(; y0=1.0, t0=0.0, t=1.0, alpha=1.0)
    function f(t, y)
        global f_call_count += 1
        (1 + alpha * t^2) * y + (1 - (1 + alpha * t^2)) * exp(t)
        # sin(alpha * pi * (t + 1)^2) * y + (1 - sin(alpha * pi * (t + 1)^2)) * exp(t)
    end
    sol(t) = exp(t)
    IVP(f, sol, y0, t0, t)
end

function IVP_nonlinear(; y0=1.0, t0=0.0, t=1.0, alpha=1.0)
    function f(t, y)
        global f_call_count += 1
        y + alpha * (sin(y / 2) - sin(exp(t) / 2))
    end
    sol(t) = exp(t)
    IVP(f, sol, y0, t0, t)
end

function IVP_stiff(; y0=1.0, t0=0.0, t=1.0, alpha=1.0)
    function f(t, y)
        global f_call_count += 1
        -alpha * y + (alpha + 1) * exp(t)
    end
    sol(t) = exp(t)
    IVP(f, sol, y0, t0, t)
end



function convergence_plot(ivp, step, label, plt, orderlines=[], varlines=false)
    nn = Int.(round.(10 .^ (0.5:0.05:2.5)))
    nn = vcat(nn, Int.(round.(10 .^ (2.5:0.2:4))))
    # nn = Int.(round.(10 .^ (1:0.001:4)))
    errors, errors_avg, variances, f_calls = [], [], [], []
    nsim = 100
    for n in nn
        global f_call_count = 0
        # nsim = (n <= 100) ? 1000 : ((n <= 1000) ? 100 : 10)
        # nsim = (n <= 1000) ? 16 : 4
        appsols = [multi_steps(n, step, ivp.y0, ivp.t0, ivp.t, ivp.f) for _ in 1:nsim]
        error = sum((ivp.sol(ivp.t) - appsol)^2 for appsol in appsols) / nsim
        error_avg = abs(ivp.sol(ivp.t) - mean(appsols))
        varr = var(appsols)
        push!(errors, sqrt(error))
        push!(errors_avg, error_avg)
        push!(f_calls, f_call_count / nsim)
        push!(variances, varr)
    end
    scatter!(plt, f_calls, min.(errors, 10^17) .+ eps(), label=label, alpha=0.5)
    scatter!(plt, f_calls, min.(errors_avg, 10^17) .+ eps(), label="avg $label", alpha=0.5)

    if sqrt(variances[end]) > 100 * eps() && varlines
        plot!(plt, f_calls, sqrt.(variances) .+ eps(), label="std $label", linestyle=:dash)
    end

    ff = range(minimum(f_calls), maximum(f_calls), length=100)

    for o in orderlines
        plot!(plt, ff, ff .^ (-o) .* errors[end] / ff[end]^(-o), label="o(n^{-$o})", linestyle=:dashdot)
    end
end

# explicit euler convergence test
begin
    # ivp = IVP_lin_const_coef(alpha=1)
    ivp = IVP_lin_var_coef(alpha=1.5)
    # ivp = IVP_nonlinear(alpha=1.5)
    global f_call_count = 0
    t = 2  # Final time to evaluate the solution
    leuler = 0.2

    plt = plot(title="convergence in steps", ylabel="RMSE", xlabel="amount of functions calls", xscale=:log10, yscale=:log10, legend=:bottomleft, legendfontsize=7)
    convergence_plot(ivp, euler_step, "Euler", plt, [1])
    convergence_plot(ivp, rec_debiaser(euler_step, leuler, depthlimit=20), "debiased Euler", plt, [1.5], true)
    convergence_plot(ivp, rand_euler_step, "rand Euler", plt, [])
    convergence_plot(ivp, rec_debiaser(rand_euler_step, leuler, depthlimit=2), "debiased randomized Euler, depth =2", plt, [], true)
    display(plt)
end

# compare debiased euler vs rand midpoint
begin
    ivp = IVP_lin_const_coef(alpha=1)
    # ivp = IVP_lin_var_coef(alpha=1)
    # ivp = IVP_nonlinear(alpha=1.5)
    global f_call_count = 0
    t = 2  # Final time to evaluate the solution
    leuler = 0.2

    plt = plot(title="convergence in steps", ylabel="RMSE", xlabel="amount of functions calls", xscale=:log10, yscale=:log10, legend=:bottomleft)
    convergence_plot(ivp, rand_midpoint_step, "rand_midpoint", plt, [1.5])
    convergence_plot(ivp, rec_debiaser(euler_step, leuler), "debiased  Euler", plt, [1.5], true)
    convergence_plot(ivp, rec_debiaser(rand_midpoint_step, leuler), "debiased  rand midpoint", plt, [1.5], true)
    display(plt)
end

# explicit midpoint convergence test
begin
    # ivp = IVP_lin_const_coef(alpha=1)
    ivp = IVP_lin_var_coef(alpha=1.5)
    global f_call_count = 0

    t = 2  # Final time to evaluate the solution
    lmid = 0.05

    plt = plot(title="convergence in steps", ylabel="RMSE", xlabel="amount of functions calls", xscale=:log10, yscale=:log10, legend=:bottomleft)
    convergence_plot(ivp, midpoint_step, "midpoint", plt, [2])
    convergence_plot(ivp, rec_debiaser(midpoint_step, lmid), "debiased midpoint", plt, [2.5], true)
    display(plt)
end

# implicit convergence test
# implicit euler uses extra function calls to solve an equation
# which messes with the convergence
# acceleration by reusing outer recursion for a better guess should be significant
begin
    # ivp = IVP_lin_const_coef(alpha=1)
    # ivp = IVP_lin_var_coef(alpha=1)
    # ivp = IVP_nonlinear(alpha=1.5)
    ivp = IVP_stiff(alpha=100)

    global f_call_count = 0
    leuler = 0.2
    limpl = 0.1

    plt = plot(xscale=:log10, yscale=:log10, legend=:bottomleft, legendfontsize=7)
    convergence_plot(ivp, implicit_euler_step, "implicit Euler", plt, [])
    convergence_plot(ivp, rec_debiaser(implicit_euler_step, limpl), "debiased implicit Euler", plt, [1.5], true)
    convergence_plot(ivp, implicit_rand_midpoint_step, "rand implicit midpoint", plt, [1.5], true)
    display(plt)
end

# implicit midpoint
begin
    # ivp = IVP_lin_const_coef(alpha=1)
    # ivp = IVP_lin_var_coef(alpha=1)
    # ivp = IVP_nonlinear(alpha=1.5)
    ivp = IVP_stiff(alpha=50)

    global f_call_count = 0
    limpl = 0.1

    plt = plot(xscale=:log10, yscale=:log10, legend=:bottomleft, legendfontsize=7)
    convergence_plot(ivp, implicit_midpoint_step, "implicit midpoint", plt, [2])
    convergence_plot(ivp, rec_debiaser(implicit_midpoint_step, limpl), "debiased implicit midpoint", plt, [2.5], true)
    display(plt)
end



function convergence_plot_nsim(ivp, step, steps, label, plt, orderlines=[], onsim=3.5)
    nsims = Int.(round.(10 .^ (0:0.2:onsim)))
    errors = []
    for nsim in nsims
        nn = 100
        error = sum(abs(ivp.sol(ivp.t) - multi_steps_avg(steps, nsim, step, ivp.y0, ivp.t0, ivp.t, ivp.f))^2 for _ in 1:nn) / nn
        push!(errors, sqrt(error))
    end
    scatter!(plt, nsims, errors, label=label, alpha=0.5)
    for o in orderlines
        plot!(plt, nsims, nsims .^ (-o) .* errors[end] / nsims[end]^(-o), label="o(n^{-$o})", linestyle=:dash)
    end
end


begin
    ivp = IVP_lin_var_coef(alpha=1.5)
    global f_call_count = 0
    steps = 4
    leuler = 0.2
    lmid = 0.1

    plt = plot(xscale=:log10, yscale=:log10)
    convergence_plot_nsim(ivp, rec_debiaser(euler_step, leuler), steps, "debiased Euler", plt, [0.5])
    convergence_plot_nsim(ivp, rec_debiaser(rand_euler_step, leuler), steps, "debiased randomized Euler", plt, [0.5])
    convergence_plot_nsim(ivp, rec_debiaser(midpoint_step, lmid), steps, "debiased midpoint", plt, [0.5])
    # convergence_plot_nsim(ivp, rec_debiaser(rand_midpoint_step, lmid), steps, "debiased midpoint", plt, [0.5])
    convergence_plot_nsim(ivp, rand_midpoint_step, steps, "rand midpoint", plt, [0.0])

    display(plt)
end

begin
    ivp = IVP_lin_var_coef(alpha=1.5)
    global f_call_count = 0
    steps = 4
    limpl = 0.1

    plt = plot(xscale=:log10, yscale=:log10)
    convergence_plot_nsim(ivp, rec_debiaser(implicit_euler_step, limpl), steps, "debiased implicit Euler", plt, [0.5], 3.5)
    display(plt)
end

