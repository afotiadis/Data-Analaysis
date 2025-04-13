%Alexandros Fotiadis AEM:10392
clc;
clf;
clear;

%Loading data and defining parameters
data=load("lightair.dat");
X=data(:,1); %air density
Y=data(:,2); %speed of light
n=length(X);
alpha=0.05;

muX=mean(X);
muY=mean(Y);
varX=var(X);
varY=var(Y);
cov_mtx_XY=cov(X,Y);
covXY=cov_mtx_XY(1,2);
fprintf("Air density: \n\tMean: %.4f\n\tVariance: %.4f\n",muX,varX);
fprintf("Speed of light: \n\tMean: %.4f\n\tVariance: %.4f\n",muY,varY);
fprintf("Covariance: %.4f\n",covXY);
figure(1)
histogram(X);
title("Histogram for air density");
figure(2)
histogram(Y)
title("Histogram for speed of light");

%calculating the correlation coefficient matrix and keeping only the X,Y
%coefficient 
r_mtx=corrcoef(X,Y);
r=r_mtx(1,2);
fprintf("Correlation Coefficient of X,Y: %.3f\n",r);
figure(3)
scatter(X,Y,12,"blue","filled"); %scatter plot for X and Y
title(sprintf("Air density and speed of light r=%.3f",r));
xlabel("Air density");
ylabel("Speed of light");

%Calculating regression confidence interval for regression and the square
%error
[b,bint]=regress(Y,[ones(n,1) X]);
square_error=sqrt((n-1)/(n-2)*(varY-b(2)^2*varX));
fprintf("Linear regression model: y=b1*x+b0 -> Y=%.4fX +%.4f\n",b(2),b(1));
fprintf("C.I for regression coefficient =%.4f: [%.4f %.4f]\n",b(2),bint(2,1),bint(2,2));
fprintf("C.I for slope =%.4f: [%.4f %.4f]\n",b(1),bint(1,1),bint(1,2));
fprintf("Least squares error: square_error=%.4f\n",square_error);

%scatter plot and calculating y for x0=1.29
x0=1.29;
y0=b(2)*x0+b(1);
t_crit=tinv(1-alpha/2,n-2);

Sxx=varX*(n-1);
my_std=square_error*sqrt(1/n + (x0-muX)^2/Sxx);
my_ci=[y0-t_crit*my_std y0+t_crit*my_std];
fprintf("C.I for mean(Y) given X=%.4f: [%.4f %.4f]\n",x0,my_ci(1),my_ci(2));

y0_std=square_error*sqrt(1+1/n+(x0-muX).^2/Sxx);
y0_ci=[y0-t_crit*y0_std y0+t_crit*y0_std];
fprintf("Forecast C.I for Y=%.4f and X=%.4f: [%.4f %.4f]\n",y0,x0,y0_ci(1),y0_ci(2));

x0_c2= linspace(min(X),max(X),100);
y0_c2=b(2)*x0_c2+b(1);
my_std_c2=square_error*sqrt(1/n+(x0_c2-muX).^2/Sxx);
my_ci_c2=[y0_c2-t_crit*my_std_c2 y0_c2+t_crit*my_std_c2];
y0_c2_std=square_error*sqrt(1+1/n +(x0_c2-muX).^2/Sxx);
y0_c2_ci=[y0_c2-t_crit*y0_c2_std y0_c2+t_crit*y0_c2_std];

figure(4)
scatter(X,Y,10,"blue","filled");
hold on;
plot(x0_c2,y0_c2,'LineWidth',2);
xlabel("Air density");
ylabel("Speed of light");
if b(2)<0
    txt=sprintf("y=%.3f -%.3fx",b(1),abs(b(2)));
else
    txt=sprintf("y=%.3f +%.3fx",b(1),abs(b(2)));
end
title(strcat("Air density and light speed: ",txt));
plot(x0_c2,y0_c2_ci(:,1),'m--');
plot(x0_c2,y0_c2_ci(:,2),'m--');
plot(x0_c2,my_ci_c2(:,1),'c--');
plot(x0_c2,my_ci_c2(:,2),'c--');
legend("","Least squares line","Forecast Interval","","Mean(Y) C.I.");

%calculating how accurate the c.i. is on the real model
c = [299792.458-299000 -299792.458*0.00029/1.29];
fprintf("Real Linear Model: y= %.4fx+%.4f\n",c(2),c(1));
if c(1)<bint(1,1) || c(1)>bint(1,2)
    fprintf("Real intercept %.4f is not on the c.i. [%.4f %.4f]\n",c(1),bint(1,1),bint(1,2));
else
    fprintf("Real intercept %.4f is on the c.i. [%.4f %.4f]\n",c(1),bint(1,1),bint(1,2));
end
if c(2)<bint(2,1) || c(1)>bint(2,2)
    fprintf("Real slope %.4f is not on the c.i. [%.4f %.4f]\n",c(2),bint(2,1),bint(2,2));
else
    fprintf("Real slope %.4f is on the c.i. [%.4f %.4f]\n",c(2),bint(2,1),bint(2,2));
end

v=c(1)+c(2).*x0_c2;
accept=zeros(length(x0_c2),1);
for i=1:length(x0_c2)
    if v(i)>=my_ci_c2(i,1) && v(i)<=my_ci_c2(i,2)
        accept(i)=1;
    end
end
fprintf("Acceptance rate (The real c is in the c.i.): %.4f%%",sum(accept)*100/length(x0_c2));