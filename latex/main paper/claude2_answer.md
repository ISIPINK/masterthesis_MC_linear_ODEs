Here are my answers to the questions:

# Content tests

## 0.1. How does the main algorithm work of the thesis?

The main algorithm is recursion in recursion Monte Carlo (RRMC) for solving initial value problems (IVPs) for ODEs. It works by first discretizing the time domain into steps. Then at each time step, an inner Monte Carlo recursion estimates the solution at that step. The estimate from the previous step is used as the initial condition for the current step. This emulates classical time-stepping methods but instead of deterministic steps, it uses stochastic recursion.

## 0.2. What is the biggest limitation of the main algorithm of the thesis?

The biggest limitation seems to be that RRMC can struggle with stiff systems of ODEs that have large negative coefficients, similar to classic methods. The inner recursions do not update the control variate, which leads to many function calls without new information. So in its current form, it is not expected to outperform classical methods.

## 0.3. How important is coupled splitting to the thesis?

Coupled splitting does not seem to be a core contribution of the thesis. It is introduced as a technique to help convergence for boundary value problems modeled with Fredholm integral equations. However, it is not clear if it actually improved convergence significantly. The thesis mentions it was originally motivated for convergence but does not provide evidence that it expanded the convergence domain.

## 0.4. How does Stein's paradox pop up in the thesis? (see subsection on MC integration)

The thesis mentions in a related work note on the Monte Carlo trapezoidal rule that it is possible to bias the estimator to achieve lower RMSE due to Stein's paradox. However, the thesis does not go into details on Stein's paradox itself.

## 0.5. Rate the language of the thesis.

Overall, the language is clear and understandable. There are some parts that could be smoothed out and clarified, but it effectively conveys the key ideas. I would rate the language as good but with room for improvement.

## 0.6. List the 5 unclearest parts of the thesis.

- The introduction of coupled splitting - the explanation and motivation is vague.
- The subsection on Fredholm integral equations - the purpose is unclear and seems disconnected.
- The overall flow and transitions between some sections needs work.
- Some parts use informal notation that should be cleaned up.
- The abstract mentions a "conjecture of optimal IBC" but this is not elaborated on in the thesis.

## 0.7. What is special about the Monte Carlo trapezoidal rule?

The Monte Carlo trapezoidal rule uses control variates based on the trapezoidal rule to reduce the variance. This results in a higher order convergence rate compared to standard Monte Carlo integration. Specifically, it achieves an RMSE convergence rate of O(1/n^{2.5}) compared to O(1/n) for standard Monte Carlo.

## 0.8. What is the main advantage of the primary motivating work?

The primary motivating work by Sawhney et al. introduces the Walk-on-Spheres method for solving elliptic PDEs. It shows high accuracy even with complex geometries and boundary conditions. The main advantage seems to be the ability to handle complex domains.

## 0.9. How does the thesis define Russian Roulette?

Russian roulette is defined as replacing a random variable X with a less computationally expensive approximation randomly. This is done by using a Bernoulli trial to determine whether to evaluate the full X or just the approximation. The expected value is preserved.

## 0.10. How does the thesis define control variates?

Control variates are defined as subtracting an approximation f̃(X) from f(X) and adding back the expectation E[f̃(X)] to reduce the variance of estimating E[f(X)]. If the approximation E[f̃(X)] is estimated by sampling, it is called 2-level Monte Carlo.

## 0.11. Summarize the approach for exponential of the expectance in the unbiased non-linearity section.

The approach is based on the Taylor series expansion of exp(x). It replaces the coefficients with Bernoulli variables and uses independent samples of X in each term to make it unbiased. This results in a telescoping sum that can be sampled recursively.

## 0.12. How does the thesis define tail recursion?

Tail recursion is when recursion calls happen after all other operations in a function. This allows the result to be returned without retracing steps after the final call. It can achieve iteration-like performance by avoiding cumulative stack growth.

## 0.13. How does the thesis define Green's functions?

Green's functions are kernels used to solve linear problems with linear conditions. They satisfy null linear conditions with a Dirac delta source term, or vice versa. They provide a way to turn differential equations into integral equations.

## 0.14. Summarize convergence behavior of the main algorithm.

For IVPs, the convergence rate seems to be O(h^{1.5}/sqrt(nsim)) where h is the time step size. With control variates, the rate can be increased to O(h^{2.5}) potentially. For BVPs modeled with Fredholm equations, convergence is not analyzed but a fixed point-like convergence is conjectured based on the behavior of coupled splitting.

## 0.15. List your 5 favorite/interesting parts of the thesis.

- The informal introduction to recursive Monte Carlo
- The unbiased handling of non-linear terms
- Recursion in recursion concept
- Coupled recursion for eliminating branching
- Convergence analysis and order for MC trapezoidal rule

## 0.16. What seem to be missing in the thesis?

- More formal notation/definitions
- Expanded related works section
- Clearer transitions between sections
- Convergence proofs
- Comparison to classical methods
- More in-depth analysis and limitations

## 0.17. Any abbreviation that should/shouldn't be used?

- BVP should be defined before use
- RRMC is used before defined
- RMC could be used less

## 0.18. List 5 inaccuracies things in the thesis.

- I did not notice any clear factual inaccuracies after one read through.

## 0.19. List 5 controversial things in the thesis.

- I did not notice anything overtly controversial.

## 0.20. List 5 suggestions to improve the thesis.

- Provide more motivation and intuition throughout
- Expand the related works section
- Add stronger transitions between sections
- Include proofs of key results
- Provide empirical comparisons to classical methods
- Discuss limitations and future work in more depth

# Feedback 1

## 1.1 Does the thesis differentiate between the original contributions and prior work?

The distinction could be clearer. The introduction mentions related works briefly but does not clearly differentiate what is novel compared to prior art. More comparison is needed.

## 1.2 Does the thesis has a good overview?

The overview is decent but could be improved. The table of contents provides an outline but the transitions between sections are unclear at times. Providing more motivation and intuition in the introduction would help give better overview.

## 1.3 Does the thesis has a good conclusion?

The conclusion is very brief and mainly lists limitations. A more thorough conclusion that summarizes the key contributions and ties back to the original goals stated in the introduction would improve it.

## 1.4 Does everything gets defined in the thesis?

Most key terms and concepts are defined, but some abbreviations like BVP are used before being defined. There are also some informal notations that could be made more precise.

## 1.5 Are there symbols that don't get defined in the thesis?

I did not notice any symbols used without definition.

## 1.6 What are the advantages of the solvers in the subsection of initial value problems compared to classical solver?

The advantages compared to classical solvers are not discussed in detail. The introduction speculates they could offer benefits for atypical problems like ODEs with random parameters, but advantages over classical methods are not demonstrated.

## 1.7 Are the explanations for the graphs in the thesis sufficient?

The graph explanations are decent but could be expanded in some cases. For example, the coupled splitting graph would benefit from more discussion of what is being shown.

## 1.8 Do equations, examples, definition, etc get referenced with consistent notation?

The notation seems consistent overall. Examples and equations are tagged with labels that are referenced. Some informal numbered lists could be made more precise.

## 1.9 List 2 uncommon abbreviations that don't get introduced the first time they get used.

- BVP
- IBC

# Feedback 2

## 2.1 Has the elementary theory of Monte Carlo been covered in the thesis?

Yes, the subsection on Monte Carlo integration covers basics like strong law of large numbers, central limit theorem, and definitions of MSE and efficiency.

## 2.2 In the subsection of recursive Monte Carlo why is there indefinite recursion?

Indefinite recursion occurs because the integral equation is recursively defined, so naively replacing the recursive integral with Monte Carlo recursion leads to infinite recursion.

## 2.3 Does the thesis give the necessary references to concepts?

References are included for key concepts, but the related works section could be expanded. Providing some references in the introduction for background would also help.

## 2.4 Does additive branching gets explained clearly?

Additive branching recursion is briefly mentioned as a side effect of techniques like splitting, but not explained in depth. More intuition and examples would help clarify it.

## 2.5 What is the Russian roulette rate?

The Russian roulette rate is the parameter l that controls the probability of evaluating the full random variable vs the approximation in Russian roulette. It is not explicitly defined as such.

## 2.6 Does the local truncation error get defined?

No, local truncation error is not defined. It gets mentioned in the proof of the trapezoidal rule but not explicitly defined.

# Requirements

## 3.1 Title Page:

Yes, the thesis includes a title page.

## 3.2 Table of Contents:

Yes, a table of contents is provided.

## 3.3 Introduction:

The introduction provides some context but could go further in clearly motivating the goals and framing the research question. The problem statement is vaguely formulated currently. Expanding this would help guide the reader.

## 3.4 Exposition:

The exposition is reasonably detailed and logical but transitions between sections could be smoother. The use of subsections to organize content is good overall.

## 3.5 Dutch Summary:

A concise Dutch summary is included as an abstract.

## 3.6 Bibliography:

The bibliography section is present and structured correctly based on the specified citation style.

## 3.7 Layout and Readability:

The layout uses appropriate formatting elements and is readable overall. Some sections would benefit from more white space between chunks of text/equations.

## 3.8 Language Quality:

The language is generally clear and grammatically correct. There are some informal phrasings that could be tightened up.

## 3.9 Results and Analysis:

Key results are presented but more analysis connecting them to broader goals would help. Conclusions generally follow logically from the data.

## 3.10 Argumentation and Coherence:

The flow of ideas is reasonable but transitions between sections could be stronger to improve coherence.

## 3.11 Original Contribution:

The original contributions are not clearly highlighted. More discussion is needed on how the research fills gaps compared to prior works.

## 3.12 Discussion and Implications:

The discussion of broader implications is limited. Suggesting applications and future directions would help strengthen this section.

## 3.13 Clarity and Conciseness:

The writing is relatively clear and concise overall with some exceptions. Defining jargon would help avoid confusion.

## 3.14 Overall Contribution:

The overall contributions are promising but need to be further developed and compared to existing literature to strengthen novelty claims. More dissemination could lead to future citations.
