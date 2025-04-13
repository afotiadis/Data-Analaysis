%Alexandros Fotiadis AEM:10392
clc;
clear;
clf;
%Defining Parameters
M = 100;
n = 10;
m = 12;
mX = 0;
mY = mX;
varX = 1;
varY = 2;
alpha = 0.05;
numBootstraps = 1000;

%Creating X and Y
X = normrnd(mX,sqrt(varX),n,M);
Y = normrnd(mY,sqrt(varY),m,M);
Z = [X;Y];
muX = mean(X);
muY = mean(Y);
muZ = mean(Z); 
x_tilde= X - muX + muZ;
y_tilde = Y - muY + muZ;
z_tilde = [x_tilde;y_tilde]; %Combining the X and Y data 


%Bootstrap method
bootstrap_differences = zeros(numBootstraps,M);
bootstrap_X = zeros(n,M);
bootstrap_Y = zeros(m,M);

for i=1:numBootstraps
    bootstrap_samples = zeros(n+m,M);
    bootstrap_index = randi(n+m,n+m,M);
    for j=1:M
        bootstrap_samples(:,j) = z_tilde(bootstrap_index(:,j));
        bootstrap_X(:,j) = bootstrap_samples(1:n,j);
        bootstrap_Y(:,j) = bootstrap_samples(n+1:n+m,j);
    end
    bootstrap_differences(i,:) = mean(bootstrap_X) - mean(bootstrap_Y);

end


bootstrap_differences(numBootstraps+1,:) = muX - muY;
bootstrap_differences = sort(bootstrap_differences);

h_bootstrap = zeros(1,M);

for i=1:M
    r = find(bootstrap_differences(:,i) == muX(i) - muY(i));
    if (r < (numBootstraps+1)*alpha/2) || r > ((numBootstraps+1)*(1-alpha/2))
        h_bootstrap(i) = 1;
    end

end
failure_percentage_bootstrap = sum(h_bootstrap)*100/M;
fprintf("-----Bootstrap-----\n");
fprintf("Percentage of rejections for alpha = %.3f is : %1.2f%%\n",alpha,failure_percentage_bootstrap);

%Parametric method 
h_param = ttest2(X,Y,'Vartype','unequal');
failure_percentage_param = sum(h_param)*100/M;
fprintf("-----Parametric-----\n");
fprintf("Percentage of rejections for alpha = %.3f is : %1.2f%%\n",alpha,failure_percentage_param);


