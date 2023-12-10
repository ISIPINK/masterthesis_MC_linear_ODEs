@inline U() = rand()
@inline B(p) = U() < p

let # biased euler example
    Y(t, ε) = t > ε ? 1 + t * Y(U() * t, ε) : 1
    y(t, ε, nsim) = sum(Y(t, ε) for _ in 1:nsim) / nsim
    println("error = $(y(1,0.01,10^7)-ℯ)")
end

let # RR euler example
    Y(t) = B(t) ? 1 + Y(U() * t) : 1
    y(t, nsim) = sum(Y(t) for _ in 1:nsim) / nsim
    println("error = $(y(1,10^7)-ℯ)")
end


let # splitted RR euler example
    function Y(t)
        u = U()
        1 + (B(t) ? (Y(u * t) + Y(u * t)) / 2 : 0)
    end
    y(t, nsim) = sum(Y(t) for _ in 1:nsim) / nsim
    println("error = $(y(1,10^3)-ℯ)")
end


let # CV euler example
    function Y(t)
        u = U()
        1 + t + t^2 / 2 + (B(t) ? Y(u * t) - 1 - u * t : 0)
    end
    y(t, nsim) = sum(Y(t) for _ in 1:nsim) / nsim
    println("error = $(y(1,10^3)-ℯ)")
end



let # MC trap example
    f(x) = exp(x)
    trapezium(n) = sum((f(j / n) + f((j + 1) / n)) / 2 for j in 0:n-1) / n

    function MCtrapezium(n, l=100)
        sol = 0
        for j in 0:n-1
            if B(1 / l)
                x, xx = j / n, (j + 1) / n
                S = x + U() * (xx - x) # \sim Uniform(x, xx)
                sol += l * (f(S) - f(x) - (S - x) * (f(xx) - f(x)) * n) / n
            end
        end
        return sol + trapezium(n)
    end

    exact(a, b) = exp(b) - exp(a)
    error(s) = (s - exact(0, 1)) / exact(0, 1)

    println("error: ", error(trapezium(10^5)))
    println("MCerror: ", error(MCtrapezium(10^5, 100)))
end


let #nonlinear example
    function Y(t)
        if t > 2
            error("doesn’t support t > 2")
        end
        S = U() * (t - 1) + 1
        # Y(u)^2 != Y(u) * Y(u) !!!
        return U() < t - 1 ? -1 + Y(S) * Y(S) : -1
    end
    y(t, nsim) = sum(Y(t) for _ in 1:nsim) / nsim
    println("error = $(y(2, 10^3) + 0.5)")
end


let # coupled recursion example 
    q = [1, 0]
    A(a) = [a 0; 1 a]
    X(t, a) = q + (B(t) ? A(a) * X(U() * t, a) : zero(q))
    sol(t, a, nsim) = sum(X(t, a) for _ in 1:nsim) / nsim
    println("error = $(sol(1, 1, 10^5) - [ℯ, ℯ])")
end


let # coupled recursion with tail recursion example
    using LinearAlgebra
    q = [1, 0]
    A(a) = [a 0; 1 a]
    function X(t, a)
        sol = [1.0, 0.0]
        W = I
        while B(t)
            W = W * A(a)
            sol += W * q
            t *= U()
        end
        return sol
    end
    sol(t, a, nsim) = sum(X(t, a) for _ in 1:nsim) / nsim
    println("error = $(sol(1, 1, 10^5) - [ℯ, ℯ])")
end


let # stack implementation example should be using datastructers
    using LinearAlgebra
    function sample_path(t)
        res = [float(t)]
        while U() < t
            t *= U()
            push!(res, t)
        end
        return res
    end

    function X(t, a)
        q = [1.0, 0.0]
        A = [a 0.0; 1.0 a]
        sol = zero(q)
        path = sample_path(t)
        while !isempty(path)
            t = path[end]
            sol = q + (t < 1 ? A * sol : t * A * sol)
            pop!(path)
        end
        return sol
    end

    sol(t, a, nsim) = sum(X(t, a) for _ in 1:nsim) / nsim
    println("error = $(sol(1, 1, 10^5) - [ℯ, ℯ])")
end