Here are my responses to the content questions:

# Content tests

## 0.1. How does the main algorithm work of the thesis?

The main algorithm is a recursive Monte Carlo (RMC) method for solving initial value problems of linear ODEs. It works by recursively estimating the solution at later time points using the integral form of the ODE. The key ideas are:

- Transform the IVP into an integral equation using the fundamental theorem of calculus.
- Estimate the integral term recursively using Monte Carlo.
- Use "recursion in recursion" - recursively estimate the solution on a coarse time grid (outer recursion) and recursively estimate the integral on a finer grid (inner recursion).
- Employ variance reduction techniques like control variates.

## 0.2. What is the biggest limitation of the main algorithm of the thesis?

The main limitation is that it performs poorly on stiff problems. The algorithm relies on recursively multiplying or integrating along solutions, which can lead to instability and exploding variance for stiff problems. More implicit, exponential integrator-type methods would likely work better.

## 0.3. How important is coupled splitting to the thesis?

Coupled splitting is presented as one approach to handling the additive branching recursion caused by splitting in RMC. It seems moderately important - it's used in an example to eliminate this branching, but not central to the main algorithm.

## 0.4. How does Stein's paradox pop up in the thesis? (see subsection on MC integration)

The thesis mentions Stein's paradox in the context of comparing estimators based on RMSE. Even though one estimator may have lower variance, it could still have higher RMSE due to bias. So RMSE comparisons can sometimes be counterintuitive.

## 0.5. Rate the language of the thesis.

I would rate the language of the thesis as good overall. The writing is clear and concepts are explained coherently. There is some usage of jargon/acronyms without definition on first use. The variable naming conventions are inconsistent in places. But in general the language facilitates communication of the key ideas.

## 0.6. List the 5 unclearest parts of the thesis.

- The distinction between inner and outer recursion in recursion in recursion (Example 9.2)
- How control variates are constructed for RRMC (Example 9.3)
- The time process used in simulations and how it relates to recursion calls
- How coupled splitting helps with additive branching recursion
- The informal derivation of the point estimator for the heat equation

## 0.7. What is special about the Monte Carlo trapezoidal rule?

The Monte Carlo trapezoidal rule uses control variates based on the trapezoidal rule to reduce the variance of regular Monte Carlo integration. This improves the convergence rate from O(1/√n) to O(1/n^2.5) while only adding a small number of additional function evaluations.

## 0.8. What is the main advantage of the primary motivating work?

The primary motivating work (Sawhney et al 2022) introduces the Walk-on-Spheres method for solving PDEs. Its main advantage is achieving high accuracy even with complex geometries by avoiding grid constraints.

## 0.9. How does the thesis define Russian Roulette?

Russian Roulette is defined as replacing a random variable X with a cheaper approximation randomly some of the time, in a way that preserves the expected value. A Bernoulli variable is used to determine whether to keep X or use the approximation.

## 0.10. How does the thesis define control variates?

Control variates are defined as modifying the estimation of a function f(X) by subtracting an approximation f̃(X), adding the expected value of the approximation E[f̃(X)], and using the difference f(X) - f̃(X) which has lower variance.

## 0.11. Summarize the approach for exponential of the expectance in the unbiased non-linearity section.

The approach is:

1. Write out the Taylor series expansion of exp(E[X])
2. Replace the coefficients 1/n! with Bernoulli variables to randomly truncate the series
3. Replace each instance of X with an independent copy X_i to remove correlations

## 0.12. How does the thesis define tail recursion?

Tail recursion refers to reordering operations in a recursive algorithm so there are no operations after the recursive call. This allows the final result to be returned once reaching the base case without retracing all the recursion.

## 0.13. How does the thesis define Green's functions?

Green's functions are defined as kernel functions, analogous to homogeneous and particular solutions, that can be integrated against to solve linear PDEs with linear boundary conditions. They satisfy the PDE and boundary conditions separately.

## 0.14. Summarize convergence behavior of the main algorithm.

The convergence of the RRMC algorithm appears similar to explicit time stepping schemes, achieving local RMSE of O(h^2) where h is the step size. Control variates can improve this to higher order. But the method struggles with stiff problems.

## 0.15. List your 5 favorite/interesting parts of the thesis.

- The interactive literature map
- The illustrations of recursion call trees
- The unbiased handling of exponentials and polynomials
- The informal derivation of a point estimator for the heat equation
- The connections made to optimization and stochastic gradient descent

## 0.16. What seem to be missing in the thesis?

- More mathematical rigor in the analysis
- A clear statement of the original contributions
- Examples demonstrating computational speed/scaling
- Discussion of practical applications and implications
- Comparison to state-of-the-art methods on benchmark problems

## 0.17. Any abbreviation that shouldn't be used?

The abbreviations IVP, ODE, MC, and RMSE are common and understandable. But some abbreviations could be defined more clearly on first use, like RRMC, RRVE, RMC, CV, BLUE.

## 0.18. List 5 inaccuracies things in the thesis.

(No major inaccuracies identified from my reading)

## 0.19. List 5 controversial things in the thesis.

(Nothing stood out to me as particularly controversial)

## 0.20. List 5 suggestions to improve the thesis.

- Add a clear statement of original contributions
- Provide more mathematical analysis of convergence etc
- Show computational scaling on benchmark problems
- Discuss potential real-world applications
- Reduce abbreviation usage by spelling out more on first use

# Feedback 1

## 1.1 Does the thesis differentiate between the original contributions and prior work?

Not explicitly. There is a paragraph summarizing the key contribution as an unbiased MC method for linear IVPs. But the original aspects are not clearly differentiated from prior work throughout.

## 1.2 Does the thesis has a good overview?

Yes, the overall structure and organization are good. The introduction summarizes the key topics and techniques covered. And the background sections provide sufficient context before presenting the main algorithm.

## 1.3 Does the thesis has a good conclusion?

The conclusion is quite brief and mainly lists limitations and future work. A summary of key contributions and findings would improve it.

## 1.4 Does everything gets defined in the thesis?

Mostly, though some jargon/acronyms are used without definition on first appearance. But overall new concepts are defined reasonably well before being employed.

## 1.5 Are there symbols that don't get defined in the thesis?

I did not notice any undefined symbols, variables are defined as they are introduced.

## 1.6 What are the advantages of the solvers in the subsection of initial value problems compared to classical solver?

The key advantages compared to classical time-stepping methods are:

- Avoiding strict time discretization, enabling continuous-time sampling
- Naturally parallelizable due to Monte Carlo approach
- Provably unbiased estimates of the solution
- Convergence relies on variance reduction rather than step size

## 1.7 Are the explanations for the graphs in the thesis sufficient?

Yes, the captions describe clearly what is being plotted and the key things to notice in the graphs.

## 1.8 Do equations, examples, definition, etc get referenced with consistent notation?

Generally yes, numbered equations, examples, etc. are referred back to using consistent notation. Exceptions are abbreviations like RRMC, RRVE which aren't defined on first use.

## 1.9 List 2 uncommon abbreviations that don't get introduced the first time they get used.

- RRMC (Recursive Monte Carlo)
- CV (Control Variates)

# Feedback 2

## 2.1 Has the elementary theory of Monte Carlo been covered in the thesis?

Yes, the background section on Monte Carlo integration covers key concepts like unbiased estimators, variance, RMSE, and efficiency. Sufficient for the needs of the thesis.

## 2.2 In the subsection of recursive Monte Carlo why is there indefinite recursion?

Indefinite recursion occurs because the recursive integral equation involves the solution y(t) itself, so estimating it recursively by plugging in the estimator Y(t) leads to infinite recursion.

## 2.3 Does the thesis give the necessary references to concepts?

Generally yes, ideas and techniques are attributed to references reasonably well throughout.

## 2.4 Does additive branching gets explained clearly?

Not very clearly - the concept is mentioned briefly but not defined. More explanation of how splitting causes branching recursion and why it needs to be addressed would help.

## 2.5 What is the Russian roulette rate ?

The Russian roulette rate seems to refer to the probability p of keeping the original random variable vs using the approximation when applying Russian roulette. For example, a rate of 0.01 would mean approximating 99% of the time.

## 2.6 Does the local truncation error get defined ?

No, local and global truncation error are not defined in the thesis.

# Requirements

## 3.1 Title Page:

Yes, there is a title page.

## 3.2 Table of Contents:

Yes, there is a table of contents.

## 3.3 Introduction:

- Provides context on MC methods for PDEs and ODEs
- Clearly states goal of applying concepts from WoS paper to ODEs

## 3.4 Exposition:

- Generally logical flow building from background to main algorithm
- Sections and subsections used effectively

## 3.5 Dutch Summary:

Yes there is a 1 page Dutch summary.

## 3.6 Bibliography:

- Bibliography section is present
- Sources match citations and are in consistent format

## 3.7 Layout and Readability:

- Layout uses appropriate formatting for readability
- Headings and structures aid readability

## 3.8 Language Quality:

- Writing is clear and understandable overall
- Some minor grammar/punctuation issues

## 3.9 Results and Analysis:

- Results could be more clearly summarized
- Analysis sufficiently explains the results

## 3.10 Argumentation and Coherence:

- Arguments generally logical and cohesive
- Transitions are okay but could be smoother

## 3.11 Original Contribution:

- Original contribution not explicitly stated
- But implicit from the algorithm presentation

## 3.12 Discussion and Implications:

- Very minimal discussion of broader implications
- No practical applications mentioned

## 3.13 Clarity and Conciseness:

- Writing is reasonably clear and concise
- Some jargon usage without explanation

## 3.14 Overall Contribution:

- Adds an unbiased MC approach for ODEs
- But significance to the field not emphasized

In summary, the thesis meets the basic requirements and criteria reasonably well. The exposition, language, and presentation are decent. The main limitations are the lack of stated original contributions, minimal discussion of implications, and limited mathematical analysis. But overall it introduces a novel algorithm that contributes value to the field.
