%Alexandros Fotiadis AEM:10392
clc;
clf;
clear;

rain_data=load('rainThes59_97.dat'); %Importing the data
temp_data=load('tempThes59_97.dat');

%Defining Parameters
[y,m]=size(rain_data);
L=1000;
alpha=0.05;
R=zeros(L+1,m);

%calculating and storing the correlation coefficient (with and without
%random permutation)
for i=1:m
    temp_R=corrcoef(rain_data(:,i),temp_data(:,i));
    R(1,i)=temp_R(1,2);

    for j=1:L
        temp_R=corrcoef(rain_data(:,i),temp_data(randperm(y),i));
        R(j+1,i)=temp_R(1,2);
    end
end

%non-parametric method
t=R.*sqrt((y-2)./(1-R.^2));
t_sort=sort(t(2:L+1,:),1);
lower_bound=round((alpha/2)*L);
upper_bound=round((1-alpha/2)*L);
t_low=t_sort(lower_bound,:);
t_up=t_sort(upper_bound,:);

rej= t(1,:)-t_low<0 | t(1,:)-t_up >0;
num_of_rej=sum(rej);
rej_pct=num_of_rej/m;
fprintf("Percentage of rejections for H0 %.4f%%.\n",rej_pct*100);

%parametric method
tc=tinv(1-alpha/2,y-2);
accept=abs(t(1,:))<tc;
num_accept=sum(accept);
fprintf("Percentage of rejections for H0 %.4f%%.\n",(m-num_accept)*100/m);

%printing out the results for each month separately
for i=1:m
    fprintf("============Month %d============\n",i);
    fprintf("Non-parametric method: t=%.3f, c.i.=[%.3f,%.3f]\n",t(1,i),t_low(1,i),t_up(1,i));

    if rej(1,i)==1
        fprintf("Rejection\n");
    else
        fprintf("Acceptance\n");
    end

    fprintf("Parametric method: t=%.3f, tinv=%.3f\n",t(1,i),tc);
    if accept(1,i)==0
        fprintf("Rejection\n");
    else
        fprintf("Acceptance\n");
    end
end