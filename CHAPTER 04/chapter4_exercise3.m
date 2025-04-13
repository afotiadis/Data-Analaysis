%Alexandros Fotiadis AEM:10392
clc;
clf;
clear;

%Defining Parameters
M=1000;
mu_volt=77.78;
std_volt=0.71;
mu_curr=1.21;
std_curr=0.071;
mu_f=0.283;
std_f=0.017;
rvf=0.5;

%4.3a calculating the uncertainty of P (V,I,f independent)
std_power=sqrt((mu_curr*cos(mu_f))^2*std_volt^2+(mu_volt*cos(mu_f))^2*std_curr^2+...
    (mu_volt*mu_curr*(-sin(mu_f)))^2*std_f^2); %using the type with the derivatives from the notes
fprintf("Uncertainty of Power: %.4f\n",std_power);

%4.3b Assuming normal distribution for V,I,f M=1000 experiments to define
%uncertainty
V=normrnd(mu_volt,std_volt,M,1); %Generating the values of V,I,f from normal distribution
I=normrnd(mu_curr,std_curr,M,1);
f=normrnd(mu_f,std_f,M,1);
P=V.*I.*cos(f); %executing the calculations for columns
std_p=std(P);
fprintf("Experimental results for uncertainty of power: %.4f\n",std_p);

%4.3c V,f not independent
cov_v_f=rvf*std_volt*std_f; %covariance of V,f
std_p2=sqrt((mu_curr*cos(mu_f))^2*std_volt^2 + (mu_volt*cos(mu_f))^2*std_curr^2 + ...
    (mu_volt*mu_curr*(-sin(mu_f)))^2*std_f^2 + 2*mu_curr*cos(mu_f)*mu_volt*mu_curr*(-sin(mu_f))*cov_v_f);
cov_matrix=[std_volt^2 0 cov_v_f; 0 std_curr^2 0; cov_v_f 0 std_f^2]; %covariance matrix
mu=[mu_volt mu_curr mu_f];
data=mvnrnd(mu,cov_matrix,M); %now 2 of our variables are related so we need mvrnd
V2=data(:,1); %assigning each column from the data to each variable
I2=data(:,2);
f2=data(:,3);
P2=V2.*I2.*cos(f2); %calculating the uncertainty
std_power2=std(P2);
fprintf("Uncertainty of Power: %.4f\n",std_p2);
fprintf("Experimental result for uncertainty of power: %.4f\n",std_power2);