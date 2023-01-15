I still need to test/proof most of these ideas.

RMC = recursive monte carlo
## favorites
- green inversion of linear differential operators + extending with recursion 
- control variate for recursive terms
- orthonormal adaptive control variates
- RMC + russian roulette  for y = y' 
- full Brownian motion (approx) + path compression (think before and after transfo)
- DIY stochastic trust region 
- unbiased MC and analytic non linearity


## RMC
- RMC for heat equation with (smooth u(0,x) condition)
- RMC for systems of linear equations 
- RMC for linear integral equations (volterra, fredholm theory)

## unsorted
- getting a linear functional of the solution (e.g greeks)
- multilevel = boosting?
- impossible speedup (probably isn't possible)
- smart start (= stepping on symmetric subproblem)
- fake boundary trick (fusing methods)

## financial
- American options
- special path dependence -> PDE (only linear types pls)
- bridging (with constraints) (difficult)


## obsolete
- solving over a line (difference P) 
- point coordination (approx)
- scale coordination (exact) 
- shorting quadrature (doesnt allow recursion, see fast and simple method for pricing exotic options using gauss hermite quadrature)
- basis for boundary conditions (dirichlet + last step other) + green function = RMC solver linear PDEs
- RMC for ODE IVPs
- RMC for y = y'' (with different boundary conditions)
- RMC for linear difference equations
- RMC for linear integro-differential equations
- function control variate + fitting
- independence trick (symmetry in green)
- Ways to control the distribution of step sizes? (see Off-centered WOS)
- Ways to control path lenght (use E-trick)
- fully solved green + quadrature over boundary + stop control (look Walk on Rectangles)

### propagators =~ dirchlet basis for diffusion equations (less important)
- composition property + function optimization = propagator (uniqueness?, Fredholm integral equations)
- propagators for path information (e.g. average)
- reject + method of images = more propagators
- propagation in jumped space
- propagation in moving space (Girsanov also does the job I think)
- balancing problem  (not an idea)
- time dependent boundaries (see walk on moving spheres and linear time dependent boundaries)