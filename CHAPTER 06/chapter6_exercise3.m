%Alexandros Fotiadis AEM:10392

clc;
clear;
close all;

physical_data=load('physical.txt'); %Loading data
x=physical_data;
[n,p]=size(x); %Indices with the dimensions of data

y=x-repmat(sum(x)/n,n,1); %centered sample
covx=cov(y); %covariance matrix of the centered sample
[eigvec,eigval]=eig(covx); %calculating eigenvectors and eigenvalues and sorting them
eigval=diag(eigval);
[eigval,ind]=sort(eigval,'descend');
eigvec=eigvec(:,ind);
z=y*eigvec; %transforming the data into the new coordinate system

figure(); %Scree plot to determine which eigenvalues we will use in the new model
plot(1:p,eigval,'o-'); 
yline(mean(eigval));
title('Scree Plot');
xlabel('Index');
ylabel('Eigenvalue');

td=100*cumsum(eigval)/sum(eigval); %calculating the Td to determine the new dimension
figure();
plot(1:p,td,'o-');
xlabel('Index');
ylabel('Variance Percentage');
title('Explained variance percentage');

%calculating the new dimension d<p
avgeigval=mean(eigval);
i=sum(eigval>avgeigval);
fprintf('Dimension d using the size of the variance: %d\n',i);

%PCA method in 3 dimensions
z3=y*eigvec(:,1:3);
figure();
scatter3(z3(:,1),z3(:,2),z3(:,3),10,'blue');
xlabel('PC1');
ylabel('PC2');
zlabel('PC3');
title('PC scores in 3d');

%PCA method in 2 dimensions
z2=y*eigvec(:,1:2);
figure();
scatter(z2(:,1),z2(:,2),10,'blue');
xlabel('PC1');
ylabel('PC2');
title('PC Scores in 2d')