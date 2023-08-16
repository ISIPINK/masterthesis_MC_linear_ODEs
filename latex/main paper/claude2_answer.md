Here are my answers to the questions about the thesis:

# Content tests

0.1. The main algorithm is Recursion in Recursion Monte Carlo (RRMC) for solving initial value problems for ODEs. It works by recursively estimating solutions at finer timesteps, using the solution from the previous coarser timestep as the initial value. This emulates classical timestepping solvers.

0.2. The biggest limitation is that RRMC struggles with stiff problems that have large negative coefficients, similar to classic methods. It has not been rigorously compared to other methods.

0.3. Coupled splitting is a technique to reduce variance by reusing samples across coupled recursions. It helps avoid exponential branching but is not central to the thesis.

0.4. Stein's paradox shows that an unbiased estimator can have higher RMSE than a biased one. This is relevant since the thesis focuses on unbiased MC methods.

0.5. The language is quite technical but reasonably clear overall. Some parts could be explained more intuitively.

0.6. The 5 unclearest parts:

- The abstract lacks context/motivation.
- The introduction lacks an overview and clear contribution statement.
- The notation section seems unnecessary.
- The related work lacks synthesis.
- The convergence proof sketches could be clearer.

  0.7. The MC trapezoidal rule uses control variates based on the trapezoidal rule to achieve faster convergence than naive MC integration.

  0.8. The main motivating work introduces grid-free MC methods for PDEs that work well with complex geometry.

  0.9. Russian roulette randomly replaces a random variable with a simpler approximate sometimes to reduce computational cost.

  0.10. Control variates reduce variance by subtracting off a deterministic approximation and adding back its expectation.

  0.11. For the exponential of expectance, the thesis represents the Taylor series as recursive conditional expectations, replacing integrals with MC simulation.

  0.12. Tail recursion reverses the order of operations so no computation happens after the recursive call, allowing iteration instead of true recursion.

  0.13. Green's functions represent integrals kernels that when integrated against boundary conditions give solutions to differential equations.

  0.14. The convergence of RRMC is similar to fixed point methods until approximation error dominates, then MC convergence takes over. Coupled splitting may improve convergence.

  0.15. Favorite parts:

- The interactive literature map
- The visual recursive call plots
- The application to random ODEs
- Recursion in recursion
- The connection between Brownian motion and the heat equation

  0.16. Missing things:

- More intuition, overviews, and explicit takeaways
- Convergence proofs and analysis
- Comparisons to other methods
- Discussion of limitations and future work

  0.17. Abbreviations are generally introduced properly. No issues.

  0.18. 5 inaccuracies:

- The definition of relative MC efficiency is incorrect.
- The MC trapezoidal rule error bound proof is incomplete.
- The control variate variance formula is wrong.
- Recursive integral equations were said to always be Fredholm equations.
- The notation section lists ODEs as BVPs incorrectly.

  0.19. 5 controversial things:

- Claiming optimal IBC without proof.
- Focusing on unbiased methods when biased can be better.
- Using recursion instead of explicit timesteps.
- The usefulness of coupled splitting is unclear.
- Applicability to random ODEs needs more justification.

  0.20. 5 suggestions:

- Add more intuitive explanations and overviews.
- Include rigorous analysis of convergence and limitations.
- Compare performance to other methods.
- Clarify the value and role of coupled splitting.
- Extend to other types of PDEs.

# Feedback 1

1.1 The original contributions are clearly differentiated in the contributions section.

1.2 The overview is weak - the introduction lacks clarity on the key ideas and results.

1.3 The conclusion is very minimal - it would benefit from more summary and implications.

1.4 Most things get defined, but some terms like relative efficiency are used inconsistently.

1.5 Some undefined symbols:

- $b_0, b_1$ in the green functions section
- $h$ in the CV RRMC IVP section

  1.6 The IVP solvers have the potential advantage of parallelization by recursing independently on each timestep. However, their performance compared to classics methods is unclear.

  1.7 The graphs are not explained adequately in all cases. Axis labels, units, and context are sometimes missing.

  1.8 Equations and examples are referenced consistently with their labels. Definitions and theorems are not always referenced later.

  1.9 Uncommon abbreviations:

- RRMC not expanded in the nonlinear RRMC section
- RMC not expanded when first used in the Fredholm equations section

# Feedback 2

2.1 The background section covers the basics of MC integration reasonably well.

2.2 Indefinite recursion happens because the estimator directly references itself recursively with no base case or termination condition.

2.3 References are given for most concepts, but could be more comprehensive for things like Stein's paradox and convergence of RRMC.

2.4 Additive branching recursion is when recursive calls result in exponential growth of simulations. It is not explained clearly.

2.5 The Russian roulette rate is the parameter $l$ that controls the probability of using the approximation vs the full simulation.

2.6 Local truncation error is not defined in the thesis. It represents the error from a single step in a numerical method.

# Requirements

3.1 Yes, there is a title page.

3.2 Yes, a table of contents is included.

3.3 The introduction lacks clear context and problem statement. The contribution could be made more explicit.

3.4 The argumentation is reasonably detailed and logical overall. The substructure of sections helps organize the content.

3.5 There is a Dutch summary within the page limit. It covers the main points decently.

3.6 The bibliography section is present and structured properly with alphabetical order.

3.7 The layout uses appropriate formatting elements to guide the reader. Font, spacing, paragraphs are designed for readability.

3.8 The language is technical but well-written overall, with good grammar, spelling, and punctuation.

3.9 Results are presented clearly through figures and tables. Analysis and conclusions could be more extensive.

3.10 Ideas progress logically, but transitions between sections could be smoother.

3.11 The contribution is stated but could be made more explicit. The gap filled is not clearly articulated.

3.12 The discussion of implications is minimal. Applications and future work are suggested briefly but not thoroughly discussed.

3.13 The writing aims for conciseness and clarity. Complex concepts sometimes need more intuitive explanation.

3.14 The overall contribution is solid but incremental. It is specialized so may not be widely cited.

In summary, the thesis meets most formatting requirements and presents original research, but could be strengthened by clarifying the motivation, contribution, limitations, and implications. More intuitive explanations, transitions, and rigorous analysis would also help enhance the quality.
