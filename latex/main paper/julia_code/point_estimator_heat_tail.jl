function Ytail(x, t, dx)
    while true
        xold = x
        t += dx^2 * log(rand()) / 2
        x += rand(Bool) ? dx : -dx
        return t <= 0 ? u(xold, 0) :
               x <= 0 ? u(0, t) :
               x >= 1 ? u(1, t) : continue
    end
end