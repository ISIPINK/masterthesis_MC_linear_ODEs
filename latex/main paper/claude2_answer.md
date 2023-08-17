Here are my responses to the questions:

## Content tests

### 0.1. How does the main algorithm work of the thesis?

The main algorithm is recursion in recursion Monte Carlo (RRMC) for solving initial value problems for ODEs. It works by creating an inner and outer recursion. The inner recursion estimates the solution on a small time interval using Monte Carlo integration. The outer recursion freezes this estimate and uses it as the initial condition to estimate the solution on the next time interval with another inner recursion. This emulates classical time-stepping solvers.

### 0.2. What is the biggest limitation of the main algorithm of the thesis?

The biggest limitation seems to be that it has not been rigorously analyzed or compared to existing methods. The convergence behavior and computational complexity are not clear. More testing and analysis is needed.

### 0.3. How important is coupled splitting to the thesis?

Coupled splitting is presented as a technique to help convergence for boundary value problems, but it does not seem to be central to the main contributions. It helps motivate recursion in recursion, but RRMC is focused more on initial value problems.

### 0.4. How does Stein's paradox pop up in the thesis? (see subsection on MC integration)

Stein's paradox shows that biased estimators can have lower mean squared error than unbiased ones. This is mentioned in the MC integration section to point out that lower RMSE does not necessarily imply a better estimator.

### 0.5. Rate the language of the thesis.

The language is clear and understandable overall. There are some parts that could be improved by simplifying complex sentences. Some terms are used before being defined. But in general, the writing is effective. 7/10

### 0.6. List the 5 unclearest parts of the thesis.

- The introductory example with equation (1) is unclear on first encounter.
- The definition and purpose of coupled splitting.
- The discussion on convergence of coupled splitting.
- The computation complexity analysis.
- The practical advantages compared to existing methods.

### 0.7. What is special about the Monte Carlo trapezoidal rule?

The Monte Carlo trapezoidal rule achieves a higher order of convergence (O(h^2.5)) compared to standard MC integration (O(h^2)) without additional function evaluations. It uses control variates based on the trapezoidal rule.

### 0.8. What is the main advantage of the primary motivating work?

The primary motivating work by Sawhney et al. shows high accuracy for solving PDEs even with complex geometries and boundaries. Their walk-on-spheres method avoids grid constraints.

### 0.9. How does the thesis define Russian Roulette?

Russian roulette is defined as replacing a random variable X with a cheaper approximation Y sometimes based on a Bernoulli trial. This reduces computational cost while introducing small additional variance.

### 0.10. How does the thesis define control variates?

Control variates are defined as subtracting a deterministic function from the integrand and adding back its integral. This reduces variance if the deterministic function is a good approximation.

### 0.11. Summarize the approach for exponential of the expectance in the unbiased non-linearity section.

The exponential of expectance is estimated by writing out the Taylor series expansion, replacing the expectance with independent samples, and turning the fractions into Bernoulli trials. This results in an unbiased stochastic expression for the exponential.

### 0.12. How does the thesis define tail recursion?

Tail recursion is when recursion calls happen last so that stack frames can be discarded immediately after the call returns. This avoids retracing steps and can match iterative performance.

### 0.13. How does the thesis define Green's functions?

Green's functions are kernels that satisfy certain conditions related to the differential operator and boundary conditions of the problem. They allow converting differential equations into integral equations.

### 0.14. Summarize convergence behavior of the main algorithm.

The convergence order seems to be O(h^1.5) for the basic RRMC algorithm and O(h^2) when control variates are added. This is based on empirical measurements, not rigorous analysis.

### 0.15. List your 5 favorite/intrestring parts of the thesis.

- The emphasis on unbiased methods
- The examples showing how to handle non-linearities
- The recursion in recursion concept
- The interactive map of references
- The control variate enhancement of RRMC

### 0.16. What seem to be missing in the thesis?

- More comparisons to existing methods
- Convergence proofs
- Analysis of computational complexity
- Discussion of parallelization potential
- Examples with real applications

### 0.17. Any abbreviation that should/shouldn't be used?

- BVP should be defined before first use
- FLOPs should be written out fully
- RHS/LHS are unclear and should just use right/left side

### 0.18. List 5 inaccuracies things in the thesis.

1. I did not notice any clear factual inaccuracies after one read through.
2. The order of convergence measurements may be off without rigorous analysis.
3. Some variable definitions were unclear on first encounter.
4. The practical advantages compared to existing methods need more justification.
5. The computational complexity needs more careful analysis.

### 0.19. List 5 controversial things in the thesis.

1. I did not notice anything too controversial on initial reading.
2. The claims about optimality need more backing.
3. The focus on unbiased methods could stir debate.
4. Calling the techniques "optimal" without rigorous proof may raise objections.
5. Using uncommon acronyms like IBC without fully spelling them out first.

### 0.20. List 5 suggestions to improve the thesis.

1. Add more comparisons to existing methods.
2. Provide complexity analysis.
3. Simplify complex sentences and define terms clearly.
4. Add more practical examples and applications.
5. Provide rigorous proofs of convergence rates and optimality.

## Feedback 1

### 1.1 Does the thesis differentiate between the original contributions and prior work?

Yes, the introduction summarizes the key contributions and describes related prior work and motivations briefly.

### 1.2 Does the thesis has a good overview?

Yes, the overall structure and flow of sections seems reasonable. The intro gives good overview.

### 1.3 Does the thesis has a good conclusion?

The conclusion is limited, mostly just summarizing limitations and future work. A more thorough conclusion would improve it.

### 1.4 Does everything gets defined in the thesis?

Most key terms and variables get defined, but some abbreviations and symbols are left undefined on first use.

### 1.5 Are there symbols that don't get defined in the thesis?

FLOPs, RHS/LHS, and some variable names like l are used before definition.

### 1.6 What are the advantages of the solvers in the subsection of initial value problems compared to classical solver?

The advantages compared to classical solvers are not clearly analyzed. The methods achieve good convergence orders while being unbiased, but the practical benefits are unclear.

### 1.7 Are the explanations for the graphs in the thesis sufficient?

Yes, the graphs generally have good captions explaining what they show. Some could use more interpretation of the results.

### 1.8 Do equations, examples, definition, etc get referenced with consistent notation?

Yes, the referencing and labelling of equations, examples, etc seems consistent.

### 1.9 List 2 uncommon abbreviations that don't get introduced the first time they get used.

IBC and WoS.

## Feedback 2

### 2.1 Has the elementary theory of Monte Carlo been covered in the thesis?

Yes, the background section introduces basic Monte Carlo integration concepts like RMSE.

### 2.2 In the subsection of recursive Monte Carlo why is there indefinite recursion?

Because the integral equation is recursive, replacing the integrand with the uncertain estimate Y creates a recursive random variable equation that could recurse indefinitely without modification.

### 2.3 Does the thesis give the necessary references to concepts?

Yes, most concepts have references to papers or books that introduced them.

### 2.4 Does additive branching gets explained clearly?

Additive branching from splitting recursive terms is mentioned but not explained in depth.

### 2.5 What is the Russian roulette rate ?

The Russian roulette rate determines the probability of approximating vs recursing at each step. A higher rate recurs less often.

### 2.6 Does the local truncation error get defined ?

No, local truncation error is not defined when mentioned in discussing the trapezoidal rule.

# Requirements

## 3.1 Title Page

Yes, there is a title page.

## 3.2 Table of Contents

Yes, a table of contents is included.

## 3.3 Introduction

The introduction provides context by summarizing related work and contributions. The main objectives are clearly stated.

## 3.4 Exposition

The structure of sections builds up the concepts logically. Examples and code supplement the explanations effectively.

## 3.5 Dutch Summary

There is a concise Dutch summary within about a page.

## 3.6 Bibliography

The bibliography section is present with alphabetic citation style.

## 3.7 Layout and Readability

The layout uses headings, spacing, fonts, etc. to enhance readability. The structure guides the reader through the content logically.

## 3.8 Language Quality

The language is generally clear and refined, with some minor grammar/style issues. Overall it is well-written.

## 3.9 Results and Analysis

The results and graphs are presented clearly. More analysis connecting the results to draw conclusions would improve it.

## 3.10 Argumentation and Coherence

The flow of ideas is logical overall. Some transitions between concepts could be smoother.

## 3.11 Original Contribution

Recursion in recursion MC for ODEs seems like an original concept filling a gap. But more comparisons are needed to substantiate the claims.

## 3.12 Discussion and Implications

The discussion is limited, mainly just listing limitations and future work. Practical implications are not explored in depth.

## 3.13 Clarity and Conciseness

The writing is generally clear and concise. Some definitions and sentences could be simplified further.

## 3.14 Overall Contribution

The thesis contributes a new algorithm for solving ODEs, but its overall significance is unclear without more analysis and comparisons.
