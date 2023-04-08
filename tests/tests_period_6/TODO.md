- Numerical tests

Sure, here are the standard test problems in Markdown with LaTeX for equations:

Stiff ODE test problem:

The problem is defined by the equation:

$$
y'=-\lambda y.
$$

where $\lambda$ is a large negative constant. The solution exhibits rapid decay, and the problem is considered stiff when $\lambda$ is very large. The performance of a solver on this problem can be used to evaluate its ability to handle stiffness.

Van der Pol oscillator:

The problem is defined by the equation:

$$
y'' - \mu (1-y^{2})y' + y =0.
$$

where $\mu$ is a parameter that controls the nonlinearity of the problem. This problem is often used to test the accuracy and stability of numerical solvers for nonlinear ODEs.

Lorenz system:

The system is defined by the equations:

$$
\begin{aligned}
\frac{dx}{dt} &= \sigma (y - x) \\
\frac{dy}{dt} &= x (\rho - z) - y \\
\frac{dz}{dt} &= x y - \beta z
\end{aligned}
$$

where $\sigma$, $\rho$, and $\beta$ are parameters that control the behavior of the system. The performance of a solver on this problem can be used to evaluate its ability to handle chaotic dynamics.

Brusselator:

The system is defined by the equations:

$$
\begin{aligned}
\frac{\partial u}{\partial t} &= 1 + u^2 v - (B+1)u + A \nabla^2 u \\
\frac{\partial v}{\partial t} &= Bu - u^2 v + D \nabla^2 v
\end{aligned}
$$

where $A$, $B$, and $D$ are parameters that control the behavior of the system. This problem can be used to test the solver's ability to handle spatiotemporal dynamics.

These test problems are widely used in the numerical ODE community and can be used to compare the performance of different solvers on a common set of problems. However, it is important to note that the choice of test problem depends on the specific application and problem being solved, and that other test problems may be more appropriate for some applications.
