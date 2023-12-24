function Y_in(t, tn, yn, h)
    S = tn + rand() * (t - tn)  # \sim Uniform(T,t)
    return rand() < (t - tn) / h ? yn + h * Y_in(S, tn, yn, h) : yn
end
function Y_out(tn, h) # h is out step size
    TT = tn > h ? tn - h : 0
    return tn > 0 ? Y_in(tn, TT, Y_out(TT, h), h) : 1
end