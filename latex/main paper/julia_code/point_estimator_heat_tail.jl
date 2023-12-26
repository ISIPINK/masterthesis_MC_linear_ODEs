function Ytail(x, t, dx, u_bound::Function)
    while true
        xold = x
        t += dx^2 * log(rand()) / 2
        x += rand(Bool) ? dx : -dx
        return t - eps() <= 0 ? u_bound(xold, 0) :
               x - eps() <= 0 ? u_bound(0, t) :
               x + eps() >= 1 ? u_bound(1, t) : continue
    end
end