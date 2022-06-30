# Ch5 Reconstruction from Two Views: Linear Algorithm



Reconstruct the 3D geometry based on the corresponding points

Make following assumptions:

- A set of corresponding points in 2 frames, taken with the same camera from different views are given
- the scene is static, none of observed 3D points moved during the camera motion
- The intrinsic camera (calibration)  parameters are known

First estimate the camera motion from the set of corresponding points



## 5.1 The Reconstruction Problem

The projection of a point **X** onto the 2 images are denoted by $x_1$ and $x_2$. The **optical center** of each camera are denoted by $o_1$ and $o_2$. The intersections of the line $(o_1, o_2)$ with each image plane are called **epipoles** $e_1$ and $e_2$. The intersections between the epipolar plane $(o_1, o_2, X)$ and the image planes are called epipolar lines $l_1$ and $l_2$



Given known camera parameters (K = 1) and no rotation or translation of the first camera, we merely have a projection with unknown depth $\lambda_1$ , From first frame to second frame we have a camera rotation $R$ and translation $T$  followed by a projection
$$
\lambda_1 x_1 = X \quad \quad \lambda_2x_2 = RX + T
$$

$$
\therefore \quad \lambda_2 x_2 = R \lambda_1x_1 + T \\
\lambda_2 \hat T x_2 = \hat T R \lambda_1x_1 \\
\lambda_2 x_2^T \hat T x_2 = \lambda_1 x_2^T \hat TRx_1 \\
x_2^T \hat T R x_1 =  0 \\
\Rightarrow \quad E = \hat T R
$$

The epipolar constraint provides a relation between the 2D point coordinates of 3D point in each of the 2 images and the camera transformation parameters



==Geometrically the constraint states that the three vectors $\vec{o_1X}$ , $\vec{o2X}$ and  $o_1 o_2$ form a plane, i.e the triple product of these vectors is zero, which measures the volume ==



## 5.2 The Epipolar Constraint

### 5.2.1 The properties of the essential matrix E

The space of all essential matrices is called **essential space**::
$$
\varepsilon = \left\{ \hat T R  | R \in SO(3), T \in \mathbb R ^3\right\}
$$
A nonzero matrix $E \in \mathbb R ^{3 \times 3}$ is an essential matrix iff E has a singular value decomposition $E = U \Sigma V^T$  with
$$
\Sigma = diag \left\{ \sigma, \sigma, 0 \right\}
$$
for some $\sigma > 0$ and $U ,V \in SO(3)$



There exists exactly 2 relative poses (R, T)  with $R \in SO(3)$ and $T \in \mathbb R^3$ corresponding to an essential matrix $E \in \varepsilon$ :
$$
(\hat T_1 , R_1) = (UR_Z(+\frac{\pi}{2})\Sigma U^T, UR_Z^T(+ \frac{\pi}{2})V^T) \\
(\hat T_2 , R_2) = (UR_Z(-\frac{\pi}{2})\Sigma U^T, UR_Z^T(- \frac{\pi}{2})V^T) \\
$$
where 
$$
R_Z(\theta) = \left(
 \begin{matrix}
   \cos \theta & -\sin \theta & 0 \\
   \sin \theta & \cos \theta & 0 \\
   0 & 0 & 1 
   \end{matrix} 
\right)
$$





in General only one of these gives meaningful (positive) depth value



## 5.3 Eight Point Algorithm

3D reconstruction  algorithm proceeds as follows:

1. Recover the essential matrix E from the epipolar constraints associated with a set of points pairs. In general, this is not an essential matrix, we can solve this problem in 2 ways:
   1. Project it onto the **Essential space** $\varepsilon$  (simpler and faster)
   2. Optimize the epipolar constraints in the essential space ( in principle more accurate, but involves in nonlinear constrained optimization) 
2. Extract the relative translation and rotation from the essential matrix E



8 Point Algorithm:

**Step1** Rewrite the epipolar constraint as:
$$
E^s = (e_{11}, e_{21}, e_{31}, e_{12}, e_{22}, e_{32}, e_{13}, e_{23}, e_{33}) ^T
$$


and **Kronecker product**:
$$
a = x_1 \otimes x_2 \\
 a = (x_1x_2, x_1y_2, x_1z_2, y_1x_2, y_1y_2, y_1z_2, z_1x_2, z_1y_2, z_1z_2)^T
$$

$$
\therefore x_2^TEx_1 = a^T E^s = 0
$$

for n point pairs, we can combine this into the linear system:
$$
\chi E^ s= 0 , \quad \quad \chi = (a_1, a_2..., a^n)^T 
$$


- We can see that the vector of coefficients of essential matrix E defines the null space of the matrix $\chi$.
- In order to have a unique solution of E, the rank of the matrix $\chi$ needs t0 be exactly 8. Therefore we need at least 8 point pairs



to solve this, one can do a SVD decomposition for $\chi$ , $E$ should equal to ninth column of right Singular vector $V_{\chi}$ of $\chi$ 

**Step2:** Project this essential matrix onto essential space, let $F \in \mathbb R^{3 \times 3}$ be an arbitrary matrix with SVD $F = U diag\left\{\lambda_1, \lambda_2, \lambda_3\right\}V^T$ , $\lambda_1 \ge \lambda_2 \ge \lambda_3$ . Then the essential matrix E which minimizes the Frobenius norm $||F - E||_f^2$ is given by
$$
E = U_F diag\left\{\sigma, \sigma, 0\right\} V_F^T, \quad \quad with \quad \sigma = \frac{\lambda_1 + \lambda_2}{2}
$$
Since in the reconstruction, E is only defined up to scalar, we project E onto normalized essential space by replacing the singular value $\sigma_1, \sigma_2, \sigma_3$ with 1, 1, 0



**Step3: ** Recover the displacement from the essential matrix. The 4 possible solutions for rotation and translation are: (without the limitation that $U_E, V_E \in SO(3)$)
$$
R = U R_Z^T(\plusmn \frac{\pi}{2})V^T \quad \quad \hat T = UR_Z(\plusmn \frac{\pi}{2})\Sigma U^T
$$
with a rotation by $\plusmn \frac{\pi}{2}$ around z. Among them only ==one meaningful one== which assigns positive depth to all points.



### 5.3.1 Why need 8 Points?

The space of essential matrices is actually a five-dimensional space, not 9 degree of freedom (R 3, T 3, and scalar invariance)

> https://note.youdao.com/ynoteshare/index.html?id=5e98f487c40ef22f90e1177f29271be5&type=note&_time=1656614933832



mindestens need 5 point pairs.

In the case of degenerate motion (for example planar motion), one can resolve the problem with even fewer point pairs.



### 5.3.2 Limitations of  8 points algorithm & Extension

1. Limitation

- The algorithm fails if translation is exactly 0. Since then E = 0. and nothing can be recovered.

2. Extension

- In the case of infitesimal view point change, one can adapt the 8 points algorithm to the **continuous motion case **, where the epipolar constraint is replaced by the continuous epipolar constraint. 

  $\Rightarrow$ In continuous motion case, rather than recovering (R, T), one recovers the linear and angular velocity of the camera.

- In the case of **independently moving objects**, one can generalize the epipolar constraint. For 2  motions e.g we can have:
  $$
  (x_2^TE_1 x_1)(x_2^TE_2x_1) = 0
  $$
  Given a sufficiently large number of point pairs, one can solve the respective equations for multiple essential matrices using polynomial factorization.



## 5.4  Structure Reconstruction

The linear 8 point Algorithm allowed us to estimate the camera transformation parameter R and T from a set of corresponding point pairs. Yet the essential matrix E and the translation vector T are only defined up to an arbitrary scale $\gamma \in \mathbb R^{+}$, with $||E|| = ||T|| = 1$.  After recovering R and T, we therefore have for point $X^j$:
$$
\lambda_2^j x_2^j = \lambda_1^jRx_1^j + \gamma T, \quad \quad j = 1, ...n \\
 \lambda_1^j\hat x_2^jRx_1^j + \gamma \hat x_2^jT = 0 \quad \quad j = 1, ...n \\
 \left(
 \begin{matrix}
   \hat x_2^jRx_1^j & \hat x_2^jT
   \end{matrix} 
\right)\left(
 \begin{matrix}
   \lambda_1^j \\ \gamma
   \end{matrix} 
\right) = 0 \quad \quad j = 1, ...n \\
M \vec{\lambda} = 0
$$
Where
$$
M =  \left(
 \begin{matrix}
    \hat x_2^1Rx_1^1 & 0 & 0 & 0 & 0 & \hat x_2^1T \\
   0 & \hat x_2^2Rx_1^2 & 0 & 0 & 0 & \hat x_2^2 T \\
   0 & 0 &  ... & 0 & 0 & ... \\
   0 & 0 & 0 & \hat x_2 ^{n-1}Rx_1^{n-1} & 0 & \hat x_2^{n-1} T\\
   0 & 0 & 0 & 0 & \hat x_2 ^{n}Rx_1^{n}  & \hat x_2^{n-1} T\\
   \end{matrix} 
\right)
$$
The linear least sqaures estimate for $\lambda$ is given by the eigenvector corresponding to smallest eigenvalue of $M^TM$

Or just the last culumn of singular vector of M.



-- > This depth only up to a global scene. When the camera is moved twice the distance, and the point is twice far away, image is in the same scale



## 5.5 Four Point Algorithm

The eightpoint algothm only provides unique solutions if all 3D points are in general position, when all points lie on certain 2D sufaces which are called **critical surfaces**, should use ==four point algorithm==



Plane $N^TX_1 =d$, where X is the point coordinate in first frame and N is plane normal

we can get
$$
H = R + \frac{1}{d}TN^T  \in \mathbb R^{3 \times 3}\\
x_2 \sim Hx_1
$$
Four point algorithm:

1. For the point pairs, compute the matrix $\chi$
2. compute the solution $H^s$ for the above equation by singular value decomposition $\chi$
3. Extract the motion parameters from the homography matrix $H = R + \frac{1}{d}TN^T$

Derivation of R and T based on H is complex. 3D reconstruction is similar
$$
E = \hat TH, \quad H ^TE + E^TH= 0
$$

## 5.6 The uncalibrated case

we should compute with the image coordinates $x'$
$$
x_2^T \hat TR x_1 = 0 \quad \quad \Rightarrow x'^T_2K^{-T}\hat T R  K^{-1}x'_1 = 0 \\
F = K^{-T}\hat T R  K^{-1}= K^{-T}EK ^{-1} \quad \quad x'^T_2Fx'_1 = 0 
$$
The invertable matrix K does not affect the rank of the matrix. F has a SVD form : $\Sigma = diag(\sigma_1, \sigma_2, 0)$

**Any matrix of rank 2 can be a fundamental matrix**

### 5.6.1 Limitations

1. One can not impose a strong constraint on the specific structure of fundamental matrix, apart from the face that last singular value is 0
2. Second, for a given fundamental F, there does not exist a finite number of decompositions into R T and K
3. One can only determine the **projective reconstructions ** only with F.
