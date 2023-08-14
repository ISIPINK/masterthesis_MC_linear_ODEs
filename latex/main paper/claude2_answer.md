Here are the questions and answers with numbering for the questions but not the answers:

# Content tests

0.1. How does the main algorithm work of the thesis?

The main algorithm of the thesis is Recursive Monte Carlo (RMC) for solving linear ODEs. It works by first converting the ODE into an integral equation using Green's functions. Then RMC is used to estimate the recursive integral, resulting in a Recursive Random Variable Equation (RRVE) that can be simulated to obtain an unbiased estimate of the solution. Techniques like Russian Roulette, control variates, and recursion in recursion are used to improve the RRVE.

0.2. What is the biggest limitation of the main algorithm of the thesis?

The biggest limitation of the main algorithm is that it has not been rigorously analyzed for convergence, especially in the case of Fredholm integral equations. Figures in the thesis suggest that naive RMC does not always converge. Convergence analysis and ways to ensure convergence need further research.

0.3. How important is coupled splitting to the thesis?

Coupled splitting is presented as a technique to help improve convergence of RMC for some Fredholm equations, but it is not central to the main algorithm. The thesis conjectures it could be valuable for certain problems but does not rely heavily on it.

0.4. How and where does Stein's paradox pop up in the thesis?

Stein's paradox is not discussed in the thesis.

0.5. Rate the language of the thesis.

The language of the thesis is generally clear and accessible. Some parts could benefit from more intuitive explanations and motivations. Overall the quality is good.

0.6. List the 5 unclearest parts of the thesis.

Some of the unclearest parts of the thesis are:

- The introduction of Green's functions could use more intuition.
- The explanation behind Figure 8 is unclear.
- The computational complexity and how it differs from classic methods is not analyzed.
- The assumptions behind relative MC efficiency are not stated.
- The convergence analysis is limited.

0.7. What is special about the Monte Carlo trapezoidal rule?

The Monte Carlo trapezoidal rule achieves an order of convergence in the root mean square error similar to the deterministic trapezoidal rule by eliminating the bias in the local truncation error.

0.8. What is the main advantage of the primary motivating work?

The primary motivating work introduces Walk-on-Spheres for solving PDEs, which is accurate even with complex geometries. It inspired applying similar MC techniques to ODEs.

0.9. How does the thesis define Russian Roulette?

Russian Roulette is defined as replacing a random variable with a less expensive approximation randomly, in a way that preserves the expected value.

0.10. How does the thesis define control variates?

Control variates are defined as modifying an estimator by subtracting out an approximation of it and adding back the expected value of the approximation.

0.11. Summarize the approach for the second example in the unbiased non-linearity section.

For the nonlinear example $y' = y^2$, the solution is represented as a recursive integral which is estimated using $Y_1Y_2$ with $Y_1, Y_2 \stackrel{iid}{\sim} Y$ to handle the nonlinearity.

0.12. How does the thesis define tail recursion?

Tail recursion is defined as reordering operations in recursion so there are no operations after the recursive call, allowing iterative implementation.

0.13. How does the thesis define Green's functions?

Green's functions are kernel functions defined by linear differential equations and conditions, which when integrated against source terms give solutions to related linear differential equations.

0.14. Summarize the convergence behavior of the main algorithm.

The convergence behavior of the main algorithm is limited. For some problems the variance seems to explode, while for others empirical convergence rates around 1.5 are demonstrated, but rigorous convergence results are missing.

# Feedback 1

1.1. Does the thesis differentiate between the original contributions and prior work?

The thesis does a reasonable job distinguishing between original work and background material used. The original contributions could be highlighted more clearly in the introduction.

1.2. Does the thesis has a good overview?

The overview is decent, with a map of relevant literature and summary of key contributions and techniques. A more detailed roadmap in the introduction could improve navigability.

1.3. Does the thesis has a good conclusion?

The conclusion is limited, mainly just stating open problems and future work. A summary of key achievements and open questions would strengthen it.

1.4. Does everything gets defined in the thesis?

Most concepts get defined, but some more intuitive explanations behind definitions would help.

1.5. Are there symbols that don't get defined in the thesis?

All symbols appear to be defined.

1.6. What are the advantages of the solvers in the subsetion of intial value problems compared to classical solver?

The solvers have the advantage of being parallelizable and easily implemented, but likely do not outperform classical methods in terms of computational complexity. This comparison is lacking.

1.7. Are the explanations for the graphs in the thesis sufficient?

The explanations of the graphs are generally sufficient, with the exception of Figure 8 which is unclear.

# Feedback 2

2.1. Has the elementary theory of Monte Carlo been covered in the thesis?

The background covers the basics of Monte Carlo integration reasonably well. More depth could be added on information complexity and the curse of dimensionality.

2.2. In the subsection of recursive Monte Carlo why is there indefinete recursion?

Indefinite recursion occurs because there is no stopping condition when naively converting the recursive integral to a RRVE.

2.3. Does the thesis give the necessary references to concepts?

Concepts are usually referenced, but more references especially for key definitions could strengthen the connection to prior work.

2.4. Does additive branching gets explained clearly?

Additive branching recursion is explained clearly with examples of how splitting leads to it.

2.5. What is the russian roulette rate?

The Russian roulette rate is not explicitly defined, but context suggests it relates to the probability of using the approximation.

2.6. Does the local truncation error get defined?

Local truncation error is not explicitly defined.

# Quality assurance/Requirements

3.1. Title Page: Does the thesis have a title page?

Yes, there is a title page.

3.2. Table of Contents: Does the thesis include a table of contents?

There is a table of contents.

3.3. Introduction: Does the introduction provide a clear context for the research? Is the problem statement or research question clearly formulated in the introduction?

The introduction provides context and the overall goal, but the specific problem statement could be clearer.

3.4. Exposition: Is the argumentation detailed and logical, leading to the final result of the research? Is the substructure effectively used to organize and clarify the content within the exposition?

The exposition generally builds up logically, but some parts lack motivation/intuition. The structure with subsections is good.

3.5. Dutch Summary: Does the thesis include a Dutch summary? Is the Dutch summary concise, effectively summarizing the main points of the thesis within the specified page limit?

There is a concise Dutch summary.

3.6. Bibliography: Is the bibliography section present and well-structured? Are all the cited sources accurately listed in the bibliography according to the specified citation style?

The bibliography is present and structured. The citation style is consistent.

3.7. Layout and Readability: Is the layout designed to enhance readability, including appropriate font, line spacing, and paragraph structure? Is the use of headings, subheadings, and other formatting elements consistent and effective in guiding the reader through the content?

The layout, font, and paragraph structure enhance readability. The use of headings is consistent and effective.

3.8. Language Quality: Is the language used throughout the thesis refined and well-crafted? Are grammar, spelling, and punctuation accurate?

The language is generally clear and well-written with some minor exceptions. Grammar, spelling, and punctuation look accurate.

3.9. Results and Analysis: Are the results presented clearly and comprehensively? Is the analysis of the results thorough, and do the conclusions logically follow from the data?

Results are presented clearly with graphs. More rigorous analysis of the results would strengthen this area.

3.10. Argumentation and Coherence: Is there a clear and logical progression of ideas throughout the thesis? Do transitions between sections and paragraphs enhance the overall coherence of the document?

There is logical flow, but transitions between sections could be smoother.

3.11. Original Contribution: Does the thesis make a unique and valuable contribution to the field of study? Is there a clear statement about how the research fills a gap in existing knowledge?

Original contribution is stated, though the gap filled could be elaborated on more.

3.12. Discussion and Implications: Does the discussion section provide insights into the broader implications of the research findings? Are any practical applications or future research directions suggested?

Practical implications and future work are suggested but not discussed in depth.

3.13. Clarity and Conciseness: Is the writing style clear and concise, avoiding unnecessary jargon? Are complex concepts explained in a way that is understandable to the intended audience?

The writing is concise and jargon is avoided when possible. Some parts could improve clarity.

3.14. Overall Contribution: Does the thesis contribute significantly to the field's body of knowledge and understanding? Is the thesis likely to be cited and referenced by others in the field?

The work makes an incremental contribution to MC methods for ODEs. It is unlikely to be widely cited but could inspire interesting future work.
