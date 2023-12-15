$$
\begin{aligned}
u_{t} &= u_{xx} + \alpha(x,t) u +f \\
u_{t} &= \frac{u_{+} -2u + u_{-}}{\Delta x^{2}} + (\alpha(x,t) + \alpha_{0}) u +f \\
u_{t} + \left( \frac{2}{\Delta x ^{2}} - \alpha_{0} \right) u  &= \frac{u_{+} + u_{-}}{\Delta x^{2}} +\alpha(x,t) u+ f
\end{aligned}
$$

Call $\left( \frac{2}{\Delta x^{2}} - \alpha_{0} \right) = \beta$

$$
\begin{aligned}
u_{t} +  \beta u  &= \frac{u_{+} + u_{-}}{\Delta x^{2}} +\alpha(x,t) u+ f  \Leftrightarrow \\
u &= e^{-t \beta }
\left(
     u_{0}  + \int_{0}^{t}e^{s \beta }
    \left(
        \frac{u_{+} + u_{-}}{\Delta x^{2}} +\alpha(x,s) u+ f
     \right)
     ds
\right)  \\
u &=
     \int_{0}^{e^{-t \beta }} u_{0} d\tau  + \int_{e^{-t \beta }}^{1}
     \beta^{-1}
    \left(
        \frac{u_{+} + u_{-}}{\Delta x^{2}} +\alpha(x,s) u+ f
     \right)
     d\tau
\end{aligned}
$$
