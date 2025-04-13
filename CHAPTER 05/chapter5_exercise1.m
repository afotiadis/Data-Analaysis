%Alexandros Fotiadis AEM:10392
clc;
clf;
clear;

%Defining Parameters
alpha=0.05;
M=1000;
n=20;
%n=200; if we want 200 observations we use this and comment out the n=20
%line
muX=0;
muY=0;
sigmaX=1;
sigmaY=1;
mu=[muX muY];
sigma=[sigmaX sigmaY];
r=0.5;
%r=0;if we want X,Y to be unrelated we use this and comment out r=0.5
cov_matrix=[sigma(1)^2 r*sigma(1)*sigma(2); r*sigma(1)*sigma(2) sigma(2)^2 ]; %Covariance matrix
X=zeros(n,M); %initiate empty arrays to store the data
Y=zeros(n,M);
for i=1:M
    data=mvnrnd(mu,cov_matrix,n); %produce data
    X(:,i)=data(:,1);
    Y(:,i)=data(:,2);
    %X=X.^2; 
    %Y=Y.^2; %use these lines to test the results for the ^2 
end

R=zeros(M,1);
%R_low=zeros(M,1);
%R_up=zeros(M,1);

for i=1:M
    R_temp=corrcoef(X(:,i),Y(:,i)); %calcultate R by simulation and store into R
    R(i)=R_temp(1,2);
end
Z = 0.5*log((1+R)./(1-R)); %Implementing the Fisher transformation
z=norminv(1-alpha/2);
zstd=sqrt(1/(n-3));
Z_low=Z-z*zstd;
Z_up=Z+z*zstd;
R_low=(exp(2*Z_low)-1)./(exp(2*Z_low)+1);
R_up=(exp(2*Z_up)-1)./(exp(2*Z_up)+1);

figure(1) %creating the Fisher histograms
histogram(R_low);
title("Histogram for lower bound");
figure(2)
histogram(R_up);
title("histogram for upper bound");

counter=0;
for i=1:M
    if R_low(i)<r && R_up(i)>r
        counter=counter+1;
    end
end

fprintf("The confidence interval contains r=%.2f with a percentage %.4f%%\n",r,counter*100/M); 

t = R .* sqrt((n-2) ./ (1-R.^2)); %t-statistic method
tc = tinv(1-alpha/2, n-2);
accept = sum(abs(t)<tc);
fprintf("h0 (r=0) rejection percentage: %.4f%%.\n", (M-accept)*100/M);