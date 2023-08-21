Here are my answers to the content questions:

# Content tests

## 0.1. How does the main algorithm work of the thesis?

The main algorithm is a recursive Monte Carlo (RMC) method for solving initial value problems for systems of ODEs. It uses recursion in recursion along with control variates to achieve higher order convergence compared to standard RMC methods. The outer recursion propagates the solution along a sequence of time steps, while the inner recursion estimates the integral term over each time step. Control variates based on Taylor expansions are used in the inner recursion to reduce variance.

## 0.2. What is the biggest limitation of the main algorithm of the thesis?

The biggest limitation seems to be that the algorithm has not been rigorously analyzed or benchmarked against classical solvers. So it is unclear if it would offer any practical advantages over existing methods. The use of correlated samples in the inner recursions also introduces some bias that needs to be carefully managed.

## 0.3. How important is coupled splitting to the thesis?

Coupled splitting is presented as a technique to reduce variance for boundary value problems by reusing samples, but it does not seem to be a core contribution of the thesis. It is explored in some examples but not utilized in the main algorithm.

## 0.4. How does Stein's paradox pop up in the thesis? (see subsection on MC integration)

The thesis mentions Stein's paradox in the context of the Monte Carlo trapezoidal rule to note that it is possible to bias estimators to achieve lower RMSE, even though the MC trapezoidal rule is unbiased. This illustrates a case where unbiasedness does not guarantee optimal performance.

## 0.5. Rate the language of the thesis.

The language is generally clear and understandable, though at times complex concepts could be explained more intuitively. There is some overuse of abbreviations/notation that could be simplified. Overall I would rate the language as good but with room for improvement in terms of clarity and concision.

## 0.6. List the 5 unclearest parts of the thesis.

- The introduction of coupled splitting - the motivation and implementation could be clearer
- The convergence analysis of the main algorithm
- The relevance of recursion in recursion as a technique
- The importance of Russian roulette rate tuning
- The practical advantages of the algorithm over classical methods

## 0.7. What is special about the Monte Carlo trapezoidal rule?

The Monte Carlo trapezoidal rule achieves a higher order of convergence (O(1/n^2.5) for RMSE) compared to standard Monte Carlo integration (O(1/n)) by using control variates based on the trapezoidal rule. This results in an improved tradeoff between computational cost and accuracy.

## 0.8. What is the main advantage of the primary motivating work?

The primary motivating work by Sawhney et al. introduced the Walk-on-Spheres method for solving PDEs, which achieves high accuracy even with complex geometries. A key advantage is the handling of boundary conditions in a simple, grid-free manner.

## 0.9. How does the thesis define Russian Roulette?

Russian roulette is defined as a way to probabilistically replace a random variable X with a cheaper approximation Y sometimes, in a way that preserves the expected value. This reduces computational cost while increasing variance.

## 0.10. How does the thesis define control variates?

Control variates are defined as replacing a random variable X with X - E[X] + E[tilde(X)], where tilde(X) is some approximation of X. This reduces the variance while preserving the expected value.

## 0.11. Summarize the approach for exponential of the expectance in the unbiased non-linearity section.

The Taylor series of the exponential is manipulated by replacing constants with Bernoulli random variables and Expectations of X with independent samples X_i. This results in an unbiased estimator of the exponential that can be simulated using samples of X.

## 0.12. How does the thesis define tail recursion?

Tail recursion is defined as reordering operations in a recursive algorithm so that the recursive call happens last. This allows the result to be returned directly when reaching the base case without retracing the recursion stack.

## 0.13. How does the thesis define Green's functions?

Green's functions are defined as kernels that can be integrated against boundary conditions or source terms to solve linear PDEs, while satisfying the homogenous PDE and boundary conditions themselves.

## 0.14. Summarize convergence behavior of the main algorithm.

The convergence of the main algorithm is not rigorously analyzed. Empirically, a convergence rate of O(h^1.5/sqrt(nsim)) is measured for a simple test problem. The use of correlated samples likely introduces some bias that must be carefully managed.

## 0.15. List your 5 favorite/intrestring parts of the thesis.

- The Monte Carlo trapezoidal rule and its improved convergence
- Recursion in recursion as a technique to emulate classic solvers
- The relation between heat equation and Brownian motion
- Coupled recursion for sensitivity analysis
- The unbiased techniques for handling non-linearity

## 0.16. What seem to be missing in the thesis?

Some things that seem to be missing or needing more detail:

- Convergence analysis of the main algorithm
- Rigorous IBC analysis of the algorithms
- More practical implementation details
- Benchmarks against classical methods
- Real-world applications of the techniques

## 0.17. Any abbreviation that should/shouldn't be used?

- RRVE is used a lot and could be written out more
- RMC is fine as a common abbreviation
- IBC is an uncommon abbreviation that could be expanded

## 0.18. List 5 inaccuracies things in the thesis.

I did not notice any major technical inaccuracies on my read through. A few minor issues:

- In the coupled recursion example, the notation for partial derivative is missing delta
- The optimal IBC for trapezoidal rule is not rigorously proven
- Convergence proof for MC trapezoidal rule could be more formal
- Definition of IBC is informal
- Unclear if Russian roulette preserves variance

## 0.19. List 5 controversial things in the thesis.

- Claiming optimal IBC for the main algorithm without rigorous proof
- Using RMSE convergence to claim advantages of an algorithm
- Handling non-linearity by splitting into i.i.d. samples
- Claiming coupling splitting achieves faster convergence generically
- Lack of comparison against state-of-the-art classical methods

## 0.20. List 5 suggestions to improve the thesis.

- Provide more practical implementation details
- Include benchmarks against classical methods
- Expand on real-world applications of the techniques
- Simplify notation and avoid unclear abbreviations
- Provide more mathematical rigor around claims of optimality

# Feedback 1

## 1.1 Does the thesis differentiate between the original contributions and prior work?

Yes, the introduction summarizes the key related work that motivated the research and highlights the original contributions of the thesis afterwards. The background sections also reference relevant prior work.

## 1.2 Does the thesis has a good overview?

The overall structure and organization are good, with background sections building up the key concepts before presenting the novel techniques. The introduction provides a high-level overview and roadmap.

## 1.3 Does the thesis has a good conclusion?

The conclusion is brief and mainly highlights limitations and future work. A more substantive conclusion summarizing the key contributions and significance would strengthen it.

## 1.4 Does everything gets defined in the thesis?

Most key terms and concepts are defined, either formally or informally. But there are some instances of terms being used before being introduced.

## 1.5 Are there symbols that don't get defined in the thesis?

I did not notice any symbols used without definition. Symbols and notation are generally introduced properly.

## 1.6 What are the advantages of the solvers in the subsection of initial value problems compared to classical solver?

The advantages compared to classical solvers are not conclusively demonstrated, but the potential benefits suggested are:

- Ability to easily parallelize across samples
- More graceful handling of randomness/uncertainty in parameters
- Avoiding stringent stability constraints on step size

## 1.7 Are the explanations for the graphs in the thesis sufficient?

The graphs are usually explained adequately, but more context around the parameters and setup could be provided in some cases. Axes labels and units are occasionally missing.

## 1.8 Do equations, examples, definition, etc get referenced with consistent notation?

The notation and referencing are generally consistent, with some minor exceptions. Examples are denoted consistently and referenced when reused later.

## 1.9 List 2 uncommon abbreviations that don't get introduced the first time they get used.

- IBC
- RRVE

# Feedback 2

## 2.1 Has the elementary theory of Monte Carlo been covered in the thesis?

Yes, the background section provides a good high-level introduction to Monte Carlo integration and key concepts like variance reduction. Important terminology is defined.

## 2.2 In the subsection of recursive Monte Carlo why is there indefinite recursion?

The recursive equations do not have a base case or termination condition, so they would recurse indefinitely. This illustrates the need for modification strategies like Russian roulette.

## 2.3 Does the thesis give the necessary references to concepts?

Most key concepts are attributed to references, but there are some instances where prior art could be cited more precisely.

## 2.4 Does additive branching gets explained clearly?

Additive branching recursion is mentioned briefly but not explained in detail. More context around why it causes issues and how coupled recursion addresses it could help.

## 2.5 What is the Russian roulette rate ?

The Russian roulette rate determines the probability of approximating vs recursing at each step. It controls the balance between variance and computational cost.

## 2.6 Does the local truncation error get defined ?

The local truncation error is not explicitly defined, though the concept is demonstrated in analyzing the MC trapezoidal rule. Defining it formally could clarify the analysis.

# Requirements

## 3.1 Title Page:

Yes, there is a title page.

## 3.2 Table of Contents:

Yes, a table of contents is included.

## 3.3 Introduction:

The introduction provides context and motivation from prior work, as well as clearly stating the contributions. The problem being addressed is defined.

## 3.4 Exposition:

Overall the exposition and structure are good. Ideas build up incrementally and techniques are demonstrated on examples. Sections are reasonably well organized.

## 3.5 Dutch Summary:

There is a 1 page Dutch summary.

## 3.6 Bibliography:

The bibliography is present and structured appropriately in BibTeX format. References appear to be accurately cited.

## 3.7 Layout and Readability:

The layout generally enhances readability. Font, spacing, etc. are appropriate. Headings help guide the reader. Figures and examples supplement the text nicely.

## 3.8 Language Quality:

The language is generally clear and grammatically correct. Sentences are usually concise. Some definitions and explanations could be simplified.

## 3.9 Results and Analysis:

Results are presented via figures and empirical convergence measurements. More rigorous analysis of the results would strengthen this area.

## 3.10 Argumentation and Coherence:

The flow of ideas is logical overall. Sections build on each other effectively. Some transitions between concepts could be smoother.

## 3.11 Original Contribution:

The original contributions are clearly stated. The proposed techniques aim to advance the state of the art, though broader significance is not extensively discussed.

## 3.12 Discussion and Implications:

The discussion of limitations points out opportunities for future work. Some comments on potential applications or implications would further enhance this section.

## 3.13 Clarity and Conciseness:

The writing aims for clarity and concision, though dense mathematical passages occasionally affect readability. Some simplification of terminology and notation could help.

## 3.14 Overall Contribution:

The techniques presented appear to be novel contributions, but the ultimate significance is hard to judge given the lack of rigorous analysis and comparisons to other state-of-the-art methods. The overall contribution is promising but not conclusively demonstrated.
