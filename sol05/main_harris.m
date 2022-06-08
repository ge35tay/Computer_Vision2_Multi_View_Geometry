%% cleanup
clear
close all

%% load data and set parameters
I = imreadbw('img1.png');
%I = imreadbw('small.png');
sigma = 2;
kappa = 0.05;
theta = 1e-7;

%% compute corners and visualize 

[score, points] = getHarrisCorners(I, sigma, kappa, theta);

figure();
subplot(121);
drawPts(I, points);
axis image;

subplot(122);
imagesc(sign(score) .* abs(score).^(1/4));
colormap(gca, 'jet');
axis image;
colorbar;

%% Visualize effect of changing sigma
[scoreBy2, pointsBy2] = getHarrisCorners(I, sigma/2, kappa, theta);
[scoreTimes2, pointsTimes2] = getHarrisCorners(I, sigma*2, kappa, theta);

figure();
subplot(221);
drawPts(I, points);
axis image;
title('Original Sigma')

subplot(222);
drawPts(I, pointsBy2);
axis image;
title('Sigma / 2')

subplot(223);
drawPts(I, pointsTimes2);
axis image;
title('Sigma * 2')

