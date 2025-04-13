%Alexandros Fotiadis AEM:10392
clear all;
% Set parameters
lambda=1/15; %mean lifespan

n=5; %sample size
M=1000; %samples
lifespans=exprnd(1/lambda,n,M); %generating random observations from exponential distribution


alpha=0.05; %level of significance

[h,p,c]=ttest(lifespans,1/lambda,'Alpha',alpha); %calculating confidence interval and hypothesis check

fprintf('Confidence Interval: (%f,%f)\n',c);

if h==0
    fprintf('%f belongs to the confidence interval\n',1/lambda);
else
    fprintf('%f does not belong to the confidence interval\n',1/lambda);
end
fprintf('p-value from t-test: %f\n', p); %printing the p-value of the test