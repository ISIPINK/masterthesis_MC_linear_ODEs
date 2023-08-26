Here are my answers to the questions:

# Content tests

## 0.1. How does the main algorithm work of the thesis?

The main algorithm is Recursive Monte Carlo (RMC) applied to solving ordinary differential equations (ODEs) and partial differential equations (PDEs). It involves turning the equations into recursive integral equations and then estimating the recursive integrals with Monte Carlo sampling to get recursive random variable equations. Variance reduction techniques like control variates and Russian roulette are used to improve the efficiency. The key ideas are recursion in recursion for initial value problems and coupled recursion/splitting for boundary value problems.

## 0.2. What is the biggest limitation of the main algorithm of the thesis?

The biggest limitation seems to be that RMC struggles with stiff ODEs in a similar way to explicit solvers. The thesis attempts to address this with diagonal RMC but notes that it is not very effective. More work is likely needed to extend RMC to handle stiffness well.

## 0.3. How important is coupled splitting to the thesis?

Coupled splitting is one of the key techniques proposed in the thesis for solving boundary value problems with RMC while controlling the branching recursion. So it plays an important role in making RMC viable for PDEs with boundary conditions.

## 0.4. How does Stein's paradox pop up in the thesis? (see subsection on MC integration)

The thesis mentions Stein's paradox in the context of the Monte Carlo trapezoidal rule to note that it is possible to bias the estimator in a way that reduces the RMSE, even though it is an unbiased estimator. This illustrates how unbiasedness does not necessarily imply optimal efficiency.

## 0.5. Rate the language of the thesis.

The language is generally clear and precise, with some minor rough patches. Mathematical notation and terminology is used extensively, which is appropriate for the technical subject matter. The writing could be smoothed out slightly in places to enhance readability, but overall it effectively conveys the key ideas. I would rate the language as good.

## 0.6. List the 5 unclearest parts of the thesis.

- The definition of recursion in recursion. More intuition or examples would help.
- The explanation of how coupled splitting helps eliminate additive branching recursion.
- The convergence proof sketch for the Monte Carlo trapezoidal rule.
- The motivation for diagonal RMC and how it relates to implicit methods.
- The relation between RMC and stochastic gradient descent methods.

## 0.7. What is special about the Monte Carlo trapezoidal rule?

The Monte Carlo trapezoidal rule has a higher order of convergence (O(1/n^2.5)) compared to standard Monte Carlo (O(1/√n)) while using roughly the same number of function evaluations. This is because the trapezoidal rule approximation acts as an effective control variate.

## 0.8. What is the main advantage of the primary motivating work?

The main motivating work by Sawhney et al. showed high accuracy for solving PDEs with complex geometries using walk on spheres methods. This inspired exploring RMC techniques for extending walk on spheres to things like ODEs and other types of PDEs.

## 0.9. How does the thesis define Russian Roulette?

Russian roulette is defined as replacing a random variable X with a probabilistically weighted approximation that is cheaper to evaluate, in a way that preserves the expected value. Bernoulli variables are used to select whether to compute X fully or use the approximation.

## 0.10. How does the thesis define control variates?

Control variates are defined as subtracting an approximation function from the integrand/recursive term and adding back its expected value. This reduces the variance of the remaining part that needs to be estimated stochastically.

## 0.11. Summarize the approach for exponential of the expectance in the unbiased non-linearity section.

The Taylor series of the exponential is manipulated by changing the coefficients to Bernoulli variables and replacing the argument with independent samples. This results in an unbiased stochastic expression for the exponential of an expected value.

## 0.12. How does the thesis define tail recursion?

Tail recursion is defined as reordering operations so that the recursive call happens last. This allows the result to be returned without retracing all the recursion steps.

## 0.13. How does the thesis define Green's functions?

Green's functions are defined as kernel functions that can be combined with integration to solve linear differential equations with linear boundary conditions. They are composed of homogeneous and particular solutions to the problem.

## 0.14. Summarize convergence behavior of the main algorithm.

For initial value problems, recursion in recursion Monte Carlo is shown to achieve O(h^1.5) convergence locally, where h is the step size. For boundary value problems, coupled splitting gives a fixed point iteration-like convergence. Overall convergence analysis is limited.

## 0.15. List your 5 favorite/intrestring parts of the thesis.

- The interactive map of the literature review.
- The visual recursive call plots to build intuition.
- The unbiased nonlinearity techniques.
- Recursion in recursion idea for emulating adaptive step size.
- Attempting coupled splitting to handle branching recursion.

## 0.16. What seem to be missing in the thesis?

- More convergence analysis, especially for PDEs/BVPs.
- Comparisons to classical methods in terms of efficiency.
- Discussion of parallelization and implementation.
- Details on handling discontinuities and nonsmoothness.
- Examples with real-world applications.

## 0.17. Any abbreviation that should/shouldn't be used?

- RMC and MC are used extensively, which is appropriate.
- RRVE for recursive random variable equation seems unnecessary.
- Some unusual abbreviations like IBC and BLUE could be defined more clearly the first time.

## 0.18. List 5 inaccuracies things in the thesis.

I did not notice any clear factual inaccuracies. The thesis seems to cover the material accurately based on my review.

## 0.19. List 5 controversial things in the thesis.

There does not seem to be anything too controversial in the thesis. A few points that could invite debate:

- Claiming the MC trapezoidal rule achieves optimal IBC rates without proof.
- Stating recursion in recursion emulates adaptive step size well without analysis.
- Using control variates in ways that destroy sparsity of linear systems.
  -Recommending Russian roulette rates without measurements or theory.
- Claiming coupled splitting converges similarly to fixed point methods without proof.

## 0.20. List 5 suggestions to improve the thesis.

- Provide more numerical experiments and convergence measurements.
- Include comparisons to other standard methods.
- Give examples of parallel implementation and performance.
- Expand the discussion and limitations section.
- Add some real-world application examples.
- Provide more intuitive explanations of key concepts.
- Improve the flow and transitions between sections.
- Add more figures for visual learners.
- Clarify how techniques extend to higher dimensions.
- Relate methods back to key literature more frequently.

# Feedback 1

## 1.1 Does the thesis differentiate between the original contributions and prior work?

Yes, the introduction summarizes the key original contributions and gives an overview of the related work that motivated or inspired the research.

## 1.2 Does the thesis has a good overview?

Yes, the abstract provides a concise yet comprehensive summary and the introduction gives a good high-level overview of the context, problem statement, and contributions.

## 1.3 Does the thesis has a good conclusion?

The conclusion is limited, mainly just mentioning areas for future work. Expanding the conclusion to better summarize the key points and contributions of the work could enhance it.

## 1.4 Does everything gets defined in the thesis?

In general, key terms and concepts are defined either close to their first use or in specific definitions sections. A few uncommon abbreviations could be clarified earlier on.

## 1.5 Are there symbols that don't get defined in the thesis?

I did not notice any symbols used without being defined, besides common math symbols. The notation seems well documented throughout.

## 1.6 What are the advantages of the solvers in the subsection of initial value problems compared to classical solver?

The key potential advantages mentioned are parallelization due to the Monte Carlo formulation and the ability to handle problems with stochastic parameters. However, the thesis notes that in their current form, the solvers do not outperform classical methods. More work is needed to improve efficiency and robustness.

## 1.7 Are the explanations for the graphs in the thesis sufficient?

Most of the time yes, but some graphs could benefit from more elaboration on what is being demonstrated exactly and how it connects back to the concepts.

## 1.8 Do equations, examples, definition, etc get referenced with consistent notation?

Yes, the numbering and referencing of equations, examples, figures, etc. seems consistent, allowing them to be easily located.

## 1.9 List 2 uncommon abbreviations that don't get introduced the first time they get used.

- IBC
- BLUE

# Feedback 2

## 2.1 Has the elementary theory of Monte Carlo been covered in the thesis?

Yes, the background section introduces key Monte Carlo concepts including estimators, variance, unbiasedness, efficiency, and integration techniques.

## 2.2 In the subsection of recursive Monte Carlo why is there indefinite recursion?

Indefinite recursion occurs because the integral equation solutions involve the function value at prior points, leading to recursive nesting if directly simulated. Approximations like Russian roulette are needed to terminate the recursion.

## 2.3 Does the thesis give the necessary references to concepts?

In general yes, references are provided for key concepts and techniques from the literature. Perhaps some more citations could be added in the background sections.

## 2.4 Does additive branching gets explained clearly?

The explanation of additive branching resulting from naively splitting recursive terms could be expanded and made more intuitive. Examples clearly demonstrating it arising would help.

## 2.5 What is the Russian roulette rate ?

The Russian roulette rate determines the probability of using the approximation vs computing the original random variable in full. It controls the variance vs computational cost trade-off.

## 2.6 Does the local truncation error get defined ?

The local truncation error is not rigorously defined, but there is an informal explanation of how the local errors accumulate into global error in the context of the trapezoidal rule proof sketch.

# Requirements

## 3.1 Title Page: Does the thesis have a title page?

Yes, there is a title page.

## 3.2 Table of Contents: Does the thesis include a table of contents?

Yes, a table of contents is included.

## 3.3 Introduction:

### Does the introduction provide a clear context for the research?

Yes, the introduction sets the context well by summarizing related work and clearly stating the problem.

### Is the problem statement or research question clearly formulated in the introduction?

The key contributions and techniques are clearly highlighted, though there could be a more explicit problem statement.

## 3.4 Exposition:

### Is the argumentation detailed and logical, leading to the final result of the research?

The arguments are generally clear and logical, but could benefit from more intuitive explanations in some areas. Overall it builds effectively to the main results.

### Is the substructure effectively used to organize and clarify the content within the exposition?

Yes, the use of sections, subsections, examples, figures, etc. is logical and helps organize the content well.

## 3.5 Dutch Summary:

### Does the thesis include a Dutch summary?

Yes, there is a Dutch summary.

### Is the Dutch summary concise, effectively summarizing the main points of the thesis within the specified page limit?

The Dutch summary concisely highlights the key points and contributions respecting the length limit.

## 3.6 Bibliography:

### Is the bibliography section present and well-structured?

Yes, the bibliography is present and structured properly.

### Are all the cited sources accurately listed in the bibliography according to the specified citation style?

The citations appear to be accurately formatted according to the specified style.

## 3.7 Layout and Readability:

### - Is the layout designed to enhance readability, including appropriate font, line spacing, and paragraph structure?

The layout uses clear formatting that aids readability. Some paragraphs could be broken up with more spacing between conceptual blocks.

### - Is the use of headings, subheadings, and other formatting elements consistent and effective in guiding the reader through the content?

Headings and formatting are used consistently and help orient the reader.

## 3.8 Language Quality:

### - Is the language used throughout the thesis refined and well-crafted?

The language is precise and academic. Some minor grammatical/stylistic improvements could enhance readability.

### - Are grammar, spelling, and punctuation accurate?

Grammar, spelling, and punctuation appear mostly accurate throughout.

## 3.9 Results and Analysis:

### - Are the results presented clearly and comprehensively?

Key results are presented through examples, equations, and figures. More results could be shown for a more comprehensive evaluation.

### - Is the analysis of the results thorough, and do the conclusions logically follow from the data?

The analysis is reasonably thorough but could go deeper in some areas. Overall the conclusions are supported by the results.

## 3.10 Argumentation and Coherence:

### - Is there a clear and logical progression of ideas throughout the thesis?

Generally yes, though some transitions between conceptual blocks could be smoother.

### - Do transitions between sections and paragraphs enhance the overall coherence of the document?

The section transitions are effective but some paragraph transitions are abrupt. More linking sentences between concepts would help coherence.

## 3.11 Original Contribution:

### - Does the thesis make a unique and valuable contribution to the field of study?

Applying RMC to differential equations and proposing techniques like recursion in recursion appear to be novel contributions.

### - Is there a clear statement about how the research fills a gap in existing knowledge?

The introduction highlights how it extends methods like walk on spheres to new problem domains, filling a gap.

## 3.12 Discussion and Implications:

### - Does the discussion section provide insights into the broader implications of the research findings?

The discussion of limitations and future work is limited. A more extensive discussion of implications would be beneficial.

### - Are any practical applications or future research directions suggested?

Some future research directions are mentioned but practical applications are lacking. Both could be expanded on.

## 3.13 Clarity and Conciseness:

### - Is the writing style clear and concise, avoiding unnecessary jargon?

The style is clear and concise overall, with some jargon/terminology that could be clarified.

### - Are complex concepts explained in a way that is understandable to the intended audience?

Many complex concepts are well explained, but some would benefit from more intuitive explanations and examples.

## 3.14 Overall Contribution:

### - Does the thesis contribute significantly to the field's body of knowledge and understanding?

The proposed techniques appear to make valuable contributions that could advance the field. However, more evaluation is needed to determine the significance.

### - Is the thesis likely to be cited and referenced by others in the field?

The ideas introduced seem novel enough that the work could be cited by others building on these concepts and methods.
