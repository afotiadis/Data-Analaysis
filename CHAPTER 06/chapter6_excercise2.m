%Alexandros Fotiadis AEM:10392
clc;
clf;
clear;
close all;

%Loading data
x=load("yeast.dat");
[n,p]=size(x); %assigning the dimensions of data into variables

figure();
plot(mean(x,2)); %plotting the mean value of the sample
xlabel('Variable index i');
ylabel('Sample mean of x_i');
title('Sample mean of yeast data');
figure(); %plotting std of the sample
plot(std(x'));
xlabel('Variable index i');
ylabel('Sample std of x_i');
title('Sample std of yeast data');

y=x-repmat(sum(x)/n,n,1); %centering
covx=cov(y); %covariance matrix
[eigvec,eigval]=eig(covx); %eigenvectors and eigenvalues
eigval=diag(eigval); %diagonal array eigenvalues
[eigval,ind]=sort(eigval,'descend');
eigvec=eigvec(:,ind);

z=y*eigvec; %new transformed data

figure(); %scree plot
plot(1:p,eigval,'o-');
title('Scree plot');
xlabel('Index');
ylabel('Eigenvalue');
title('Scree Plot');


td=100*cumsum(eigval)/sum(eigval); %finding the variance percentage
figure();
plot(1:p,td,'o-');
xlabel('Index');
ylabel('Variance Percentage');
title('Explained Variance Percentage');

%reducing the dimensions
avgeig=mean(eigval);
ind=find(eigval>avgeig);
fprintf("Dimension d using size of the variance: %d\n",length(ind));

z3=y*eigvec(:,1:3); %PCA 3D
figure();
scatter3(z3(:,1),z3(:,2),z3(:,3),10,'blue');
xlabel('PC1');
ylabel('PC2');
zlabel('PC3');
title('Principal component scores in 3D');

z2=y*eigvec(:,1:2); %PCA 2D
figure();
scatter(z2(:,1),z2(:,2),10,'blue');
xlabel('PC1');
ylabel('PC2');
title('Principal component scores in 2D');