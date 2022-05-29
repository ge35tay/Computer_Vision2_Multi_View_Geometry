# Ch3 Perspective Projection

## 1. Mathematical Representation

The point P observed through a thin lens ( on camera frames) has coordinates $X = (X, Y, Z) \in \mathbb R^3$ relative to the reference frame centered at the optical axis, where z-axis is the optical axis.



The simplify consider the image plane to be in front of the center of projection. The perspective transformation $\pi$ is given by:
$$
\pi : \mathbb R^3 \rightarrow \mathbb R^2; X \rightarrow x = \pi(X) = \left(
 \begin{matrix}
   f \frac{X}{Z}  \\
   f \frac{Y}{Z}  \\

  \end{matrix} 
\right)
$$
In homogeneous coordinates (Z = 1), the perspective transformation is given by:
$$
Zx = Z \left(
 \begin{matrix}
   x  \\
   y  \\
	1
  \end{matrix} 
\right) = \left(
 \begin{matrix}
   f & 0 & 0 & 0  \\
   0 & f & 0 & 0  \\
   0 & 0 & 1 & 0
  \end{matrix} 
\right)\left(
 \begin{matrix}
   X  \\
   Y  \\
   Z \\
   1

  \end{matrix} 
\right) = K_f \cap_0 X
$$
where **K_f**, $\cap_0$ **standard projection matrix**
$$
K_f = \left(
 \begin{matrix}
   f & 0 & 0  \\
   0 & f & 0   \\
   0 & 0 & 1 
  \end{matrix} 
\right) \quad \quad \cap_0 = \left(
 \begin{matrix}
   1 & 0 & 0 & 0  \\
   0 & 1 & 0 & 0  \\
   0 & 0 & 1 & 0
  \end{matrix} 
\right)
$$

## 2. Intrinsic Camera Parameters

- If the camera is not centered at optical center, we have an additional translation $o_x, o_y$
- and if pixel coordinates do not have unit scale, we need to add the pixel scale $s_x, s_y$ 

- if the pixels are not rectangular, we have a skew factor $s_{\theta}$

In real camera, the pixel coordinates $(x', y', 1)$ (**in pixel unit**) is given by:
$$
\lambda \left(
 \begin{matrix}
   x'  \\
   y'  \\
	1
  \end{matrix} 
\right) = \left(
 \begin{matrix}
   s_x & s_{\theta} & o_x  \\
   0 & s_y & o_y   \\
   0 & 0 & 1 
  \end{matrix} 
\right) \left(
 \begin{matrix}
   f & 0 & 0  \\
   0 & f & 0   \\
   0 & 0 & 1 
  \end{matrix} 
\right)  \left(
 \begin{matrix}
   1 & 0 & 0 & 0  \\
   0 & 1 & 0 & 0  \\
   0 & 0 & 1 & 0
  \end{matrix} 
\right) \left(
 \begin{matrix}
   X  \\
   Y  \\
   Z \\
   1

  \end{matrix} 
\right)
$$
$K_s, K_f, \cap_0$

The ==instrinsic parameter is given by== 
$$
K  =K_s K_f = \left(
 \begin{matrix}
   fs_x & fs_{\theta} & o_x  \\
   0 & fs_y & o_y   \\
   0 & 0 & 1 
  \end{matrix} 
\right) 
$$
where:

- $o_x$: x-coordinates of principal point in pixels
- $o_y$: y-coordinates of principal point in pixels

- $fs_x = \alpha_x$ size of unit length in horizontal pixels
- $fs_y = \alpha_y$ size of unit length in vertical pixels

- $\alpha_x / \alpha_y$ aspect ration $\sigma$

- $fs_{\theta}$ skew of the pixel, often close to zero.





**General projection matrix**
$$
\lambda x' = K \cap_0 X = K \cap_0 gX_0 = \cap X_0 
$$
where $\cap = K\cap_0 g = (KR, KT)$ is called a general projection matrix.
