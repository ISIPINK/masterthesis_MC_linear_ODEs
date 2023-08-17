Here are my responses to the questions:

# Content tests

## 0.1. How does the main algorithm work of the thesis?

The main algorithm is Recursive Monte Carlo (RMC) for solving initial value problems (IVPs) of systems of ODEs. It works by first converting the IVP into an equivalent integral equation using the fundamental theorem of calculus. Then this integral equation is turned into a Recursive Random Variable Equation (RRVE) which can be simulated using Monte Carlo methods like recursive sampling. Techniques like control variates are used to reduce variance. The key innovation is recursion in recursion where an outer recursion freezes values for an inner recursion to emulate shrinking time steps.

## 0.2. What is the biggest limitation of the main algorithm of the thesis?

The biggest limitation is that the algorithm has not been thoroughly analyzed for convergence. In particular, the behavior is unclear in stiff ODE problems with large negative coefficients. There is also no evidence presented that the algorithm outperforms classical methods.

## 0.3. How important is coupled splitting to the thesis?

Coupled splitting is presented as a technique to help improve convergence for boundary value problems by reducing variance. However, based on the results shown, it does not actually expand the convergence region. So it does not seem to be very important for the main contribution.

## 0.4. How does Stein's paradox pop up in the thesis? (see subsection on MC integration)

The thesis mentions that it is always possible to bias the composite Monte Carlo trapezoidal rule in a way that achieves lower RMSE compared to the unbiased version. This is related to Stein's paradox which shows that biased estimators can outperform unbiased ones in terms of mean squared error.

## 0.5. Rate the language of the thesis.

The language is quite technical and advanced overall. There are some rough patches with typos or unclear phrasing, but generally the writing is clear and precise. I would rate it 7/10 for language quality.

## 0.6. List the 5 unclearest parts of the thesis.

1. The explanation of coupled splitting is confusing, especially the figure showing recursive calls.
2. The abstract does not provide a very clear high-level summary.
3. Some key terms like information-based complexity are not defined rigorously.
4. The motivating work is not explained clearly.
5. The convergence analysis is informal and lacks mathematical rigor.

## 0.7. What is special about the Monte Carlo trapezoidal rule?

The Monte Carlo trapezoidal rule has a convergence order of O(1/n^{2.5}) for smooth functions, which is better than the standard O(1/n^2) rate for the deterministic trapezoidal rule. This is achieved by using control variates based on the trapezoidal approximation.

## 0.8. What is the main advantage of the primary motivating work?

The primary motivating work by Sawhney et al. introduced the Walk-on-Sphere method for solving PDEs. Its main advantage is achieving high accuracy even with complex geometries and boundary conditions.

## 0.9. How does the thesis define Russian Roulette?

Russian Roulette is defined as a way to probabilistically replace a random variable X with a cheaper approximation Y1 or Y2, based on a Bernoulli trial with probability p. This reduces computational costs while preserving the expected value.

## 0.10. How does the thesis define control variates?

Control variates involves approximating the random variable X with a tractable random variable X_tilde. The original X is then expressed as X ≅ (X - X_tilde) + E[X_tilde]. This reduces the variance of the estimator.

## 0.11. Summarize the approach for exponential of the expectance in the unbiased non-linearity section.

The Taylor series of the exponential is manipulated to isolate the expected value inside the terms. Then each term is turned into a Bernoulli trial and the expected value is replaced by independent samples. This results in an unbiased estimator of the exponential of a random variable's expected value.

## 0.12. How does the thesis define tail recursion?

Tail recursion is a way to implement recursion by reordering operations so that the recursive call happens last. This avoids retracing steps on return and can achieve iteration-like performance.

## 0.13. How does the thesis define Green's functions?

Green's functions are kernel functions that can be used to convert linear differential equations into linear integral equations. They satisfy homogeneous conditions with a Dirac delta source term.

## 0.14. Summarize convergence behavior of the main algorithm.

The convergence analysis of the main Recursive Monte Carlo algorithm for IVPs is informal. Empirically it seems to achieve a convergence rate of O(h^{1.5}/sqrt(nsim)) for smooth problems. The behavior for stiff problems and in terms of information-based complexity is unclear.

## 0.15. List your 5 favorite/intrestring parts of the thesis.

1. The recursion in recursion technique to emulate time stepping.
2. Using control variates to eliminate lower order terms and increase convergence order.
3. The unbiased exponential of expected value estimator.
4. Connecting the heat equation to Brownian motion through stochastic recursion.
5. The interactive literature map.

## 0.16. What seem to be missing in the thesis?

- A rigorous convergence analysis
- Comparisons to classical methods
- Discussion of limitations and potential use cases
- More graphs and visualizations
- Clearer overall structure

## 0.17. Any abbreviation that should/shouldn't be used?

- RRVE (Recursive Random Variable Equation) is good
- RMC (Recursive Monte Carlo) is okay
- IVP and ODE are fine
- Avoid abbreviations like IBC, RMSE, RV

## 0.18. List 5 inaccuracies things in the thesis.

1. The abstract suggests coupled splitting helps convergence but results don't show that.
2. Some variable names are inconsistent between equations and implementation.
3. The Monte Carlo efficiency definition doesn't match reference.
4. The Green's function definition is informal.
5. Lemma about Brownian motion is limited case of Feynman-Kac formula.

## 0.19. List 5 controversial things in the thesis.

1. Claiming recursion in recursion has optimal information-based complexity without proof.
2. Stating conjecture on convergence speed of biased RRMC without analysis.
3. Suggesting RRMC could outperform classical methods in some cases without evidence.
4. Implying coupled splitting converges like fixed point methods without details.
5. Using uncommon terminology like "simulation at risk" without defining.

## 0.20. List 5 suggestions to improve the thesis.

1. Add formal convergence analysis and comparisons to other methods.
2. Restructure sections to have clearer narrative flow.
3. Define key concepts like IBC more rigorously.
4. Standardize variable notation.
5. Add more plots and empirical results.

# Feedback 1

## 1.1 Does the thesis differentiate between the original contributions and prior work?

The original contributions are not explicitly differentiated from prior work. The introduction mentions applying techniques from other fields but does not clearly highlight the novel aspects.

## 1.2 Does the thesis has a good overview?

The overview is okay but lacks clear high-level takeaways. The abstract does not provide an effective summary. And the overall structure can be improved.

## 1.3 Does the thesis has a good conclusion?

No, there is no dedicated conclusion section. The final subsection acts as a conclusion but mainly just proposes future work.

## 1.4 Does everything gets defined in the thesis?

Some key concepts like information-based complexity are not defined rigorously. And terminology is inconsistent in places. But overall definitions are decent.

## 1.5 Are there symbols that don't get defined in the thesis?

A few symbols seem to be undefined, like the $W$ matrix in the coupled splitting example.

## 1.6 What are the advantages of the solvers in the subsection of initial value problems compared to classical solver?

The advantages compared to classical solvers are not discussed. The methods can handle randomness and avoid grid constraints but convergence speed and computational costs are unclear.

## 1.7 Are the explanations for the graphs in the thesis sufficient?

The graph explanations are fairly minimal. More details on the setup and implications of results would help comprehension.

## 1.8 Do equations, examples, definition, etc get referenced with consistent notation?

The notation is inconsistent in some places. For example, variable names differ between equations and Python code samples. Overall referencing needs to be standardized.

## 1.9 List 2 uncommon abbreviations that don't get introduced the first time they get used.

- IBC
- RMSE

# Feedback 2

## 2.1 Has the elementary theory of Monte Carlo been covered in the thesis?

Yes, the subsection on Monte Carlo integration covers basics like blue estimators, variance reduction, and relative efficiency.

## 2.2 In the subsection of recursive Monte Carlo why is there indefinite recursion?

Indefinite recursion happens because there is no stopping condition when recursively evaluating the RRVE. Approximating near 0 introduces bias to terminate.

## 2.3 Does the thesis give the necessary references to concepts?

References are included for most concepts but could be more comprehensive. Some techniques like Russian roulette are not referenced.

## 2.4 Does additive branching gets explained clearly?

Additive branching recursion is mentioned but not clearly explained as the exponential growth when splitting recursion naively.

## 2.5 What is the Russian roulette rate ?

The Russian roulette rate determines the probability of recursing vs terminating. Higher rate means more recursions.

## 2.6 Does the local truncation error get defined ?

No, local truncation error is not defined in the thesis.

# Requirements

## 3.1 Title Page: Does the thesis have a title page?

Yes, there is a title page.

## 3.2 Table of Contents: Does the thesis include a table of contents?

Yes, a table of contents is included.

## 3.3 Introduction: Does the introduction provide a clear context for the research? Is the problem statement or research question clearly formulated in the introduction?

The introduction provides some context by mentioning related work and fields drawn from. But the problem statement and main research question are not explicitly formulated.

## 3.4 Exposition: Is the argumentation detailed and logical, leading to the final result of the research? Is the substructure effectively used to organize and clarify the content within the exposition?

The argumentation is reasonably detailed and logical, but the overall structure could be improved for clarity. The use of subsections is decent.

## 3.5 Dutch Summary: Does the thesis include a Dutch summary? Is the Dutch summary concise, effectively summarizing the main points of the thesis within the specified page limit?

Yes, there is a one-page Dutch summary included. It seems to concisely summarize the main points.

## 3.6 Bibliography: Is the bibliography section present and well-structured? Are all the cited sources accurately listed in the bibliography according to the specified citation style?

The bibliography is present and well-formatted. The cited sources appear to be accurately referenced in the desired citation style.

## 3.7 Layout and Readability: Is the layout designed to enhance readability, including appropriate font, line spacing, and paragraph structure? Is the use of headings, subheadings, and other formatting elements consistent and effective in guiding the reader through the content?

The layout and formatting generally facilitate readability. Headings and subsections guide the structure reasonably well. The code blocks interfere slightly with the flow but overall it is decently readable.

## 3.8 Language Quality: Is the language used throughout the thesis refined and well-crafted? Are grammar, spelling, and punctuation accurate?

The language is rather technical but well-written overall. There are some minor grammatical/spelling issues but the quality is good in general.

## 3.9 Results and Analysis: Are the results presented clearly and comprehensively? Is the analysis of the results thorough, and do the conclusions logically follow from the data?

The results are presented through figures and empirical convergence measurements. More analysis and context for the results would make them easier to interpret. And there are limited formal conclusions drawn.

## 3.10 Argumentation and Coherence: Is there a clear and logical progression of ideas throughout the thesis? Do transitions between sections and paragraphs enhance the overall coherence of the document?

The flow of ideas is reasonably clear within sections but transitions between sections could be improved. Overall coherence is decent but restructuring would help.

## 3.11 Original Contribution: Does the thesis make a unique and valuable contribution to the field of study? Is there a clear statement about how the research fills a gap in existing knowledge?

The original contributions are not explicitly stated. There is mention of applying techniques from other fields but the unique contributions are unclear.

## 3.12 Discussion and Implications: Does the discussion section provide insights into the broader implications of the research findings? Are any practical applications or future research directions suggested?

The final subsection suggests future work but does not really discuss broader implications or practical applications. The contributions are mainly theoretical.

## 3.13 Clarity and Conciseness: Is the writing style clear and concise, avoiding unnecessary jargon? Are complex concepts explained in a way that is understandable to the intended audience?

The writing is technical but generally clear and precise. Some complex concepts could be explained more intuitively. But overall it is reasonably concise and understandable.

## 3.14 Overall Contribution: Does the thesis contribute significantly to the field's body of knowledge and understanding? Is the thesis likely to be cited and referenced by others in the field?

The potential for significant impact is unclear without more empirical comparisons and details. If the conjectures hold true, it could be an interesting contribution. But more evidence is needed to evaluate the likelihood of influencing the field.

In summary, the thesis meets most formal requirements and presents some interesting ideas. But the original contributions need to be clarified. And more rigorous analysis, comparisons, and empirical results would substantiate the claims better. Restructuring for clarity and flow would also enhance the quality. But overall it shows promise as the foundation for a solid thesis.
