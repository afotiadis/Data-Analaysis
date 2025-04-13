%Alexandros Fotiadis AEM:10392
clear;
clc;
clf;

%Defining parameters
M=100;
n=10;
m=12;
numBootstraps=1000;
alpha=0.05;
lower_bound=floor((numBootstraps+1)*alpha/2);
upper_bound=numBootstraps+1-lower_bound;

%Creating X and Y
X=randn(n,M);
Y=randn(m,M);

%Shortcut
transform_code = input("Press 1 to transform, else 0:\n");
if transform_code==1
    X=X.^2;
    Y=Y.^2;
end

counter=0; %for bootstrap

%Parametric Method Variables
h_values=zeros(1,M);
ci_param=zeros(2,M);
p_values=zeros(1,M);
bci=zeros(M,2);

%Bootstrap Sampling
boot_meanX=bootstrp(numBootstraps,@mean,X);
boot_meanY=bootstrp(numBootstraps,@mean,Y);
boot_diff=boot_meanX-boot_meanY;

%Parametric Method and Bootstrap Method in the same for loop
for i=1:M
    [h_values(1,i),p_values(1,i),ci_param(1:2,i)]=ttest2(X(:,i),Y(:,i));
    bci(1,i)=prctile(boot_diff(:,i),lower_bound*100/numBootstraps);
    bci(2,i)=prctile(boot_diff(:,i),upper_bound*100/numBootstraps);
    if bci(i,1)>0 || bci(i,2)<0
        counter=counter+1;
    end
    
end

parametric_percentage=(sum(h_values,"all")/M)*100;
bootstrap_percentage=(counter/M)*100;


fprintf("mean(X)-mean(Y)!=0: %.2f %% using the parametric method\n",parametric_percentage);
fprintf("mean(X)-mean(Y)!=0: %.2f %% using the bootstrap method\n",bootstrap_percentage);
