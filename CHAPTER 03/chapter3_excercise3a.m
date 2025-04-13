%Alexandros Fotiadis AEM:10392
clear all;

lambda=1/15; %defining parameters
n=5;
M=1000;

contained_counter=0; %initializing an index to count how many times mean value is contained in the c.i.

for i=1:M
    lifespans=exprnd(1/lambda,1,n); % create n observations following exponential distribution

    sample_mean=mean(lifespans);
    sample_std=std(lifespans);
    standard_error=sample_std/sqrt(n); %defining the standard error for later use in calculating the c.i.

    alpha=0.05;
    t_critical=tinv(1-alpha/2,n-1); %calling the t inverse function to calculate the c.i.
    margin_of_error=t_critical*(sample_std/sqrt(n)); %calculating the margin of error to define the lower and upper bound of the c.i.
    lower_bound=sample_mean-margin_of_error;
    upper_bound=sample_mean+margin_of_error;

    contained=(lower_bound<=1/lambda)&&(upper_bound>=1/lambda); %boolean that returns 1 if the mean value is contained in the c.i.
    contained_counter=contained_counter+contained; %+1 to the counter
end

percentage=(contained_counter/M)*100; %calculating the percentage
fprintf('Percentage that the real mean lifespan is contained in the 95%% confidence interval: %f%%\n',percentage);
