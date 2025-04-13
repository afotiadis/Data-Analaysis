%Alexandros Fotiadis AEM:10392
clc;
clf;
clear;
close all;

%Loading the data (name line manually erased)
physical_data=load('physical.txt');
data=physical_data;
var_names=char('Mass','Fore','Bicep','Chest','Neck','Shoulder',...
    'Waist','Height','Calf','Thigh','Head'); %for displaying reasons
Y=data(:,1); %Initiating the data 
X=data(:,2:end);
n=length(Y);
k=size(X,2);
alpha=0.05;
zc=norminv(1-alpha/2);

x=[ones(n,1) X]; %trying the full model using all the variables
[b,bint]=regress(Y,x);
y=x*b;

e=Y-y;
se=std(e);
e_star=e/se;

muY=mean(Y);
R2=1-(sum(e.^2))/(sum((Y-muY).^2));
adj_R2=1-((n-1)/(n-(k+1)))*(sum(e.^2))/(sum((Y-muY).^2));

fprintf("Full model using all 10 variables\n");
fprintf('Coefficients\n\tb0=%.5f , b0_int=[%.5f %.5f]\n',b(1),bint(1,1),bint(1,2));
for i=2:length(b)
    fprintf("\t%s: b%d=%.5f, b%int=[%.5f %.5f]\n",var_names(i,:),i-1,b(i),i-1,bint(i,1),bint(i,2));
end
fprintf("Residual std: %.5f\n",se); %displaying the standard error and R^2, adjR^2
fprintf("R^2=%.5f\n adjR^2=%.5f\n",R2,adj_R2);

figure() %scatter plot for the full model
scatter(Y,e_star,12,'blue','filled');
hold on;
yline(zc,"r-.");
yline(-zc,"r-.");
xlabel("Mass (kg)");
ylabel("Standardized adjustment error");
title("Diagnostic plot for full model");
hold off;

[bs,sebs,~,finalmodel,stats]=stepwisefit(X,Y); %stepwise regression method
bs=[stats.intercept;bs];
model_vars=find(finalmodel==1); %finding the 1 in the logical array 

y=x*(bs.*transpose([1 finalmodel])); %expected values

e=Y-y;
k=sum(finalmodel); %the extra freedom degrees that we will subtract to find tc and adjR^2
se=std(e);
e_star=e/se;
R2=1-(sum(e.^2))/(sum((Y-muY).^2));
adj_R2=1-((n-1)/(n-(k+1)))*(sum(e.^2))/(sum((Y-muY).^2));
tc=tinv(1-alpha/2,n-(k+1));
fprintf("Model using stepwise regression:\n");
fprintf("Coefficients\n\tb0=%.5f\n",bs(1));
for i=1:k
    fprintf("\t%s: b%d=%.5f, b%dint=[%.5f %.5f]\n",...
        var_names(model_vars(i)+1,:),model_vars(i),bs(model_vars(i)+1), ...
        model_vars(i),bs(model_vars(i)+1)-tc*sebs(model_vars(i)+1), ...
        bs(model_vars(i)+1)+tc*sebs(model_vars(i)+1));
end
fprintf("Residual std: %.5f\n",se);
fprintf("R^2=%.5f\n adjR^2=%.5f\n",R2,adj_R2); %displaying the results

figure() %diagnostic plot for the stepwise regression model
scatter(Y,e_star,12,'blue','filled');
hold on;
yline(zc,"r-.");
yline(-zc,"r-.");
xlabel("Mass (kg)");
ylabel("Standardized adjustment error");
title("Diagnostic plot for stepwise regression model");
hold off;

