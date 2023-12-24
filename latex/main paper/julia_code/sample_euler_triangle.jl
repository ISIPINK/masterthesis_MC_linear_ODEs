in_triangle(time, pos) = (1 - time > abs(pos))
function sample_euler_triangle(dt=0.001)
    (pos = 0; time = 0)
    while in_triangle(time, pos)
        pos += sqrt(dt) * randn()
        time += dt
    end
    return (time, pos)
end