# Quasi MC example

```julia
using Sobol, Plots, Random

function integrate_f_qmc(N)
    sobol = SobolSeq(2)
    integral = sum([next!(sobol)...] |> p -> p[1]^2 + p[2]^2 for _ in 1:N) / N
    return integral
end

function integrate_f_mc(N)
    integral = sum([rand(), rand()] |> p -> p[1]^2 + p[2]^2 for _ in 1:N) / N
    return integral
end

Ns = round.(Int, 10 .^ (0:0.05:5))

exact_integral = 2 / 3
errors_qmc = [abs(integrate_f_qmc(N) - exact_integral) for N in Ns]
errors_mc = [abs(integrate_f_mc(N) - exact_integral) for N in Ns]

p = plot(Ns, errors_qmc, label="QMC Error", xscale=:log10, yscale=:log10, xlabel="Number of Points", ylabel="Error", title="QMC vs MC Integration Error")
plot!(p,Ns, Ns.^(-0.5)/10, label="O(N^(-0.5))")
plot!(p,Ns, Ns.^(-1), label="O(N^(-1))")
plot!(p,Ns, errors_mc, label="MC Error", xscale=:log10, yscale=:log10)
```

![alt](./plts/qmc_convergence.svg)

# Poisson expansion of a linear ODE

Consider following linear ODE:

$$
y_{t} = A(t)y.
$$

In the second dutch presentation we present following result:

$$
    \begin{aligned}
        y(t) & = E \left[\prod_{k=0}^{N_{t}}\left( I + \frac{A(T_{k})}{\sigma} \right)    \right] y(0)                                             \\
             & = \sum_{n=0}^{\infty}\frac{\sigma^{n} t ^{n}}{n!} E \left[\prod_{k=0}^{n}\left( I + \frac{A(T^{n}_{k})}{\sigma} \right)    \right] y(0)
    \end{aligned}
.
$$

With $(T^{n}_{k})_{1 \le  k \le n }$ =

```julia
n = 10 # this needs to be a number
sort([rand() for _ in 1:n])
```

The idea is to cut off the sum for some $n$. Then we obtain low dimensional
integrals we can approx with qmc.

# Example problem

$$
\begin{aligned}
y_0 &= \begin{bmatrix} 1 \\ 1 \end{bmatrix}, \\
A(t) &= \begin{bmatrix} 1+\cos(t) & -\cos(t) \\ \cos(t) & 1-\cos(t) \end{bmatrix}, \\
\text{sol}(t) &= \begin{bmatrix} e^t \\ e^t \end{bmatrix}
\end{aligned}
.
$$

# Generating sorted n uniform QMC

We tries this but cant make it work
we are reading a book on quasi monte carlo
now.

```julia

using Sobol, Plots

n = 10
sobol_seq = SobolSeq(n)

function generate_and_plot_sobol_samples!(plt, n, level, skip_steps)
    # Skip a certain number of steps in the Sobol sequence
    skip(sobol_seq, skip_steps)

    # Generate and sort samples
    sorted_samples = sort(next!(sobol_seq))
    y_values = fill(level, length(sorted_samples))  # Set y-coordinates to the level
    scatter!(plt, 1:n, y_values, label = "")  # Use 1:n as x-coordinates for clarity
end

n = 10  # Number of samples per simulation
simulations = 10  # Number of simulations
level_offset = 1  # Offset between each simulation's level
skip_steps = 100  # Number of steps to skip in the Sobol sequence for each simulation

plt = plot(title = "Sobol Sequence Simulations", xlabel = "Sample Index", ylabel = "Simulation Level", legend = :topright)

for sim in 1:simulations
    generate_and_plot_sobol_samples!(plt, n, sim * level_offset, skip_steps)
    skip_steps+=100
end

display(plt)
```
