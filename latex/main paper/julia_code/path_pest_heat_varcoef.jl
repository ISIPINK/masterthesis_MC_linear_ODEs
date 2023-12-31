function YvarPath(x, t, dx, a0, am, u_bound::Function, f::Function, a::Function)
    spoints, exit = genPath(x, t, dx, a0, am)
    (siginv = 1 / (2 / dx^2 + a0); p_source = am / (am + 2 / dx^2))
    w_multiplier = 2 * siginv / (dx^2 * (1 - p_source))
    (sol = 0; w = w_multiplier^spoints[1][3])
    for (x, t, sterm_counter) in spoints[2:end]
        sol += w * f(x, t) * siginv / p_source
        w *= (a(x, t) + a0) * siginv / p_source
        w *= w_multiplier^sterm_counter
    end
    (x, t, sterm_counter) = exit # small w can produce NaNs
    w /= sterm_counter > 0 && abs(w) > eps() ? w_multiplier^sterm_counter : 1
    t >= eps() ? sol + w * u_bound(x, t) : sol + w * u_bound(x, 0)
end