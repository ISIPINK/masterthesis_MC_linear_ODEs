#doesnt seem to help
using Plots
using Distributions
using Sobol
using Statistics

function euler_steps(y, t0, t, f, n)
    h = (t - t0) / n
    for _ in 1:n
        y += h * f(t0, y)
        t0 += h
    end
    y
end

euler_step(y, t0, t, f) = y + (t - t0) * f(t, y)

function debiased_euler_step(y, t0, t, f, l, fix=0)
    (l > 0.4) ? error("l must be less than 0.4") : nothing
    if (fix == 1) ? true : (fix != 2 && rand() < l)
        z = debiased_euler_step(y, t0, (t + t0) / 2, f, l)
        z = debiased_euler_step(z, (t + t0) / 2, t, f, l)
        return (z + euler_step(y, t0, t, f) * (l - 1)) / l
    else
        return euler_step(y, t0, t, f)
    end
end

function debiased_euler_steps(y, t0, t, f, l, n)
    h = (t - t0) / n
    numones = rand(Binomial(n, l))
    numzeros = n - numones
    for _ in 1:n
        sone = Bool((numones / (numones + numzeros) > rand()))
        if sone
            numones -= 1
        else
            numzeros -= 1
        end
        y = debiased_euler_step(y, t0, t0 + h, f, l, (sone) ? 1 : 2)
        t0 += h
    end
    y
end

function debiased_euler_steps_strat(y, t0, t, f, l, n, sobol_gen)
    h = (t - t0) / n
    numones = quantile(Binomial(n, l), next!(sobol_gen))[1]
    numzeros = n - numones
    for _ in 1:n
        sone = Bool((numones / (numones + numzeros) > rand()))
        if sone
            numones -= 1
        else
            numzeros -= 1
        end
        y = debiased_euler_step(y, t0, t0 + h, f, l, (sone) ? 1 : 2)
        t0 += h
    end
    y
end


b(t) = (t < 0.5) ? 1 : 0
function f(t, y)
    global f_call_count += 1
    y
end
sol(t) = exp(t)

global f_call_count = 0
y0 = 1.0
t0 = 0.0
t = 1  # Final time to evaluate the solution
leuler = 0.25
steps = 100
nsim = 10000
stratss = zeros(nsim)
for i in 1:nsim
    if i % 2 == 0
        sobol_gen = SobolSeq(1)
    end
    stratss[i] = debiased_euler_steps_strat(y0, t0, t, f, leuler, steps, sobol_gen)
end
ss = [debiased_euler_steps(y0, t0, t, f, leuler, steps) for _ in 1:nsim]

println(mean(stratss), " ", sqrt(var(stratss)))
println(mean(ss), " ", sqrt(var(ss)))