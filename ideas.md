I still need to test/proof most of these ideas.

RMC = recursive monte carlo
## favorites
- E-trick
- RMC for y = y' 
- full Brownian motion (approx)
- basis for boundary conditions (dirichlet + last step other) + green function = RMC solver linear PDEs

## RMC
- RMC for ODE IVPs
- RMC for y = y'' (with different boundary conditions)
- RMC for heat equation with (smooth u(0,x) condition)
- RMC for linear difference equations
- RMC for systems of linear equations 
- RMC for linear integral equations (volterra, fredholm theory)
- RMC for linear integro-differential equations

## unsorted
- getting linear functionals of the solution (e.g greeks)
- function control variate + fitting
- independence trick (symmetry in green)
- Ways to control the distribution of step sizes? (see Off-centered WOS)
- Ways to control path lenght (use E-trick)
- multilevel = boosting?
- impossible speedup (probably isn't possible)
- smart start (= stepping on symmetric subproblem)
- fake boundary trick (fusing methods)
- fully solved green + quadrature over boundary + stop control (look Walk on Rectangles)

## financial
- American options
- special path dependence -> PDE (only linear types pls)
- compressing paths (think before and after transfo)
- bridging (with constraints) (difficult)

## propagators =~ dirchlet basis for diffusion equations (less important)
- composition property + function optimization = propagator (uniqueness?, Fredholm integral equations)
- propagators for path information (e.g. average)
- reject + method of images = more propagators
- propagation in jumped space
- propagation in moving space (Girsanov also does the job I think)
- balancing problem  (not an idea)
- time dependent boundaries (see walk on moving spheres and linear time dependent boundaries)

## obsolete
- solving over a line (difference P) 
- point coordination (approx)
- scale coordination (exact) 
- shorting quadrature (doesnt allow recursion, see fast and simple method for pricing exotic options using gauss hermite quadrature)

