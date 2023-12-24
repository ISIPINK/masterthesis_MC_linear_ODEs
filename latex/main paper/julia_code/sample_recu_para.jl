function triangle_scale_in_para(time, pos)
    xx = sqrt(1 - time) - abs(pos)
    tt = abs(1 - abs(pos)^2 - time)
    return sqrt(tt) < xx ? sqrt(tt) : xx
end
function sample_recursive_para(accuracy=0.01, scale_mul=0.9)
    (time = 0.0; pos = 0.0)
    scale = triangle_scale_in_para(time, pos)
    while scale > accuracy
        scale *= scale_mul
        dtime, dpos = triangle_sample[rand(1:length(triangle_sample))]
        dtime, dpos = scale^2 * dtime, scale * dpos
        (time += dtime; pos += dpos)
        scale = triangle_scale_in_para(time, pos)
    end
    return (time, pos)
end
