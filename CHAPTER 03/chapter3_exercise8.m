%Alexandros Fotiadis AEM:10392
clear all;
%Defining the parameters
M=100;
n=10;
alpha=0.05;
%Creating the samples
data_X=randn(n,M);
data_Y=data_X.^2;

%arrays for storing the c.i. values
ci_1=zeros(4,M);
ci_2=zeros(4,M);

for i=1:M %C.I. calculated both ways. Vartest performing just to calculate the parametric c.i.(the argument 1 is used only for the function to perform )
    [~,~,ci_1(1:2,i)]=vartest(data_X(:,i),1);
    ci_1(3:4,i)=bootci(100,@std,data_X(:,1));
    [~,~,ci_2(1:2,i)]=vartest(data_Y(:,i),1);
    ci_2(3:4,i)=bootci(100,@std,data_Y(:,1));
end

%Array for labeling
bounds_X=["Lower Bound for parametric c.i. for Std(X)","Upper Bound for parametric c.i. for Std(X)","Lower Bound for bootstrap c.i. for Std(X)","Upper Bound for bootstrap c.i. for Std(X)"];
figure(1);

%plotting
for i=1:4
    subplot(2,2,i);
    histogram(sqrt(ci_1(i,:)));
    xlabel(bounds_X(i));
    ylabel("Probability");
end

title("Histograms:bounds of the 95% c.i. of Std(X)");

bounds_Y=["Lower Bound for parametric c.i. for Std(Y)","Upper Bound for parametric c.i. for Std(Y)","Lower Bound for bootstrap c.i. for Std(Y)","Upper Bound for bootstrap c.i. for Std(Y)"];
figure(2);
for i=5:8
    subplot(2,2,i-4);
    histogram(sqrt(ci_2(i-4,:)));
    xlabel(bounds_Y(i-4));
    ylabel("Probability");
end
title("Histogram:bounds of the 95% c.i. of Mean(Y)");
