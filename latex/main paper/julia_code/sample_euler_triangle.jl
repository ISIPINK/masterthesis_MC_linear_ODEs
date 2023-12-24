in_triangle(time, pos) = (1 - time > abs(pos))
function sample_euler_triangle(dt=0.001)
    (time = 0; pos = 0)
    while in_triangle(time, pos)
        time += dt
        pos += sqrt(dt) * randn()
    end
    return (time, pos)
end