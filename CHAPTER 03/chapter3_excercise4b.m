%Alexandros Fotiadis AEM:10392
clear all;

% Voltage break threshold data
data = [41 46 47 47 48 50 50 50 50 50 50 50 ...
        48 50 50 50 50 50 50 50 52 52 53 55 ...
        50 50 50 50 52 52 53 53 53 53 53 57 ...
        52 52 53 53 53 53 53 53 54 54 55 68];

% Null hypothesis: The variance is 5^2 kV^2
sigma_null = 5^2;

% Perform the variance test and calculating 95% c.i.
[h1, p1,c1] = vartest(data, sigma_null);

fprintf('95%% Confidence interval for variance: (%.4f,%.4f)',sqrt(c1));

% Set the significance level (alpha)
alpha = 0.05;

% Perform the hypothesis test and calculating 95% c.i.
if h1 == 1
    fprintf('Reject the null hypothesis: The variance is not (5 kV)^2.\n');
else
    fprintf('Fail to reject the null hypothesis: The variance is (5 kV)^2.\n');
end

fprintf('p-value: %f\n', p1); %print the p-value of the variance hypothesis test

[h2,p2,c2]=ttest(data,52); %Perform the hypothesis test for mean value and calculating 95% c.i.

fprintf('95%% Confidence Interval for mean value: (%.4f,%.4f)\n',c2);

if h2==1
    fprintf('Reject the null hypothesis: Mean Value is not 52kV\n');
else
    fprintf('Fail to reject the null hypothesis: Mean Value is 52kV\n');
end

fprintf('p-value: %f\n', p2); %print the p-value of the mean value hypothesis test

% Perform the chi-squared goodness-of-fit test against a normal distribution
[h, p] = chi2gof(data);

% Display the results
fprintf('Chi-squared goodness-of-fit test:\n');
fprintf('H0: The data follows a normal distribution.\n');
fprintf('H1: The data does not follow a normal distribution.\n');
fprintf('p-value: %f\n', p);

if h == 0
    fprintf('Do not reject the null hypothesis; the data follows a normal distribution.\n');
else
    fprintf('Reject the null hypothesis; the data does not follow a normal distribution.\n');
end

