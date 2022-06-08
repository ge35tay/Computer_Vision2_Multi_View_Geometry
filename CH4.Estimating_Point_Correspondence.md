# CH4. Estimating Point Correspondence

In this course, we first assume the camera is in small movement, so that we can search almost all correspondent points (almost of them will show up in another frame), then we care about the large baseline movement

## 1. From Photometry to Geometry

In practice we do not actually observe points or lines, but rather brightness or color values at individual pixels. In order to transform this photometric information int geometric representation of the scene, one can **identify points with characteristic image features** and try to associate these points with corresponding points in the other frames. This matching allows us to infer 3D structure.



Surely this matching  is at the cost of throwing away a large amount of potentially useful information, which is a suboptimal question, but considering the computational cost and real-time tracking, it is worthful.



### 1.1 identify corresponding points

In most of case, the brightness of a certain area /  a object looks different from different angles (**Unless this surface is lambertian surface**). So brightness is not a good enough criteria for correspondence.

In general, objects may also deform non-rigidly, and there may be partial occlusions. ==> we assume that objects move rigidly.



### 1.2 Small deformation vs. Wide baseline

In point matching we distinguish 2 cases:

- ==Small deformation==, The deformation from one frame to the other is assumed to be infinitesimally small, in this case the displacement from one frame to the other can be estimated by classical **optic flow estimation**. For example, using Lucas/Kanade or Horn/Schunck method. This method allow to model **dense deformation fields** (giving a displacement for every pixel in the image).
- ==Wide baseline stereo==, The displacement is large, a dense matching of all points to all is in general computationally infeasible. Therefore typically selects a small number of feature points in each of images and to find appropriate pairing of points.



## 2. Small Deformation

The transformation of all points of rigidly moving object is given by:
$$
x_2 = h(x_1)  = \frac{1}{\lambda_2(x)}(R \lambda_1(X)x_1 + T)
$$
Locally the motion can be approximated in several ways:

- transform model : $h(x) = x + b$
- affine model $h(x) = Ax + b$



The 2D affine model can also be written as: $h(x) = x + u(x)$

with
$$
u(x)  = S(x)p = \left(
 \begin{matrix}
   x & y & 1 & 0 & 0 & 0  \\
   0 & 0 & 0 & x & y & 1  
  \end{matrix} 
\right)(p_1, p_2, p_3, p_4, p_5, p_6)^T
$$


### 2.1 Optical flow Estimation

The ==optical flow== refers to the apparent 2D motion field (image plane) observable between consecutive images of a video, can be understood as pixel motion on the image plane. (no ratation)

In extreme case of motion along the camera axis, there is no optical flow. On the other hand the camera rotation generates an optic flow even for entirely static scenes.

There are mainly two optic flow estimation methods :

- Lucas & Kanade method for sparse flow vectors under the assumption of **constant motion in a local neighborhood**
- Horn-Schunck method generates a dense flow field under the assumption of **spatially smooth motion**

## 3. The Lucas-Kanade Method

- **Brightness Constancy Assumption**： let x(t) denote a moving point at time t, and $I(x,t)$ a video sequence, then：
  $$
  I(x(t), t) = const, \forall t
  $$
  i.e. the brightness of point x(t) is constant. Therefore the total time derivative must be 0:
  $$
  \frac{d}{dt}I(x(t),t) = \nabla I ^T (\frac{dx}{dt}) + \frac{\partial I}{\partial t} = 0
  $$
  

 		which is often called the differential **optical flow constraint**, the desired local flow vector (velocity) is given by $v = \frac{dx}{dt}$

- **Constrain motion in a neighborhood** , since the optical flow constraint can not be solved for v, one assumes that v is constant over a neighborhood $W(x)$ of the point x:
  $$
  \nabla I(x', t)^T v + \frac{\partial I}{\partial t}(x', t) = 0, \quad \forall x' \in W(x)
  $$
  

 These two assumptions are all very ideal. So lukas and kanade compute the best velocity vector $v$ for the point $x$ by minimizing the ==least squares error== 
$$
E(v) = \int_{W(x)} |\nabla I(x', t)^T v + I_t(x', t)|^2dx'
$$
Expanding the terms and setting the derivative to zero one obtains:
$$
\frac{dE}{dv} = 2Mv + 2q = 0
$$
with 
$$
M = \int_{W(x)} \nabla I \nabla I ^T dx', and  \quad q = \int_{W(x)} I_t \nabla I dx'
$$
if M is invertible, i.e. $det(M) \neq 0$ , then the solution is $v = -M^{-1}q$.

But, for example if $\nabla I = 0$ , then M = 0, q = 0 ,everything is 0.

for example:

- Translational motion:

$$
E(b) = \int_{W(x)} |\nabla I^Tb + I_t|^2 dx' \rightarrow min
$$

$$
\frac{dE}{db} = 0 \Rightarrow b =...
$$

- Affine motion

$$
E(p) = \int_{W(x)} |\nabla I^TS(x')p + I_t|^2 dx' \\
\\
\frac{dE}{dp} = 0 \Rightarrow p = ...
$$

### 3.1 When can Small Motion be Estimated

In the formalism of LK method, one can not always estimate a translational motion. This problem is referred to as the **aperture problem**. 

This arises for example, if the region in the window W(x) around the point x has entirely constant intensity, then M =0.



In order for the solution of b to be unique the ==Structure tensor== $M(x) = \int_{W(x)} \left(
 \begin{matrix}
   I_x^2 & I_x I_y \\
   I_xI_y & I_y^2  
  \end{matrix} 
\right) dx'$    has to be invertible. which means

$det M \neq 0$

If the structure tensor is not invertible but not zero, then one can estimate the ==normal motion== , for example, I_x = 0, only the gradient in the y direction, so the motion is just in the direction of the image gradient



### 3.2 A simple Feature tracking Algorithm

For those points with $det(M(x)) \neq 0$ ,we can computer motion vector $b(x)$, we can do the simple feature tracker:



- Fot a given time instance t, compute at each point $x \in \Omega$ the structure tensor:
  $$
  M(x) = \int_{W(x)} \left(
   \begin{matrix}
     I_x^2 & I_x I_y \\
     I_xI_y & I_y^2  
    \end{matrix} 
  \right) dx'
  $$

- Mark all points $x \in \Omega$ for which the determinant of M is larger than a threshold $\theta > 0$
  $$
  det M(x)  \ge \theta
  $$

- For all these points the local velocity is given by:
  $$
  b(x, t) = -M(x)^{-1} \left(
   \begin{matrix}
      \int I_xI_tdx'\\
      \int I_yI_tdx'
    \end{matrix} 
  \right)
  $$
  

Repeat above steps for all points

### 3.3 Robust Feature Point Extraction

The inverse of M(x) may not be very stable if, for example the determinant of M is very small.



So improve the structure tensor:
$$
M = G * \nabla I\nabla I^T = \int G_{\sigma}(x - x') \left(
 \begin{matrix}
   I_x^2 & I_x I_y \\
   I_xI_y & I_y^2  
  \end{matrix} 
\right) (x')dx'
$$
In addition a summation weight by a Gaussian G of width $\sigma$ is performed

Harris propose that:
$$
C(x) =  det(M) - k *trace^2(M)
$$
and select points for which $C(x)  > \theta$ 



## 4. Wide Baseline Matching

In the case of wide baseline matching, large part of the image plane will not match at all because they are not visible in the other image.



### 4.1 Extensions to Larger Baseline

One of the limitation of tracking is **drift**, which means the small errors in the motion accumulate over  time and the windows gradually moves away from the point that was originally tracked.

Two important aspects matter:

- Since the motion of the window between frames is in general not longer only translational, one needs to generalize the motion model for the window W(x), for example by an affine motion model
- Since the illumination will change over time, one can replace the sum-of-squared difference by the ==normalized cross correlation== which is more robust to illumination changes.

Use normalized cross correlation to find the rotation and translation, which maximize the NCC

NCC is defined as:
$$
NCC(H) = \frac{\int_{W(x)}(I_1(x') - \bar I_1)(I_2(h(x')) - \bar I_2)dx'}{\sqrt{\int_{W(x)}(I_1(x') - \bar I_1)²dx'\int_{W(x)}(I_2(h(x')) - \bar I_2)dx'}}
$$

- where $\bar I_1$ and $\bar I_2$ are the average intensity over the window W(x), by subtracting the average intensity, the measure becomes **invariant to additive intensity changes **, independent of illumination conditions

- Dividing by the intensity variance of each window makes the measure invariant to multiplicative changes

These make the estimation more robust

If we stack the normalized intensity values of respective windows into one vector $v_i = vec(I_i - \bar I_i)$, then the ncc becomes the cosine of the angle between them:
$$
NCC(h) = \frac{<v_1, v_2>}{|v_1|v_2|} = cos \angle(v_1, v_2)
$$




Special case:

h(x) = Ax +d , use NCC to estimate the A and d which maximize the NCC
