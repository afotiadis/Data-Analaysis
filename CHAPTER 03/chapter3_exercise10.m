%Alexandros Fotiadis AEM:10392
clc;
clf;
clear;

%Defining Parameters
M=100;
n=10;
muX=0;
sigmaX=1;
m0=0;
m1=0.5;
alpha = [0.01 0.05 0.1];
numBootstraps=1000;

X=normrnd(muX,sigmaX,n,M);
mu=mean(X);

%Input function creating "shortcut"
transform_code = input("Press 1 to transform, else 0:\n");
if transform_code == 1
    X = X.^2;
    m0 = 1;
    m1 = 2;
end

%Parametric method for 3 values of significance level
h_val1=zeros(3,M);
h_val2=zeros(3,M);
p_val1=zeros(1,M);
p_val2=zeros(1,M);
failure_percentage_param1=zeros(1,3);
failure_percentage_param2=zeros(1,3);

for i=1:length(alpha)

    for j=1:M
    [h_val1(i,j),p_val1(1,j)] = ttest(X(:,j),m0,"Alpha",alpha(i));
    [h_val2(i,j),p_val2(1,j)] = ttest(X(:,j),m1,"Alpha",alpha(i));
    end

    failure_percentage_param1(i) = sum(h_val1(i,:))*100/M;
    failure_percentage_param2(i) = sum(h_val2(i,:))*100/M;
    fprintf("Parametric Method: Percentage of rejection for H0: mean(X) = 0 at %.2f%% significance level: %1.3f%%\n",alpha(i),failure_percentage_param1(i));
    fprintf("Parametric Method: Percentage of rejection for H0: mean(X) = 0.5 at %.2f%% significance level: %1.3f%%\n",alpha(i),failure_percentage_param2(i));
end

%Proccess to apply the percentile bootstrap method
x_tilde1 = X - muX + m0;
x_tilde2= X - muX + m1;
boot_mean1 = bootstrp(numBootstraps,@mean,x_tilde1);
boot_mean2 = bootstrp(numBootstraps,@mean,x_tilde2);

lower_bound = floor((numBootstraps + 1)*alpha/2);
upper_bound = numBootstraps + 1 - lower_bound;
ci_boot1 = zeros(6,M);
h_boot1 = zeros(3,M);
failure_percentage_boot1 = zeros(1,3); 
ci_boot2 = zeros(6,M);%for Bootstrap 
h_boot2 = zeros(3,M);
failure_percentage_boot2 = zeros(1,3);

for i=1:length(alpha)    
for j=1:M
    ci_boot1(2*i-1,j) = prctile(boot_mean1(:,j),lower_bound(i)*100/numBootstraps);
    ci_boot1(2*i,j) = prctile(boot_mean1(:,j),upper_bound(i)*100/numBootstraps);
    h_boot1(i,j) = (mu(j) < ci_boot1(2*i-1,j) || mu(j) > ci_boot1(2*i,j));
    ci_boot2(2*i-1,j) = prctile(boot_mean2(:,j),lower_bound(i)*100/numBootstraps);
    ci_boot2(2*i,j) = prctile(boot_mean2(:,j),upper_bound(i)*100/numBootstraps);
    h_boot2(i,j) = (mu(j) < ci_boot2(2*i-1,j) || mu(j) > ci_boot2(2*i,j));
end
failure_percentage_boot1(i) = sum(h_boot1(i,:))*100/M;
failure_percentage_boot2(i) = sum(h_boot2(i,:))*100/M;

fprintf("Using Bootstrap Method: Percentage of rejection for H0: mean(X) = 0 at %.2f%% significance level: %1.3f%%\n",alpha(i),failure_percentage_boot1(i));
fprintf("Using Bootstrap Method: Percentage of rejection for H0: mean(X) = 0.5 at %.2f%% significance level: %1.3f%%\n",alpha(i),failure_percentage_boot2(i));

end
