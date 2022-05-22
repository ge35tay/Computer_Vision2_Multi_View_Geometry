# Ch2. Representing a Moving Scene

## 1. 3D Space and Rigid Body Motion

Well-Posed Question: Unique solution. 

Ill-Posed Question: No solution or Multiple solutions. Clearly 3D Reconstruction is a ill-posed questions.

### 1.1 Three-dimensional Euclidean Space

The 3D Euclidean space $\mathbb E^3$ consists of all points $p \in \mathbb E^3$ characterized by coordinates:
$$
X \equiv (X_1, X_2, X_3)^T \in \mathbb R^3
$$
such that $\mathbb E^3$ can be identified  with $\mathbb R^3$, that means we talk about points and coordinations as same thing.

Vector things and free vector compressed

### 1.2 Cross Product and Skew-symmetric Matrices

One can represent a cross product with a skew-symmetric matrix
$$
\hat u = \left(
 \begin{matrix}
   0 & -u_3 & u_2 \\
   u_3 & 0 & -u_1 \\
   -u_2 & u_1 & 0 \\
  \end{matrix} 
\right) \in \mathbb R^{3 \times 3}
$$
the operator \hat defines an isomorphism between $\mathbb R^3$ and the space $so(3)$ of all $3 \times 3$  skew-symmetric matrices. its inverse is denoted by 

$\vee:so(3) \rightarrow \mathbb R^3$

### 1.3 Rigid body motion

A rigid body motion is a family of maps:\left(
 \begin{matrix}
   R^T  & -R^TT  \\
   0 & 1\\
  \end{matrix} 
\right)
$$
g_t : \mathbb R^3 \rightarrow \mathbb R^3; X \rightarrow g_t(X), t\in[0, T]
$$
which preserves the norm and cross product of any 2 vectors:

- $|g_t(v)| = |v|, \quad \forall v \in \mathbb R^3 $
- $g_t(u) \times g_t(v) = g_t(u \times v), \quad \forall u, v \in \mathbb R^3 $

since norm and scalar product are related by the polarization identity $<u,v> = \frac{1}{4}(|u+v|^2 - |u-v|^2)$， one can also state that the rigid body motion is the map that preserves inner product and cross product.

Also can derive that it is volume preserving：
$$
<g_t(u),g_t(v)\times g_t(w)> = <u, v\times w>, \quad \forall u, v, w \in \mathbb R^3
$$
 Now we can assume that **the motion can be specified the motion of a cartesian coordinate attached to the object, the translation can be regarded as the motion of origin, the rotation can be regarded as transformation of basis vector $e_i$**

Scalar and cross product of these vectors are preserved:
$$
r_i^Tr_j = g_t(e_i)^T g_t(e_j) = e_i^Te_j = \delta_{ij}, \quad \quad r_1 \times r_2 = r_3
$$
we can see that the rotation matrix is a orthogon\left(
 \begin{matrix}
   R^T  & -R^TT  \\
   0 & 1\\
  \end{matrix} 
\right)al matrix, and the det(R) = 1. 

### 1.4 Exponential Coordinates of Rotation

> https://www.bilibili.com/video/BV1a3411A7oT?spm_id_from=333.337.search-card.all.click

>https://github.com/artivis/manif/blob/devel/paper/Lie_theory_cheat_sheet.pdf

Since $R(t)R(t)^T = I, \forall t$, we have :
$$
\frac{d}{dt}(RR^T) = \dot RR^T + R \dot R^T = 0 \quad \Rightarrow \dot RR^T = - R \dot R^T = - (\dot RR^T)^T
$$


Thus $\dot RR^T$ is a ==skew-symmetric== matrix. Thus there exists a vector $ w \in \mathbb R ^3$ such that:
$$
\dot RR^T = \hat w(t) \rightarrow \dot R(t) = \hat wR(t)
$$
For a rotation R(t), if its $R（0) = I$ , then $\dot R(0) = \hat w(0)$, we can use first approximation (  $g(x) = g(0) +  x \dot g(0)$ ) to  do the approximation of rotation:
$$
R(dt) = R(0) + dR = I + \hat w(0)dt
$$


 <img src="Ch2.%20Representing%20a%20Moving%20Scene.assets/LieTan.jpeg" alt="img" style="zoom: 50%;" />



So we can see the effect of any infinitesimal rotation $R \in SO(3)$ can be approximated by an element from the space of skew-symmetric matrices, which represents tangent space of rotation vector. The rotation group $SO(3)$ is called a **Lie group**, the space $so(3)$ is called its **Lie algebra**. 

> \left(
>  \begin{matrix}
>    R^T  & -R^TT  \\
>    0 & 1\\
>   \end{matrix} 
> \right)Definition:  a Lie group is a smooth group that is also a group. such that the group operations multiplication and inversion are smooth maps.
>
> **the Lie Algebra $so(3)$ is the tangent space at the identity element of the rotation group $SO(3)$**

<img src="Ch2.%20Representing%20a%20Moving%20Scene.assets/Lie_Group_Visualization.png" style="zoom:50%;" /> 

manifold means that it can be infinitely deriviated on every polint,  non-smooth means that the derivative is broken in somewhere.

For a certain element there exists only one tangent space for it.

### 1.5 The Exponential Map

The differential equation system:
$$
\begin{align}
\dot R(t) = \hat wR(t)\\
R(0) = I
\end{align}
$$
has the solution （with taylor extention）：
$$
R(t) = e^{\hat wt}= \sum_{n=0}^{\infty}\frac{(\hat wt)^{n}}{n!} = I + \hat wt + \frac{(\hat wt)^2}{2!}+...
$$
we can imagine as: a rotation around the axis $w \in \mathbb R^3$ by a angle of $t$ , if ($||w||=1$)

The ==matrix exponential== defines a map from Lie algebra to Lie group.
$$
\exp : so(3) \rightarrow SO(3); \hat w \rightarrow e^{\hat w} 
$$

### 1.6 The logarithm of SO(3)

A mapping from Lie Group to Lie Algebra $\hat w = log(R)$.

If $R = (r_{ij}) \neq I$, then an appropriate is given by:
$$
|w| = \cos^{-1}(\frac{trace(R) - 1}{2}), \quad \frac{w}{|w|}= \frac{1}{2\sin(|w|)}\left(
 \begin{matrix}
   r_{32}-r_{23}  \\
   r_{13}-r_{31} \\
   r_{21}-r_{12}  \\
  \end{matrix} 
\right)
$$
If R = I, we have $|w|= 0$, i.e a rotation by an angle 0.

**Any orthogonal transformation $R \in SO(3)$can be realized by an angle $|w|$ around an axis $\frac{w}{|w|}$** 

We have an expression for skew symmetric matrices $\hat w \in so(3)$: **Rodrigues' formula**
$$
e^{\hat w} = I + \frac{\hat w}{|w|} \sin(|w|) + \frac{\hat w^2}{|w|^2}(1-\cos(|w|))
$$
<img src="Ch2.%20Representing%20a%20Moving%20Scene.assets/rod1.jpeg" alt="rod1" style="zoom: 25%;" />

<img src="Ch2.%20Representing%20a%20Moving%20Scene.assets/rod2.jpeg" alt="rod2" style="zoom:25%;" />

### 1.7 Representation of Rigid body motions SE(3)

$$
SE(3) = \left\{ g = (R, T) | R \in SO(3), T \in \mathbb R^3 \right\}
$$

in homogeneous coordinates we have:
$$
SE(3) = \left\{ g = \left(
 \begin{matrix}
   R & T  \\
   0 & 1\\
  \end{matrix} 
\right) | R \in SO(3), T \in \mathbb R^3 \right\} \subset \mathbb R^4
$$

### 1.8 Lie algebra of Lie Group SE(3)

for rigid body transformation:
$$
g: \mathbb R \rightarrow SE(3); \quad g(t) =  \left(
 \begin{matrix}
   R & T  \\
   0 & 1\\
  \end{matrix} 
\right)  \in \mathbb R^{4 \times 4}
$$
we can derive that;
$$
g^{-1} =  \left(
 \begin{matrix}
   R^T  & -R^TT  \\
   0 & 1\\
  \end{matrix} 
\right)
$$

$$
\dot g(t)g^{-1}(t) = \left(
 \begin{matrix}
   \dot RR^T  & \dot T-\dot RR^TT  \\
   0 & 0\\
  \end{matrix} 
\right)
$$

We can see that the matrix $\dot RR^T$ corresponds to some skew-symmetric matrix $\hat w \in so(3)$,

define a vector $v(t) = \dot T(t) - \hat w(t)T(t)$

we have:
$$
\dot g(t)g^{-1}(t)= \left(
 \begin{matrix}
   \hat w(t)  & v(t)  \\
   0 & 0\\
  \end{matrix} 
\right) = \hat \xi(t) \in \mathbb R^{4 \times 4}
$$
Multiplying with g(t) from the right we have:
$$
\dot g = \dot gg^{-1}g = \hat \xi g
$$
so the $4 \times 4$ matrix $\hat \xi$ can be viewed as a tangent vector along the curve $g(t)$, $\hat \xi$ is called a ==twist==

so the set of all twists forms the lie algebra of the Lie Group $SE(3)$
$$
\hat \xi = \left(
 \begin{matrix}
   v  \\
   w \\
  \end{matrix} 
\right) ^{\land} = \left(
 \begin{matrix}
   \hat w & v  \\
   0 & 0\\
  \end{matrix} 
\right), \quad \quad \left(
 \begin{matrix}
   \hat w & v  \\
   0 & 0\\
  \end{matrix} 
\right)^{\vee} =  \left(
 \begin{matrix}
   v  \\
   w \\
  \end{matrix} 
  \right) \in \mathbb R^6
$$
the twist coordinates $\xi = \left(
 \begin{matrix}
   v  \\
   w \\
  \end{matrix} 
  \right)$ are formed by stacking ==linear velocity v \in R3== (related to linear translation), and the ==angular velocity w \in R3== (related to rotation)



The diiferential equation system:
$$
\begin{align}
\dot g(t) = \hat \xi g(t), \hat \xi = const\\
g(0) = I
\end{align}
$$
has the solution:
$$
g(t) = e^{\hat \xi t} = \sum_{n=0}^{\infty} \frac{(\hat \xi t)^n}{n!}
$$
for w = 0 we have $e^{\hat \xi t}= \left(
 \begin{matrix}
   \hat I & v  \\
   0 & 1\\
  \end{matrix} 
\right)$,otherwise we have:
$$
e^{\hat \xi t}= \left(
 \begin{matrix}
   e^{\hat w}  & \frac{(I - e^{\hat w})\hat w v +ww^Tv}{|w|^2}  \\
   0 & 1\\
  \end{matrix} 
\right)
$$
