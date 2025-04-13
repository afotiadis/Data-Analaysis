%Alexandros Fotiadis AEM:10392
clc;
clf;
clear;
close all;

%Loading the data
hospital_data=load("hospital.txt");
data=hospital_data;
var_names=char('ManHours','Cases','Eligible','OpRooms');
Y=data(:,1); %assigning the data to variables
X=data(:,2:end);
n=length(Y);
k=size(X,2);
alpha=0.05;
zc=norminv(1-alpha/2);

x=[ones(n,1) X]; %testing the full model using all the variables
[b,bint]=regress(Y,x);
y=x*b;
e=Y-y;
se=std(e);
e_star=e/se;
muY=mean(Y);
R2=1-(sum(e.^2))/(sum((Y-muY).^2));
adjR2=1-((n-1)/(n-(k+1)))*(sum(e.^2))/(sum((Y-muY).^2));

fprintf("Full model using all 3 variables\n");
fprintf("Coefficients\n\tb0=%.5f, b0int=[%.5f %.5f]\n",b(1),bint(1,1),bint(1,2));
for i=2:length(b)
    fprintf("\t%s: b%d=%.5f, b%dint=[%.5f %.5f]\n", ...
        var_names(i,:),i-1,b(i),i-1,bint(i,1),bint(i,2));
end

fprintf("Residual std: %.5f\n",se);
fprintf("R^2=%.5f\nadjR^2=%.5f",R2,adjR2); %displaying the results

figure(); %diagnostic plot for the full model
scatter(Y,e_star,12,"blue","filled");
hold on;
yline(zc,"r-.");
yline(-zc,"r-.");
xlabel("Man hours");
ylabel("Standardized adjustment error");
title("Diagnostic plot for full model");
hold off;

%stepwise regression model
[bs,sebs,~,finalmodel,stats]=stepwisefit(X,Y);
bs=[stats.intercept;bs];
model_vars=find(finalmodel==1); %finding with the use of logical array which variables are used

y=x*(bs.*transpose([1 finalmodel])); %expected values

e=Y-y;
k1=sum(finalmodel); %extra degrees of freedom that will be subtracted
se=std(e);
e_star=e/se;
R2=1-(sum(e.^2))/(sum((Y-muY).^2));
adjR2=1-((n-1)/(n-(k1+1)))*(sum(e.^2))/(sum((Y-muY).^2));
tc=tinv(1-alpha/2,n-(k1+1));
%Displaying the results
fprintf("Model using stepwise regression\n");
fprintf("Coefficients\n\tb0=%.5f\n",bs(1));
for i=1:k1
    fprintf("\t%s: b%d=%.5f, b%dint=[%.5f %.5f]\n", ...
        var_names(model_vars(i)+1,:),model_vars(i),bs(i),model_vars(i), ...
        bs(model_vars(i))-tc*sebs(model_vars(i)),bs(model_vars(i))+tc*sebs(model_vars(i)));
end

%Diagnostic plot for the stepwise regression model
figure()
scatter(Y,e_star,12,"blue","filled");
hold on;
yline(zc,"r-.");
yline(-zc,"r-.");
xlabel("Man hours");
ylabel("Standardized adjustment error");
title("Diagnostic plot for stepwise regression model");
hold off;

for i=1:k
    vars=setdiff(1:k,i);
    x=[ones(n,1) X(:,vars)];
    [b,bint]=regress(X(:,i),x);
    y=x*b;
    e=X(:,i)-y;
    se=std(e);
    e_star=e/se;
    mu_Xi=mean(X(:,i));
    R2=1-(sum(e.^2))/(sum((X(:,i)-mu_Xi).^2));
    adjR2=1-((n-1)/(n-(k+1)))*(sum(e.^2))/(sum((X(:,i)-mu_Xi).^2));

    fprintf("\nRegression model of %s\n",var_names(i+1,:));
    fprintf("Residual std: %.5f\n",se);
    fprintf("R^2=%.5f \nadjR^2=%.5f",R2,adjR2);
end
figure();
plotmatrix(X);