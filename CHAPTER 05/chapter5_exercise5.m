%Alexandros Fotiadis AEM:10392
clc;
clf;
clear;

%loading data and defining parameters
data=load("lightair.dat");
X=data(:,1);
Y=data(:,2);
n=length(X);
alpha=0.05;
M=1000;

%calculating the regression and c.i. for regression
[b,bint]=regress(Y,[ones(n,1) X]);

b_boot=zeros(M,2); %empty array to store the bootstrap samples
for i=1:M
    index=unidrnd(n,n,1);
    Xb=X(index);
    Yb=Y(index);
    b_boot(i,:)=regress(Yb,[ones(n,1) Xb]); %creating random numbers from 1 to n, making a bootstrap sample and calculating regression for it
end

lower_bound=(M*alpha/2); %calculating approximately the 2.5 and 97.5 values
upper_bound=(M*(1-alpha/2));

b_boot_sorted=sort(b_boot); %sorting the bootstrap sample
bci=[b_boot_sorted(lower_bound,1) b_boot_sorted(upper_bound,1);
    b_boot_sorted(lower_bound,2) b_boot_sorted(upper_bound,2)]; %matrix that contains bootstrap the bound values of the c.i. for b0 and b1

%displaying the results
fprintf("Linear model: intercept b0=%.3f, slope b1=%.3f\n",b(1),b(2));
fprintf("Parametric c.i. for b0: [%.3f %.3f]\n",bint(1,1),bint(1,2));
fprintf("Bootstrap c.i. for b0: [%.3f %.3f]\n",bci(1,1),bci(1,2));
fprintf("Parametric c.i. for b1: [%.3f %.3f]\n",bint(2,1),bint(2,2));
fprintf("Bootstrap c.i. for b1: [%.3f %.3f]\n",bci(2,1),bci(2,2));