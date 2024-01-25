function YvarPath(path, dx, a0, am, u_bound, f, a)
    spoints, exit = path
    (siginv = 1 / (2 / dx^2 + a0); p_source = am / (am + 2 / dx^2))
    logw_multiplier = log(2 * siginv / (dx^2 * (1 - p_source)))
    (sol = 0; logw = spoints[1][3] * logw_multiplier)
    for (x, t, sterm_counter) in spoints[2:end]
        sol += exp(logw) * f(x, t) * siginv / p_source
        logw += log((a(x, t) + a0) * siginv / p_source)
        logw += sterm_counter * logw_multiplier
    end
    (x, t, sterm_counter) = exit
    logw -= sterm_counter * logw_multiplier
    sol + exp(logw) * u_bound(x, t >= eps() ? t : 0)
end