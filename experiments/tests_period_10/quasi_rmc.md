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

We tried this but cant make it work
we are reading a book on quasi monte carlo
now. There is a section on Poisson processes
Strategies for Quasi-Monte Carlo but
were not sure we are going to try that.

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

# Quasi MC on the Poisson proces

```julia
using Sobol, Distributions, Plots

function quasi_random_poisson(lambda::Float64, n::Int)
    sobol_gen = SobolSeq(1)  # Initialize a Sobol sequence generator for 1 dimension
    sobol_samples = [next!(sobol_gen)[1] for _ in 1:n]  # Generate n points

    pos =Poisson(lambda)
    ss = quantile.(pos,sobol_samples)
    print(ss)
    p= histogram(ss,label="",bins=30)

    display(p)
end

quasi_random_poisson(5.0,2^6)
pos = Poisson(10.0)
histogram(quantile.(pos,rand(100)),label="",bins=20)
```

```julia
using Random
using Sobol, Distributions, Plots

using LinearAlgebra
function Y(tt, sig, A::Function, y0)
    sol = y0
    for s in tt
        sol += A(s) * sol  ./ sig
    end
    sol
end

function qtimes(t,sig,sobol_gen)
N = quantile(Poisson(t*sig),next!(sobol_gen) )[1]
sort!(rand(N)) .*t
end

function qqtimes(t,sig,sobol_gen2)
Ns = quantile.(Poisson(t*sig/2),next!(sobol_gen2) )
u1 = rand(Ns[1])
u2 = 1 .+ rand(Ns[2])
sort!(vcat(u1,u2)) .*t/2
end

function times(t,sig)
N = quantile(Poisson(t*sig),rand() )[1]
sort!(rand(N)) .*t
end

y0 = [1; 1]
A(t) = [1+cos(t) -cos(t); cos(t) 1-cos(t)]
sol(t) = [exp(t); exp(t)]
sig = 10.0
nsim = 10^2
t = 2

Random.seed!(24)
sobol_gen = SobolSeq(1)
qsol = sum(Y(qtimes(t,sig,sobol_gen),sig,A,y0) for _ in 1:nsim)/nsim
rsol = sum(Y(times(t,sig),sig,A,y0) for _ in 1:nsim)/nsim
println(qsol)
println(rsol)



# Initialize variable
sig = 10.0 # Assuming a fixed sig value for demonstration
t = 0.5
nsim_values = Int.(round.(10 .^ (1.0:0.02:4))) # Denser sampling up to fifth order
nsim_values = unique(vcat(nsim_values, Int.(round.(10 .^(4:0.5:6))))) # Combine and ensure uniqueness

qsol_values = []
qqsol_values = []
rsol_values = []

Random.seed!(26)
# Loop over nsim values
for nsim in nsim_values
    sobol_gen = SobolSeq(1)
    sobol_gen2 = SobolSeq(2)

    qsol = sum(Y(qtimes(t,sig, sobol_gen), sig, A, y0) for _ in 1:nsim) / nsim
    qqsol = sum(Y(qqtimes(t,sig, sobol_gen2), sig, A, y0) for _ in 1:nsim) / nsim
    rsol = sum(Y(times(t,sig), sig, A, y0) for _ in 1:nsim) / nsim
    push!(qsol_values, qsol)
    push!(qqsol_values, qqsol)
    push!(rsol_values, rsol)
end

# Assuming sol(1) and norm are defined elsewhere
qerror = [norm(s-sol(t)) for s in qsol_values]
qqerror = [norm(s-sol(t)) for s in qqsol_values]
rerror = [norm(s-sol(t)) for s in rsol_values]

using Plots

# Plotting
p = plot(nsim_values, qerror, label="Q-Solution", title="Convergence Plot", xlabel="nsim", ylabel="Solution Value", xscale=:log10, yscale=:log10)
plot!(p,nsim_values, qqerror, label="QQ-Solution", title="Convergence Plot", xlabel="nsim", ylabel="Solution Value", xscale=:log10, yscale=:log10)
plot!(p, nsim_values, rerror, label="R-Solution", xscale=:log10, yscale=:log10)

plot!(p, nsim_values, nsim_values .^ (-0.5), label="-0.5", linestyle=:dash)
plot!(p, nsim_values, nsim_values .^ (-1), label="-1", linestyle=:dash)
display(p)


```

![convergence nsim condition N](./plts/convergence_nsim_condition_on_N.svg) <br>
Stratifying the N is definitely a thing. <br>  
The same plot for sig would be interesting.

```julia
using Random, Sobol, Distributions, Plots, LinearAlgebra

function Y(tt, sig, A::Function, y0)
    sol = y0
    for s in tt
        sol += A(s) * sol ./ sig
    end
    sol
end

function times(t,sig)
N = quantile(Poisson(t*sig),rand() )[1]
sort!(rand(N)) .*t
end

function qtimes(t, sig, sobol_gen, k)
    Ns = quantile.(Poisson(t * sig / k), next!(sobol_gen))
    sort!(vcat([rand(Ns[i]) .+ i .- 1 for i in 1:k]...)) .* t / k
end

function convergence_compare(sig_values, nsim_values, t, y0, A, sol,k)
    p = plot()
    for nsim in nsim_values
        qsol_values = []
        rsol_values = []
        for sig in sig_values
            sobol_gen = SobolSeq(k)
            qsol = sum(Y(qtimes(t, sig, sobol_gen, k), sig, A, y0) for _ in 1:nsim) / nsim
            rsol = sum(Y(times(t,sig), sig, A, y0) for _ in 1:nsim) / nsim
            push!(qsol_values, qsol)
            push!(rsol_values, rsol)
        end
        qerror = [norm(s - sol(t)) for s in qsol_values]
        rerror = [norm(s - sol(t)) for s in rsol_values]
        plot!(p,sig_values, qerror, label="Q-Solution nsim=$nsim", title="Convergence Plot", xlabel="sig", ylabel="Error", xscale=:log10, yscale=:log10)
        plot!(p, sig_values, rerror, label="R-Solution nsim=$nsim", xscale=:log10, yscale=:log10)
    end
    plot!(p,sig_values, sig_values .^(-0.5),label="-0.5",linestyle=:dash)
    plot!(p,sig_values, sig_values .^(-1),label="-1",linestyle=:dash)
    display(p)
end

# Define parameters
y0 = [1; 1]
A(t) = [1 + cos(t) -cos(t); cos(t) 1 - cos(t)]
sol(t) = [exp(t); exp(t)]
t = 2
sig_values = Int.(round.(10 .^(1.0:0.02:3.5)))
nsim_values = [1, 100]
k = 1

Random.seed!(21)
# Call the function
convergence_compare(sig_values, nsim_values, t, y0, A, sol,k)

```

Ok conditioning on N also helps convergence on sig
![convergence sig condition on N](./plts/convergence_sig_condition_on_N.svg)
