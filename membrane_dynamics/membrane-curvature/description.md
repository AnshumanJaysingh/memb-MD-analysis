# **Membrane curvature calcution**

## **Major dependencies:**

1. [MDAnalysis](https://www.mdanalysis.org/)
2. [Membrane Curvature](https://membrane-curvature.readthedocs.io/en/latest/index.html)
3. matplotlib
4. scipy
5. scipy
6. more_itertools

<style TYPE="text/css">
code.has-jax {font: inherit; font-size: 100%; background: inherit; border: inherit;}
</style>
<script type="text/x-mathjax-config">
MathJax.Hub.Config({
    tex2jax: {
        inlineMath: [['$','$'], ['\\(','\\)']],
        skipTags: ['script', 'noscript', 'style', 'textarea', 'pre'] // removed 'code' entry
    }
});
MathJax.Hub.Queue(function() {
    var all = MathJax.Hub.getAllJax(), i;
    for(i = 0; i < all.length; i += 1) {
        all[i].SourceElement().parentNode.className += ' has-jax';
    }
});
</script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.4/MathJax.js?config=TeX-AMS_HTML-full"></script>


## **Theory**

Let $\kappa_{1}$ and $\kappa_{2}$ be the principal curvatures of a surface patch $\boldsymbol{\sigma}(u, v)$. The Gaussian curvature of $\boldsymbol{\sigma}$ is
$$
K=\kappa_{1} \kappa_{2},
$$
and its mean curvature is
$$
H=\frac{1}{2}\left(\kappa_{1}+\kappa_{2}\right) .
$$
To compute $K$ and $H$, we use the first and second fundamental forms of the surface:
$$
E d u^{2}+2 F d u d v+G d v^{2} \quad \text { and } \quad L d u^{2}+2 M d u d v+N d v^{2} .
$$
Again, we adopt the matrix notation:
$$
\mathcal{F}_{1}=\left(\begin{array}{cc}
E & F \\
F & G
\end{array}\right) \quad \text { and } \quad \mathcal{F}_{2}=\left(\begin{array}{cc}
L & M \\
M & N
\end{array}\right) .
$$


By definition, the principal curvatures are the eigenvalues of $\mathcal{F}_{1}^{-1} \mathcal{F}_{2}$. Hence the determinant of this matrix is the product $\kappa_{1} \kappa_{2}$, i.e., the Gaussian curvature $K$. So
$$
\begin{aligned}
K &=\operatorname{det}\left(\mathcal{F}_{1}-1 \mathcal{F}_{2}\right) \\
&=\operatorname{det}\left(\mathcal{F}_{1}\right)^{-1} \operatorname{det}\left(\mathcal{F}_{2}\right) \\
&=\frac{L N-M^{2}}{E G-F^{2}} .
\end{aligned}
$$

The trace of the matrix is the sum of its eigenvalues, thus, twice the mean curvature $H$. After some calculation, we obtain
$$
\begin{aligned}
H &=\frac{1}{2} \operatorname{trace}\left(\mathcal{F}_{1}-1 \mathcal{F}_{2}\right) \\
&=\frac{1}{2} \frac{L G-2 M F+N E}{E G-F^{2}}
\end{aligned}
$$
An equivalent way to obtain $K$ and $H$ uses the fact that the principal curvatures are also the roots of
$$
\operatorname{det}\left(\mathcal{F}_{2}-\kappa \mathcal{F}_{1}\right)=0
$$
which expands into a quadratic equation:
$$
\left(E G-F^{2}\right) \kappa^{2}-(L G-2 M F+N E) \kappa+L N-M^{2}=0
$$
The product $K$ and the sum $2 H$ of the two roots, can be determined directly from the coefficients. The results are the same as in (1) and (2).

Conversely, given the Gaussian and mean curvatures $K$ and $H$, we can easily find the principal curvatures $\kappa_{1}$ and $\kappa_{2}$, which are the roots of
$$
\kappa^{2}-2 H \kappa+K=0
$$
i.e., $H \pm \sqrt{H^{2}-K}$.



# Classification of Surface Points

The Gaussian curvature is independent of the choice of the unit normal $\hat{n}$. To see why, suppose $\hat{\boldsymbol{n}}$ is changed to $-\hat{\boldsymbol{n}}$. Then the signs of the coefficients of $L, M, N$ change, so do the signs of both principal curvatures $\kappa_{1}$ and $\kappa_{2}$, which are the roots of $\operatorname{det}\left(\mathcal{F}_{2}-\kappa \mathcal{F}_{1}\right)$. Their product $K=\kappa_{1} \kappa_{2}$
is unaffected. The mean curvature $H=\left(\kappa_{1}+\kappa_{2}\right) / 2$, nevertheless, has its sign depending on the choice of $\hat{\boldsymbol{n}}$.

The sign of $K$ at a point $\boldsymbol{p}$ on a surface $\mathcal{S}$ has an important geometric meaning, which is detailed below.
1. $K>0$ The principal curvatures $\kappa_{1}$ and $\kappa_{2}$ have the same sign. The normal curvature $\kappa$ in any tangent direction $t$ is equal to $\kappa_{1} \cos ^{2} \theta+\kappa_{2} \sin ^{2} \theta$, where $\theta$ is the angle between $t$ and the principal vector corresponding to $\kappa_{1}$. So $\kappa$ has the same sign as that of $\kappa_{1}$ and $\kappa_{2}$. The surface is bending away from its tangent plane in all tangent directions at $\boldsymbol{p}$. The quadratic approximation of the surface near $p$ is the paraboloid.

2. $K<0$ The principal curvatures $\kappa_{1}$ and $\kappa_{2}$ have opposite signs at $p$. The quadratic approximation of the surface near $p$ is a hyperboloid. The point is said to be a hyperbolic point of the surface. 


3. $K=0$ There are two cases:
* Only one principal curvature, say, $\kappa_{1}$, is zero. In this case, the quadratic approximation is the cylinder $z=\frac{1}{2} \kappa_{2} y^{2}$. The point $\boldsymbol{p}$ is called a parabolic point of the surface.
* Both principal curvatures are zero. The quadratic approximation is the plane $z=0$. The point $\boldsymbol{p}$ is a planar point of the surface. One cannot determine the shape of the surface near $\boldsymbol{p}$ without examining the third or higher order derivatives. For example, a point in the plane and the origin of a monkey saddle $z=x^{3}-3 x y^{2}$ (shown on the next page) are both planar points, but they have quite different shapes.
