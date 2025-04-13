%Alexandros Fotiadis AEM:10392

clear;
clc;
clf;

%Defining Parameters
M = 100;
n = 10;
m = 12;
m0 = 0;
sigma0 = 1;
alpha = [0.01 0.05 0.1];
numBootstraps = 1000; 

%Creating X and Y
X = normrnd(m0,sigma0,n,M);
Y = normrnd(m0,sigma0,m,M);

muX = mean(X);
muY = mean(Y);

%Parametric method
failure_param = zeros(1,3);
h_param = zeros(3,M);
for i=1:length(alpha)
    h_param(i,:) = ttest2(X,Y,"Alpha",alpha(i));
    failure_param(i) = sum(h_param(i,:))*100/M;
    fprintf("-----Parametric-----\n");
    fprintf("The percentage of rejections of H0: meanX = meanY " + ...
     "at %.2f significance level is %1.2f%%\n",alpha(i),failure_param(i));
end

%Creating bootstrap samples (repetition allowed) 
Z = [X;Y];
bootstrap_differences = zeros(numBootstraps+1,M);
bootstrap_X = zeros(n,M);
bootstrap_Y = zeros(m,M);


for i=1:numBootstraps
    boot_index = randi(n+m,n+m,M);
    bootZ = zeros(n+m,M); %combined X and Y data
   for j=1:M
       bootZ(:,j) = Z(boot_index(:,j));
       bootstrap_X(:,j) = bootZ(1:n,j);
       bootstrap_Y(:,j) = bootZ(n+1:n+m,j);
   end
bootstrap_differences(i,:) = mean(bootstrap_X) - mean(bootstrap_Y);
end

bootstrap_differences(numBootstraps+1,:) = muX - muY;
bootstrap_differences = sort(bootstrap_differences);

%Bootstrap method
failure_bootstrap = zeros(1,3);
h_boot = zeros(3,M); 
for k=1:length(alpha)
    fprintf("-----Bootstrap-----\n");
for i=1:M
    r = find(bootstrap_differences(:,i) == muX(i) - muY(i));
    if r < (numBootstraps+1)*alpha(k)/2 || r > (numBootstraps+1)*(1-alpha(k)/2)
            h_boot(k,i) = 1;
    end
end
    failure_bootstrap(k) = sum(h_boot(k,:))*100/M;
    fprintf("The percentage of rejections of H0: meanX = meanY " + ...
     "at %.2f significance level is %1.2f%%\n",alpha(k),failure_bootstrap(k));
end   

%Random Permutation method

rand_boot_meanDiff = zeros(numBootstraps,M);
rand_bootX = zeros(n,M);
rand_bootY = zeros(m,M);

rand_boot_index = zeros(n+m,M);
for i=1:numBootstraps
    
    rand_bootZ = zeros(n+m,M);
for j=1:M
       rand_boot_index(:,j) = randperm(n+m,n+m);
       rand_bootZ(:,j) = Z(rand_boot_index(:,j));
       rand_bootX(:,j) = rand_bootZ(1:n,j);
       rand_bootY(:,j) = rand_bootZ(n+1:n+m,j);
end
rand_boot_meanDiff(i,:) = mean(rand_bootX) - mean(rand_bootY);
end

rand_boot_meanDiff(numBootstraps+1,:) = muX - muY;
rand_boot_meanDiff = sort(rand_boot_meanDiff);

failure_rand_permutation = zeros(1,3);
h_rand_perm = zeros(3,M); 
for k=1:length(alpha)
    fprintf("-----Random Permutation-----\n");
for i=1:M
    r = find(rand_boot_meanDiff(:,i) == muX(i) - muY(i));
    if r < (numBootstraps+1)*alpha(k)/2 || r > (numBootstraps+1)*(1-alpha(k)/2)
            h_rand_perm(k,i) = 1;
    end
end
    failure_rand_permutation(k) = sum(h_rand_perm(k,:))*100/M;
    fprintf("The percentage of rejections of H0: meanX = meanY " + ...
     "at %.2f significance level is %1.2f%%\n",alpha(k),failure_rand_permutation(k));
end   
