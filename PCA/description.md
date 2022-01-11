*****Bulk PCA analysis*
****
Principal component analysis is also called covariance analysis or essential dynamics analysis. It uses the covariance matrix σ of the atomic coordinates:

where q1,...,q3N are the mass-weighted Cartesian coordinates and <...> denotes the average over all sampled conformations. By diagonalizing σ, we obtain 3N eigenvectors v(i) and eigenvalues λi with

The eigenvectors and eigenvalues of σ yield the modes of collective motion and their amplitudes. The principal components (PCs)

can then be used, for example, to represent the free energy surface. From the above equation we see that, e.g., the first three components v1(i), v2(i) and v3(i) of the eigenvector v(i) reflect the influence of the x, y and z coordinates of the first atom on the i-th PC.

*σ*<sub>*i**j*</sub> = ⟨(*q*<sub>*i*</sub>−⟨*q*<sub>*i*</sub>⟩)(*q*<sub>*j*</sub>−⟨*q*<sub>*j*</sub>⟩)⟩
where *q*<sub>1</sub>, …, *q*<sub>3*N*</sub> are the mass-weighted
Cartesian coordinates and ⟨…⟩ denotes the average over all sampled
conformations. By diagonalizing *σ*, we obtain 3*N* eigenvectors
*ψ*<sup>(*i*)</sup> and eigenvalues *λ*<sub>*i*</sub> with
*λ*<sub>1</sub> ≥ *λ*<sub>2</sub> ≥ ⋯ ≥ *λ*<sub>3*N*</sub>
The eigenvectors and eigenvalues of *σ* yield the modes of collective
motion and their amplitudes. The principal components (PCs)
$$\\begin{aligned}
V\_{i}=& \\mathbf{v}^{(i)} \\cdot \\mathbf{q}=v\_{1}^{(i)} q\_{1}+v\_{2}^{(i)} q\_{2}+v\_{3}^{(i)} q\_{3}+\\ldots \\\\
&+v\_{3 N-2}^{(i)} q\_{3 N-2}+v\_{3 N-1}^{(i)} q\_{3 N-1}+v\_{3 N}^{(i)} q\_{3 N}
\\end{aligned}$$
