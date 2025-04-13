%Alexandros Fotiadis AEM:10392
clc;
clf;
clear;

%4.1a bias and random uncertainty for 5 experiments
%Defining Parameters
h1=100;
h2=[60,54,58,60,56];
e=sqrt(h2/h1);

mean_e=mean(e);
std_e=std(e);

bias=abs(mean_e-0.76);
rand_uncertainty=std_e;

fprintf("========4.1a=======\n");
fprintf("Values of e: [%f,%f,%f,%f,%f]\n",e);
fprintf("Mean e: %f\n",mean_e);
fprintf("Standard Deviation of e: %f\n",std_e);
fprintf("Uncertainty in Accuracy (bias): %f\n",bias);
fprintf("Uncertainty in Precision: %f\n",rand_uncertainty);

%4.1b randomizing the experiment and repeating it 1000 times
%Defining parameters
M=1000;
m2=58;
s2=2;

%Creating Arrays to store the data
h2_bar=zeros(M,1);
sh2=zeros(M,1);
e_bar=zeros(M,1);
se=zeros(M,1);

%Creating the data from simulation
for i=1:M
    h2_sim=normrnd(m2,s2,1,5);
    h2_bar(i)=mean(h2_sim);
    sh2(i)=std(h2_sim);

    e_sim=sqrt(h2_sim/h1);
    e_bar(i)=mean(e_sim);
    se(i)=std(e_sim);
end

%Plotting
figure(1)
histogram(h2_bar,'Normalization','probability');
hold on;
expected_h2=m2*ones(size(h2_bar)); %helping array to plot the red line showing expected_h2
plot(expected_h2,linspace(0,1,numel(h2_bar)),'r--','LineWidth',2);
hold off;
title('Histogram of h2\_bar');
legend('Sim h2\_bar','Expected h2\_bar');

figure(2)
histogram(e_bar,'Normalization','probability');
hold on
expected_e=mean_e*ones(size(e_bar));
plot(expected_e,linspace(0,1,numel(e_bar)),'r--','LineWidth',2);
hold off; 
title('Histogram of e\_bar');
legend('Simulated e\_bar','Expected e\_bar');

%4.1c 5 repetitions with h1!=stable
h1_c=[80,100,90,120,95];
h2_c=[48,60,50,75,56];
e_c=sqrt(h2_c./h1_c);
mean_h1=mean(h1_c);
mean_h2=mean(h2_c);
mean_e_c=mean(e_c);

std_h1=std(h1_c);
std_h2_c=std(h2_c);
std_e_c=std(e_c);

bias_c=abs(mean_e_c-0.76);

fprintf("==========4.1c=========\n");
fprintf("Mean h1: %.2f\n",mean_h1);
fprintf("Standard deviation of h1 (uncertainty): %.2f\n",std_h1);
fprintf("Mean h2: %.2f\n",mean_h2);
fprintf("Standard deviation of h2 (uncertainty): %.2f\n",std_h2_c);
fprintf("Mean e: %.2f\n",mean_e_c);
fprintf("Standard deviation of e (uncertainty): %.2f\n",std_e_c);
fprintf("Bias of e: %.2f\n",bias_c);

if bias_c<=0.05
    fprintf("The ball can be used\n");
else
    fprintf("The ball can't be used\n");
end

