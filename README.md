# prototype-Monte-Carlo
In this repo we test recursive Brownian simulation (need a better name for this).

## What is  recursive Brownian simulation?
Recursive Brownian simulation simulates Brownian paths with a certain
stopping criteria. This generalizes Walk on Spheres that has as stopping criteria
a time independent space boundary.

In the next plot you can see how recursive Brownian simulation
simulates exit points with stopping criteria a time-space parabola boundary
and as base a triangular time-space boundary.
![example_recursive_brownian_motion](./plots/example_recursive_brownian.png)

The way recursive Brownian simulation works is by recursively sampling
of a base stopping criteria until the derived stopping criteria
is closely met.

In the last example only exit points were simulated and a triangular base criteria was used (generated
by regular Brownian motion simulations) which of directly follow scaled versions of it 
because of the scaling symmetry of Brownian motion. 
With this triangular base you can approximate simulation of a big class of 
stopping criteria.

## Does recursive Brownian simulation work?

To test that recursive Brownian simulation works.
We tested last example against (regular Brownian motion simulations).


![comparison](./plots/para_comparison.png)




