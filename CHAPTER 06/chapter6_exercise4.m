%Alexandros Fotiadis AEM:10392
clc;
clear
close all;

%Exercise 6.3
n=1e4; %10000 observations
s1=load('chirp.mat'); %loading the sounds and holding the first n values of each signal
s1=s1.y;
s1=s1(1:n);
s2=load('gong.mat');
s2=s2.y;
s2=s2(1:n);
s=[s1 s2]; %making a matrix that contains both the signals 
s(:,1)=s(:,1)-mean(s(:,1)); %centered samples
s(:,2)=s(:,2)-mean(s(:,2));

figure(); %plotting the first signal
plot(s(:,1));
xlabel('t');
ylabel('s1(t)');
title('Source signal 1: chirp');

figure(); %plotting the second signal
plot(s(:,2));
xlabel('t');
ylabel('s2(t)');
title('Source signal 2: gong');

%scatter plot for the 2 signals
figure() 
scatter(s(:,1),s(:,2),8);
xlabel('s1');
ylabel('s2');
title('Scatter plot for s1 and s2');

prewhitening=1; %initiating so that prewhitening will be executed

% Mixing matrix A
% a : matrix size 2x2
%A = [-0.1 0.3; -2.5 -0.2];
% b : matrix size 2x3
A = [-0.1 0.3 -0.2; -2.5 -0.2 -0.3];
p=size(A,2);
x=s*A;

%plotting the mixed signal 1
figure(); 
plot(x(:,1));
xlabel('t');
ylabel('x1(t)');
title('Mixed signal 1');

%Plotting the mixed signal 2
figure();
plot(x(:,2));
xlabel('t');
ylabel('x2(t)');
title('Mixed signal 2');

%plotting mixed signal 3 (only when p==3)
if p==3
    figure();
    plot(x(:,3));
    xlabel('t');
    ylabel('x3(t)');
    title('Mixed signal 3');
end

y=x-repmat(sum(x)/n,n,1); %centered sample for mixed signals

%scatter plot for the observed signals
if p==2
    figure();
    scatter(y(:,1),y(:,2),8);
    xlabel('y1');
    ylabel('y2');
    title('Scatter plot of observed signals');
elseif p==3
    figure();
    scatter3(y(:,1),y(:,2),y(:,3),8);
    xlabel('y1');
    ylabel('y2');
    zlabel('y3');
    title('Scatter plot of observed signals');
end

%Applying prewhitening
if prewhitening
    y=prewhiten(y);
end

%ICA method
Mdl=rica(y,p,'Lambda',0.5);
w=Mdl.TransformWeights;
z=transform(Mdl,y);
figure();
plot(z(:,1));
xlabel('t');
ylabel('s1(t)');
title('ICA reconstructed s1');
figure();
plot(z(:,2));
xlabel('t');
ylabel('s2(t)');
title('ICA reconstructed s2');

%Scatter plot for the reconstructed signals 
if p==2
    figure();
    scatter(z(:,1),z(:,2),8);
    xlabel('s1');
    ylabel('s2');
    title('Scatter plot of ICA reconstructed signals');
elseif p==3
    figure();
    scatter3(z(:,1),z(:,2),z(:,3),8);
    xlabel('z1');
    ylabel('z2');
    zlabel('z3');
    title('Scatter plot of ICA reconstructed signals');
end

%This function was found in the documentation and used with no changes in
%its syntax
function y =prewhiten(x)
    [n,p]=size(x);
    assert(n>=p);

    [U,Sig]=svd(cov(x));
    Sig=diag(Sig);
    Sig=Sig(:)';

    tol=eps(class(x));
    idx=(Sig>max(Sig)*tol);
    assert(~all(idx==0));

    Sig=Sig(idx);
    U=U(:,idx);

    mu=mean(x,1);
    y=x-mu;
    y=y*U./sqrt(Sig);
    end
