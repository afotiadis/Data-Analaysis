%Alexandros Fotiadis AEM:10392
clc;
clf;
clear;

%Inserting data
X=[2 3 8 16 32 48 64 80]';
Y=[98.2 91.7 81.3 64.0 36.4 32.6 17.1 11.3]';
n=length(X);
alpha=0.05;

%calculating r
r=corrcoef(X,Y);
r=r(1,2);
fprintf("Correlation coefficient: %.3f\n",r);

%testing the simple linear regression model
b=regress(Y,[ones(n,1) X]);
fprintf("Linear regression model: y=b1x+b0 -> Y= %.4f X +%.4f\n",b(2),b(1));
x0=linspace(min(X),max(X),100);
y0=b(2)*x0+b(1);
figure(1)
scatter(X,Y,12,'blue','filled'); %scatter plot for linear regression
title(sprintf('Kilometres driven VS percentage of usability: r=%.3f',r));
hold on;
plot(x0,y0,"LineWidth",2);
xlabel("Kilometres driven");
ylabel("Percentage of usability");
hold off;

%adjusting the errors and plotting a diagnostic plot
e=Y-[ones(n,1) X]*b;
se=sqrt((1/(n-2))*(sum(e.^2)));
e_star=e./se;
zc=norminv(1-alpha/2);
figure(2)
scatter(Y,e_star,12,'blue','filled');
hold on;
yline(zc,'r-.');
yline(-zc,'r-.');
xlabel("Percentage of usability");
ylabel("Standardized adjustment error");
title("Diagnostic plot");
hold off;

%transforming y in lny and testing the linear model for lny
lnY=log(Y);
var_lnY=var(lnY);
mu_lnY=mean(lnY);
varX=var(X);
[bln,bintln]=regress(lnY,[ones(n,1) X]);
se_ln=sqrt((n-1)/(n-2) * (var_lnY-bln(2)^2*varX));
e_ln=lnY-[ones(n,1) X]*bln;
R2_ln=1-(sum(e_ln.^2))/(sum((lnY-mu_lnY).^2)); %calculating R^2 and adjR^2
adj_R2_ln=1-((n-1)/(n-2))*(sum(e_ln.^2))/(sum((lnY-mu_lnY).^2));
fprintf("Linear regression model using ln-transformation: y=ln(b0)+b1x ->" + ...
    "y=%.3f + (%.3f)x\n",bln(1),bln(2));
fprintf("se=%.4f , R^2=%.4f , adjR^2=%.4f\n",se_ln,R2_ln,adj_R2_ln);
lny0=bln(2)*x0+bln(1); %expected values
figure(3)
scatter(X,lnY,12,'blue','filled');
title(sprintf('Kilometres driven vs ln percentage of usability y=%.3f+(%.3f)x',bln(1),bln(2)));
hold on;
plot(x0,lny0,"LineWidth",2);
xlabel("Kilometres driven");
ylabel("ln percentage of usability");

%diagnostic plot for the new model
e_star_ln=e_ln./se_ln;
figure(4)
scatter(Y, e_star_ln,12,'blue','filled');
hold on;
yline(zc,'r-.');
yline(-zc,'r-.');
xlabel("ln percentage of usability");
ylabel("Standardized adjustment error");
title("Diagnostic plot of ln linear regression");

%scatter plot for the exponential model 
a=exp(bln(1));
b=bln(2);
fprintf("Exponential model y=%.3f*exp(%.3fx)\n",a,b);
y0=a*exp(b*x0);
figure(5)
scatter(X,Y,12,'blue','filled');
title("Kilometers driven vs pct of usability");
hold on;
plot(x0,y0,'LineWidth',2);
xlabel("Kilometers driven");
ylabel("pct of usability");
text(mean(X),mean(Y),sprintf('y=%.3f*exp(%.3fx)',a,b));
hold off;
x=25;
y=a*exp(b*x); %calculating percentage of usability for 25 thousand km
fprintf("Percentage usable for x=%.1fKM: y=%.4f",x*1000,y);