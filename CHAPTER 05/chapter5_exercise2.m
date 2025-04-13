%Alexandros Fotiadis AEM:10392
clc;
clf;
clear;

%Defining Parameters
alpha=0.05;
M=1000;
n=20;
L=1000;

muX=0;
muY=0;
sigmaX=1;
sigmaY=1;
%r=0.5; %to use this comment oute the next line
r=0;
mu=[muX muY];
sigma=[sigmaX sigmaY];
cov_matrix=[sigma(1)^2 r*sigma(1)*sigma(2); r*sigma(2)*sigma(1) sigma(2)^2]; %covariance matrix
X=zeros(n,M);
Y=zeros(n,M);
R=zeros(L+1,M);

for i=1:M 
    temp_data=mvnrnd(mu,cov_matrix,n); %creating and storing the data
    X(:,i)=temp_data(:,1);
    Y(:,i)=temp_data(:,2);
    %X=X.^2; %comment out to calculate the results for ^2 transformation
    %Y=Y.^2;
    temp_R=corrcoef(X(:,i),Y(:,i)); %calculating and storing correlation coefficient
    R(1,i)=temp_R(1,2);

    for j=1:L
        temp_R=corrcoef(X(:,i),Y(randperm(n),i)); %same here, but with the use of random permutation
        R(j+1,i)=temp_R(1,2);
    end
end

t=R.*sqrt((n-2)./(1-R.^2)); %non parametric method
t_sort=sort(t(2:L+1,:),1);

lower_bound=round((alpha/2)*L); 
upper_bound=round((1-alpha/2)*L);
t_low=t_sort(lower_bound,:);
t_up=t_sort(upper_bound,:);
rej=sum(t(1,:)-t_low<0 | t(1,:)-t_up>0);
reject_prc=rej/M;
fprintf("Rejection Percentage of the null hypothesis: %.4f%%\n",reject_prc*100);

tc=tinv(1-alpha/2, n-2); %use of the t-statistic method
accept=sum(abs(t(1,:))<tc);
fprintf("Rejection Percentage of the null hypothesis: %.4f%%\n",(M-accept)*100/M);