%Alexandros Fotiadis AEM:10392
clear all;

data=load('eruption.dat'); %loading the data file given
column1=data(:,1); %splitting the data into 3 different column-arrays
column2=data(:,2);
column3=data(:,3);
alpha=0.05; %level of significance

[h1,p1,c1]=vartest(column1,10); %95% confidence interval for variance and hypothesis testing
[h2,p2,c2]=vartest(column2,1);
[h3,p3,c3]=vartest(column3,10);

fprintf('95%% confidence interval of standard deviation for waiting time 1968 is (%.4f,%.4f)\n',sqrt(c1));

if h1==1
    fprintf('Reject null hypothesis: standard deviation of waiting time in 1968 is not 10\n');
else
    fprintf('Can not reject null hypothesis: standard deviation of waiting time in 1968 is 10\n');
end

fprintf('95%% confidence interval of standard deviation for eruption time 1968 is (%.4f,%.4f)\n',sqrt(c2));

if h2==1
    fprintf('Reject null hypothesis: standard deviation of eruption time in 1968 is not 1\n');
else
    fprintf('Can not reject null hypothesis: standard deviation of waiting time in 1968 is 1\n');
end

fprintf('95%% confidence interval of standard deviation for waiting time 2006 is (%.4f,%.4f)\n',sqrt(c3));

if h3==1
    fprintf('Reject null hypothesis: standard deviation of waiting time in 2006 is not 10\n');
else
    fprintf('Can not reject null hypothesis: standard deviation of waiting time in 2006 is 10\n');
end

[h4,p4,c4]=ttest(column1,75); %95% confidence interval for mean values and hypothesis testing
[h5,p5,c5]=ttest(column2,2.5);
[h6,p6,c6]=ttest(column3,75);

fprintf('95%% confidence interval of Mean Value for waiting time 1968 is (%.4f,%.4f)\n',c4);

if h4==1
    fprintf('Reject null hypothesis: Mean Value of waiting time in 1968 is not 75\n');
else
    fprintf('Can not reject null hypothesis: Mean Value of waiting time in 1968 is 75\n');
end

fprintf('95%% confidence interval of Mean Value for eruption time 1968 is (%.4f,%.4f)\n',c5);

if h5==1
    fprintf('Reject null hypothesis: Mean Value of eruption time in 1968 is not 2.5\n');
else
    fprintf('Can not reject null hypothesis: Mean Value of eruption time in 1968 is 2.5\n');
end

fprintf('95%% confidence interval of Mean Value for waiting time 2006 is (%.4f,%.4f)\n',c6);

if h6==1
    fprintf('Reject null hypothesis: Mean Value of waiting time in 2006 is not 75\n');
else
    fprintf('Can not reject null hypothesis: Mean Value of waiting time in 2006 is 75\n');
end

[h7,p7]=chi2gof(column1); %chi2 goodness-of-fit test
[h8,p8]=chi2gof(column2);
[h9,p9]=chi2gof(column3);

if h7==1
    fprintf('Reject null hypothesis: data of waiting time 1968 does not fit in normal distribution\n');
else
    fprintf('Can not reject null hypothesis: data of waiting time 1968 fit in normal distribution\n');
end

fprintf('p-value for 1968 waiting: %f\n',p7);

if h8==1
    fprintf('Reject null hypothesis: data of eruption time 1968 does not fit in normal distribution\n');
else
    fprintf('Can not reject null hypothesis: data of eruption time 1968 fit in normal distribution\n');
end

fprintf('p-value for 1968 eruption: %f\n',p8);

if h9==1
    fprintf('Reject null hypothesis: data of waiting time 2006 does not fit in normal distribution\n');
else
    fprintf('Can not reject null hypothesis: data of waiting time 2006 fit in normal distribution\n');
end
fprintf('p-value for 2006 waiting: %f\n',p9);