%Alexandros Fotiadis AEM:10392
clc;
close all;
clear;

%Inserting data 
R=[0.76 0.86 0.97 1.11 1.45 1.67 1.92 2.23 2.59 3.02 3.54 4.16 4.91 ...
    5.83 6.94 8.31 10.00 12.09 14.68 17.96 22.05 27.28 33.89 42.45 ...
    53.39 67.74 86.39 111.30 144.00 188.40 247.50 329.20]';
T=[110 105 100 95 85 80 75 70 65 60 55 50 45 40 35 30 25 20 15 10 5 ...
    0 -5 -10 -15 -20 -25 -30 -35 -40 -45 -50]' +273.15;
%transforming R to lnR and T to T^(-1)
ln_R=log(R);
T_inv=1./T;
n=length(R);
alpha=0.05;

%correlation coefficient and swtich k for each polynomial degree
kmax=4;
r=corrcoef(ln_R,T_inv);
r=r(1,2);
fprintf("Correlation coefficient r=%.3f\n",r);
npoints=100;
R0=linspace(min(ln_R),max(ln_R),npoints)';
zc=norminv(1-alpha/2);
for k=1:kmax
    switch k
        case 1
            x=[ones(n,1) ln_R];
            x0=[ones(npoints,1) R0];
        case 2
            x=[ones(n,1) ln_R ln_R.^2];
            x0=[ones(npoints,1) R0 R0.^2];
        case 3
            x=[ones(n,1) ln_R ln_R.^2 ln_R.^3];
            x0=[ones(npoints,1) R0 R0.^2 R0.^3];
        case 4
            x=[ones(n,1) ln_R ln_R.^2 ln_R.^3 ln_R.^4];
            x0=[ones(npoints,1) R0 R0.^2 R0.^3 R0.^4];
    end

    %calculating the regression model and plotting diagnostic plot and
    %scatter plot for each value of k
    [b,bint,r,rint,stats]=regress(T_inv,x);
    y=x*b;
    y0=x0*b;
     e=T_inv-y;
     se=sqrt((1/(n-(k+1)))*(sum(e.^2)));
     e_star=e./se;

     muY=mean(T_inv);
     R2=1-(sum(e.^2))/(sum((T_inv-muY).^2));
     adj_R2=1-((n-1)/(n-(k+1)))*(sum(e.^2))/(sum((T_inv-muY).^2));
     figure()
     scatter(ln_R,T_inv,12,'blue','filled');
     title(sprintf('lnR vs 1/T: Degree= %d',k));
     hold on;
     plot(R0,y0,"LineWidth",2);
     xlabel("lnR");
     ylabel("1/T");
     txt = ['R2=' num2str(R2) newline 'adjR2=' num2str(adj_R2)];
     text(R0(round(npoints/2)),y0(round(npoints/5)),txt);
     hold off;
     figure()
     scatter(T_inv,e_star,12,'blue','filled');
     hold on
     yline(zc,'r-.');
     yline(-zc,'r-.');
     xlabel("1/T");
     ylabel("Standardized adjustment error");
     title("Diagnostic plot");
     fprintf("Polynomial degree=%d\n",k);
     for i=1:k+1
         fprintf("\tb_%d = %.10f\n",i-1,b(i));
     end

end

%5.7b Steinhart-Hart model
x=[ones(n,1) ln_R ln_R.^3];
x0=[ones(npoints,1) R0 R0.^3];

[b,bin,r,rint,stats]=regress(T_inv,x);
y=x*b;
y0=x0*b;

e=T_inv-y;
se=sqrt((1/(n-2))*(sum(e.^2)));
e_star=e./se;

R2=1-(sum(e.^2))/(sum((T_inv-muY).^2));
adj_R2=1-((n-1)/(n-(k+1)))*(sum(e.^2))/(sum((T_inv-muY).^2));
figure();
scatter(ln_R,T_inv,12,'blue','filled');
title("Steinhart-Hart model");
hold on;
plot(R0,y0,'LineWidth',2);
xlabel("lnR");
ylabel("1/T");
txt = ['R2=' num2str(R2) newline 'adjR2=' num2str(adj_R2)];
text(R0(round(npoints/2)),y0(round(npoints/5)),txt);
hold off;
figure();
scatter(T_inv,e_star,12,'blue','filled');
hold on;
yline(zc,'r-.');
yline(-zc,'r-.')
xlabel("1/T");
ylabel("Standard adjustment error");
title("Diagnostic plot");

fprintf("Steinhar-Hart model:\n");
for i=1:3
    fprintf("\tb_%d = %.10f\n",i-1,b(i));
end
