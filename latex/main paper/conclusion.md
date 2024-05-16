<!-- this is my 1st version of conclusions and future work in our
masterthesis -->

\section{Conclusions and Future Work}

(a lot is unsaid ...)

Some parts are underdeveloped, unexplored, or insufficiently integrated
into the existing body of literature.
At the time of writing this thesis, our primary reference was the Walk on Spheres literature.

We discovered
the improved random convergence of integration and IVPs, the
use of a Poisson process to circumvent recursion (as shown in \ref{jl:main poisson}),
and the recursive estimator for $e^{E[X]}$ (as demonstrated in example \ref{ex:exp int}). \\
(this caused multiple structure changes to thesis making it as a whole not unified)

The main Poisson algorithm \ref{jl:main poisson} came to our knowledge after the section on RRMC was written. The description on the main Poisson algorithm is rushed and
we are sure that we missed good properties of the algorithm. It is definetly worth
studying on its own.
It may also be possible to circumvent recursion in RRMC similar to algorithm how we reversed the Poisson proces in the main Poisson algorithm. A different strategy that
involves taking deterministic step is also viable option then incorporate smoothness information.

Our techniques for linear IVPs are based on transforming to integral equations which should be extendable
to linear delay differential equations. Other directions to obtain unbiased solvers for IVPs involves directly estimating
the Magnus expansion, where unbiased estimators for $e^{\int_{0}^{\Delta t} A(s)ds} y(0)$ are required.
This is related to work on evaluating matrix functions with Monte Carlo methods, as seen in \cite{guidotti_fast_2023}.
Yet a different way to obtain an unbiased estimator is to use unbiased piecewise
constant estimators of $A(t)$ and $f(t)$ and solving linear constant variable IVPs  
on the constant pieces.
\\

In subsection \ref{sec:greens functions}, we developed global integral equations for a test problem.
Despite the inherent local nature of ODEs, we are curious whether this locality is retained in the global integral equations.
More specifically, we are interested in whether this local nature can be leveraged to enhance the efficiency of
estimators solving these global integral equations, even without knowledge of the original ODEs. \\

Coupled splitting's convergence behavior and unbiasedness at each iteration are key attributes.
However, the use of recursion and Russian roulette in its implementation poses practical challenges.
Despite these challenges, numerous opportunities exist to further optimize the performance of coupled splitting
with typical MC techniques.

We employed the adjoint main Poisson method \ref{jl:adjoint main poisson} as the foundation for deriving our
point estimators for the heat equation. However, it remains uncertain which class of problems can be addressed
by the adjoint main Poisson method in a manner similar to the heat equation.
% maybe I should add this
We have not fully discussed how to combine presampling with path stitching and when it is possible to do so.
We think that this can be interpreted as U-statistic with i.i.d. subpaths. \\

One of the elements lacking in our findings is rigor.
\cite{ermakov_monte_2021} presents Theorems $1$ and $2$ to
show that their estimators have finite variance and provide an expression for it.
Before becoming aware of \cite{ermakov_monte_2021}, we
previously attempted to derive an expression for the variance
by employing the law of total variance, similar to (16) in \cite{rath_ears_2022}. \\
We believe that proving the optimality of IBC in Example \ref{ex:CV RRMC IVP} is feasible
but tedious.
\cite{daun_randomized_2011} presented a proof for optimal IBC for their algorithm.
The proof we have in mind is using a lower bound on IBC
from integration and proving it is attained.\\

<!-- this is 2nd version  of conclusions and future work in our
masterthesis -->

\section{Conclusions and Future Work}

While we discussed many different topics, the scope was limited. There are still several areas that require further exploration, development, and better integration into the existing literature.

Initially, our primary reference was the Walk on Spheres literature.
The application of its techniques to IVPs guided us to enhanced random convergence for integration/IVPs, the employment of a Poisson process to bypass recursion, and the recursive estimator for $e^{E[X]}$. These parallel discoveries resulted in numerous structural modifications in our thesis, resulting in a disjointed narrative throughout.

One area that definitely deserves further investigation is the main Poisson algorithm, which we discovered after completing our section on RRMC. Our investigation of the algorithm is rushed, and we are confident that there are additional valuable properties that remain to be discovered. We are interested in methods that exhibit behavior similar to RRMC derived from or related to the Main Poisson algorithm.

In addition to this, our methods for linear IVPs, which involve transformation to integral equations, could potentially be expanded to linear delay differential equations. Parallel to the integral equation approach, another direction involves direct estimation of the Magnus expansion. This would necessitate unbiased estimators for expressions of the type $e^{\int_{0}^{\Delta t} A(s)ds} y(0)$. This is related to the work on evaluating matrix functions using Monte Carlo methods, as referenced in \cite{guidotti_fast_2023}. An alternative approach could be to combine unbiased piecewise constant estimators of $A(t)$ and $f(t)$ with solvers for linear constant variable IVPs.

In the subsection discussing Green's functions, we formulated global integral equations for a test problem. We interested if the local characteristics of ODEs persist in these global integral equations. Specifically, if this local aspect can be utilized to improve the efficiency of estimators tasked with solving these integral equations.

The practicality of Coupled splitting remains uncertain. Despite its favorable convergence behavior and unbiasedness at each iteration, the implementation presents practical difficulties due to the use of recursion and Russian roulette. Additionally, the dense matrix multiplications make it too costly to be efficient. However, these challenges do not rule out the potential for performance optimization of Coupled splitting using standard MC techniques.

We used the adjoint main Poisson method as the basis for deriving our point estimators for the heat equation. An other point of view can be obtained by using the Feynman-Kac formula by Monte Carlo estimating the integral over time and doing a space discretization. However, it's unclear which types of problems can be tackled using the adjoint main Poisson method in a way similar to the heat equation. Ideally, we would like to find something akin to the Feynman-Kac formula for different PDEs that retains as many of the desirable properties as possible, but is more broadly applicable. Furthermore, we have yet to fully investigate how to merge presampling with path stitching and under what circumstances this is feasible. An interesting observation when combining presampling with path stitching is that we can interpret subpaths as independent and identically distributed variables in a U-estimator.

Identifying suitable applications for the proposed algorithms could result in specialized versions tailored specifically for those use cases. Potential applications could be in fields MC methods are prevalent. Unbiased algorithms naturally fit scenarios where the primary computational load or the quantity of interest is an average. This is particularly true in situations with minimal structure, where the advantage of IBC over deterministic algorithms are meaningful, or where the linear trade-off between cost and variance is nearly optimal. We believe that unbiased linear IVPs solvers are a good stepping stone to developing/understanding randomized ODE/PDE solvers. The applications we have in mind include enhancing the efficiency of existing WoS methods, adapting MC algorithms in reinforcement learning, and creating stochastic gradient descent methods from an ODE perspective that utilize stochastic step sizes to improve stability.

Finally, one of the elements lacking in our findings is rigor. We attempted to derive an expression for the variance by employing the law of total variance, similar to \cite{rath_ears_2022}. However, we were unaware of \cite{ermakov_monte_2021} at the time, which presents theorems to show that their estimators have finite variance and provide an expression for it but this aplies only directly on the adjoint Main Poisson algorithm and may require some work to further generalize. We believe that proving the optimality of IBC in Example \ref{ex:CV RRMC IVP} is feasible but tedious, by a proof using a lower bound on IBC from integration and proving it is attained.

<!-- Answer in markdown :
Are the implications and contributions of the research clearly stated?
Are the limitations of the study acknowledged and avenues for future research suggested?
Are the practical applications and relevance of the research discussed?
Are potential future research directions and their potential impact clearly outlined?
List 5 unclearest parts.
List 5 grammar mistakes.
Are the transitions between paragraphs good?
List 5 language shortcomings.
 -->
