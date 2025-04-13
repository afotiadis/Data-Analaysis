%Alexandros Fotiadis AEM:10392
clear all;
%Defining the parameters
n=10;
B=1000;

%Creating the random variables and samples
X=normrnd(0,1,1,n);
Y=exp(X);

bootstrap_means_X=zeros(1,B);
bootstrap_means_Y=zeros(1,B);

for i=1:B %Bootsrapping
    bootstrap_sampleX=randsample(X,n,true);
    bootstrap_sampleY=exp(bootstrap_sampleX);
    bootstrap_means_X(i)=mean(bootstrap_sampleX);
    bootstrap_means_Y(i)=mean(bootstrap_sampleY);
end

%calculating the values "manually" for comparison
mean_X=mean(X);
std_X=std(X);
se_X=std_X/sqrt(n);

mean_Y=mean(Y);
std_Y=std(Y);
se_Y=std_Y/sqrt(n);

se_bootstrap_X=std(bootstrap_means_X);
se_bootstrap_Y=std(bootstrap_means_Y);

%creating the histograms
figure(1);

histogram(bootstrap_means_X,20);
hold on

plot([mean_X, mean_X],[0,100],'r','LineWidth',2);
plot([mean_X - se_bootstrap_X, mean_X - se_bootstrap_X], [0, 100], 'g', 'LineWidth', 2);

hold off

xlabel('Bootstrap Sample Means');
ylabel('Frequency');
title('Bootsrap Sampling Distribution');

legend('Bootstrap sample means', 'Original Sample mean');

figure(2);
histogram(bootstrap_means_Y, 20); 
title('Bootstrap Sampling Distribution for Y');
xlabel('Bootstrap Sample Means (Y)');
ylabel('Frequency');

hold on
plot([mean_Y, mean_Y],[0,100],'r','LineWidth',2);
hold off;

%displaying the manual results along with the histograms
fprintf('Original Sample X Mean: %f\n', mean_X);
fprintf('Original Sample X SE: %f\n', se_X);
fprintf('Bootstrap Sample X SE: %f\n', se_bootstrap_X);

fprintf('Original Sample Y Mean: %f\n', mean_Y);
fprintf('Original Sample Y SE: %f\n', se_Y);
fprintf('Bootstrap Sample Y SE: %f\n', se_bootstrap_Y);