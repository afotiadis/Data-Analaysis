%Alexandros Fotiadis AEM:10392

clc; 
clf;
clear;
close all;

%Defining Parameters
n=1000; %Num of observations
mu=[0 0]; %Mean values array
sigma=[1 0; 0 4]; %Variance array
x=mvnrnd(mu',sigma,n); %Generating the sample
w=[0.2 0.8; 0.4 0.5; 0.7 0.3]; %Transformation array (R^2->R^3)
x3=x*w'; %Transforming the data to R^3
p=size(w,1);%for later use in PCA

figure(); %Scatter plot for the 2D generated sample
scatter(x(:,1),x(:,2),10,'blue');
xlabel('x1');
ylabel('x2');
title('2D Gaussian generated points');
figure(); %3D scatter plot for the transformed data
scatter3(x3(:,1),x3(:,2),x3(:,3),10,'blue');
xlabel('y1');
ylabel('y2');
zlabel('y3');
title('3D observed points');

y=x3-repmat(sum(x3)/n,n,1); %centering the transformed data
covx=cov(y);%finding the covariance matrix
[eigvec,eigval]=eig(covx);%calculating eigenvalues and eigenvectors of the covariance matrix
eigval=diag(eigval); %calculating the eigenvalues of the diagonal array
[eigval,ind]=sort(eigval,"descend"); %sorting eigenvalues
eigvec=eigvec(:,ind); %assigning eigenvectors

z3=(eigvec*y')'; %transforming the data into the new coordinate system


figure(); %scree plot
plot(1:p,eigval,'o-');
title("Scree plot");
xlabel("Index");
ylabel("Eigenvalue");

figure(); %scatter plot for the new data 3D
scatter3(z3(:,1),z3(:,2),z3(:,3),10,'blue');
xlabel('PC1');
ylabel('PC2');
zlabel('PC3');
title("Principal Component scores");

z2=(eigvec(1:2,:)*y')'; %scatter plot for the new data 2D
figure();
scatter(z2(:,1),z2(:,2),10,'blue');
xlabel('PC1');
ylabel('PC2');
title("Principal Component scores");