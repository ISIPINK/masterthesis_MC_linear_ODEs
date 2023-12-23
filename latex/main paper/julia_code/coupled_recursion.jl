(q = [1, 0]; A(a) = [a 0; 1 a])
X(t, a) = (rand() < t) ? q + A(a) * X(rand() * t, a) : q