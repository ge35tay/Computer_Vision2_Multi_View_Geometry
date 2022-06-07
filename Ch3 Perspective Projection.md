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
Assume here Z to be a constant $\lambda > 0$  

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





## 3. Spherical Perspective Projection

The perspective pinhole camera consider a planar image surface. Instead one can consider a ==spherical projection surface== given by a unit sphere $\mathbb S^2  = \left\{ x \in  \mathbb R^3 | |x| = 1 \right\}$. The **spherical projection** $\pi_s$ of a 3D point $X$ is given by:
$$
\pi_s : \mathbb R^3 \rightarrow \mathbb S^2; \quad X \rightarrow x = \frac{X}{|X|}
$$
<img src="Ch3%20Perspective%20Projection.assets/Spherical_Perspective_Projection.jpg" alt="img" style="zoom:25%;" />

不是1了分母



The pixel coordinates $x'$ as a function of the world coordinates $X_0$ are:
$$
\lambda x' = K \cap_0 g X_0
$$
except that the scalar factor is: $\lambda = |X| = \sqrt{X^2 + Y^2 + Z^2}$





## 4. Radial Distortion

The intrinsic parameters in the matrix $K$ model the linear distortion in the transformations to pixel coordinates.

But we should consider the ==distortion along radial axis==

- A simple effective model for such distortions is:

$$
x = x_d (1 + a_1 r^2 + a_2 r^4), \quad y = y_d (1 + a_1 r^2 + a_2 r^4), 
$$

where $x_d = (x_d, y_d)$ is the distorted point on camera coodinates (z = 1), $r^2 = x_d^2 + y_d^2$,

We can see that the further the point is, the more distorted it is.

> https://blog.csdn.net/weixin_39883260/article/details/110840864

- Alternatively, oen can estimate a distortion model directly from the images.

$$
x = c + f(r)(x_d - c), \quad with f(r) = 1 + a_1r + a_2 r^2 + a_3 r^3 + a_4 r^4
$$

Here $r = |x_d - c|$ is the distance to an arbitary center of distortion c and the distortion correction factor $f(r)$ is a 4-th order expression.



## 5. Preimages of Points and lines

Due to the unknown scale factor in the depth, each point in the real world is not mapped to a single point x in the image, but to an **equivalence class of points y ~ x**. 

A line $L$ in 3-D is characterized by a base point $X_0 = (X_0, Y_0, Z_0, 1)^T \in \mathbb R^4$ and a vector $V = (V_1, V_2, V_3, 0)^T \in \mathbb R^4$ .

The image of the line L on image plane(3D) is given by:
$$
x \~ \cap_0X = \cap_0 (X_0 + \mu V) = \cap_0X_0 + \mu\cap_0V
$$
All points x treated as vectors from origin o span a 2-D subspace P. The intersection of this plane P with the image plane gives the image of the line.



Def:  **A preimage of a point or  a line** in the image plane is the larget set of 3D points that give rise to an iamge equal to the given point or line.



In case of $\mathbb R^3$ , the preimage is a subspace of $\mathbb R^3$. This subspace can also be represented by its orthogonal complement, i.e the normal vector of plane **coimage**.

能投影到Image plane上形成一条线的有一整个平面，所以线的 preimage是一个面，而点的preiamge只有一根线，因为必须共线

![image](Ch3%20Perspective%20Projection.assets/Preimage_and_Coimage.jpg)





Summary:

4D world coordinates $\rightarrow_{g\in SE(3)}$ 4D camera coordinates $\rightarrow_{K_f \cap_0}$ 3D image coordinates $\rightarrow_{K_s}$ 3D pixel coordinates
