num_B(i) = rand() * i < 1 ? num_B(i + 1) : i - 1
res(X, n) = (n != 0) ? 1 + X() * res(X, n - 1) : 1
expE(X) = res(X, num_B(0))