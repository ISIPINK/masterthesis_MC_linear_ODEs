function Y(t, sig, A::Function, f::Function, y0)
    (s = -log(rand()) / sig; sol = y0)
    s > t && return sol
    while s < t
        sol += (A(s) * sol .+ f(s)) ./ sig
        s -= log(rand()) / sig
    end
    sol
end

using Plots
sig = 1.0
A(s) = 1.0
f(s) = 0.0
q = 1.0
tt = [exp10(-i) for i in range(1, 5, 100)]
yy = abs.(Y.(tt, sig, A, f, q) - exp.(tt))
yys = abs.(Y.(tt, 1 ./ tt, A, f, q) - exp.(tt))
# yys = [Y(t,1/t,A,f,q) for t in tt]
# yys = abs.(yys-exp.(tt)) .+eps()

plot(tt, yy, st=:scatter, xscale=:log10, yscale=:log10, label="Y(t)")
plot!(tt, yys, st=:scatter, xscale=:log10, yscale=:log10, label="Y(t)s")
plot!(tt, tt, label="t")
plot!(tt, tt .^ 2, label="t^2")

#test 2
ttss = [exp10(-i) for i in range(1, 4, 50)]
yyss = abs.(Y.(1, 1 ./ ttss, A, f, q) - exp.(ttss)) .+ eps()
plot(ttss, yyss, st=:scatter, xscale=:log10, yscale=:log10, label="Y(t)")




