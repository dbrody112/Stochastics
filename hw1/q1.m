%% EpicQUESTion 1 
% X = event of a dice roll,
% Y = event of generating an ability score,
% Z = event of generating an ability score using the fun method
clc 
close all 
clear all
M = 5;
M = 1e6; % number of experiments to perform 
%% Part A
% $P(Y=18) = P(X=6)^3 = (1/6)^3 = 0.0046$

% 6^3 permutations
rolls = randi(6,3,M); % generate set of 3d6
net = sum(rolls,1); % sum rolls to get score
fprintf("Sampled probability of score 18: %f", sum(net==18)/M);

%% Part A theoretical
% Dice roll uniform distribution
pmf_X = ones(6, 1).*1/6;

% each dice roll independent
joint_pmf_X = ones(6, 6, 6).*(1/6^3);

% generate all permutations
[X1, X2, X3] = ndgrid(1:6); 
Y = X1 + X2 + X3;

pmf_Y = zeros(18, 1);
for y=3:18
    pmf_Y(y) = sum(joint_pmf_X(Y == y));
end
fprintf("Probability of score 18 given PMF: %f", pmf_Y(18));
figure; stem(pmf_X); title("PMF of 1d6");
figure; stem(pmf_Y); title("PMF of 3d6");
%% Part B 
% $P(Z=18) = P(Y)*3 = 0.0138$
rolls = randi(6,3,M,3); % generate 3 trials of 3d6
x = sum(rolls,1); % combine rolls for score 
y = sum(x==18,3); % calculate how many scores are 18
% Fraction of experiments resulting in score of 18
fprintf("Sampled probability of best of 3 score 18: %f", sum(y>0)/M);


%% Part B Theoretical
% Triple outer product,
% not sure if there's a more elegant way of doing this
joint_pmf_Y = pmf_Y*pmf_Y';
joint_pmf_Y = reshape(joint_pmf_Y(:)*pmf_Y', 18, 18, 18);

% generate all permutations
[Y1, Y2, Y3] = ndgrid(1:18); 
Z = max(cat(4, Y1, Y2, Y3), [], 4);

pmf_Z = zeros(18, 1);
for z=3:18
    pmf_Z(z) = sum(joint_pmf_Y(Z == z));
end
fprintf("Probability of best of 3 score 18 given PMF: %f", pmf_Z(18));
figure; stem(pmf_Z); title("PMF of best of 3d6");

%% Part C
% $P(A) = P(Z=18)^6 = 6.9068e-12$
%M = 5e7; %Tuned for 64GB RAM
M = 1e6;
N = 1e0;
n = 0;
for i = 0:N
    rolls = randi(6,3,M,6,'uint8'); % generate M best of 3 trials of 3d6
    rolls = sum(rolls,1); % get 3 scores 
    rolls = sum(rolls==18,3); % check if 18
    n = n + double(sum(rolls>0)==6); % increment the number of Fontaines
end
% Will almost always be zero
fprintf("Number of perfect humans found: %d\n", n);
fprintf("Probability of perfect human: %e\n", n/M);
fprintf("Number of trials: %e\n", M);

%% Part C GPU Compute
% Lets try using GPU 
M = 1e6;
N = 1e3;
n = 0;
for i = 0:N
    rolls = randi(6,3,M,6,'uint8','gpuArray'); % generate M best of 3 trials of 3d6
    rolls = sum(rolls,1); % get 3 scores 
    rolls = sum(rolls==18,3); % check if 18
    n = n + double(sum(rolls>0)==6); % increment the number of Fontaines
end
fprintf("Number of perfect humans found: %d\n", n);
fprintf("Probability of perfect human: %e\n", n/M);
fprintf("Number of trials: %e\n", M);

%% Part C theoretical
fprintf("Probability of ideal character from PMF: %e", pmf_Z(18)^6);

%% Part D
% This part is not correct 
% 9 must be the greatest value in the best of 3 case
clc
%M = 1e6;
M = 1e4;
n = 0;
for i = 0:M
    rolls = randi(6,3,3,6);
    x = sum(rolls,1);
    y = sum(x==18,2);
    n = n + double(sum(y>0)==6);
end
n
n/M

%% Part D revised
%M=1e8; %~60gb array
rolls = randi(6,3,M,6);
x = sum(rolls,1);
y = sum(x==18,3);
% Fraction of experiments resulting in at least one 18
sum(sum(y,4)==6)/M

%% Part D GPU Compute
M = 1e6;
N = 1e4;
n = 0;
for i = 0:N
    rolls = randi(6,3,M,6,'uint8','gpuArray'); % generate M best of 3 trials of 3d6
    rolls = sum(rolls,1); % get 3 scores 
    rolls = sum(rolls==18,3); % check if 18
    n = n + double(sum(rolls>0)==6); % increment the number of Fontaines
end
fprintf("Number of perfect humans found: %d\n", n);
fprintf("Probability of perfect human: %e\n", n/M);
fprintf("Number of trials: %e\n", M);

%% Part D theoretical
fprintf("Probability of totally average character from PMF: %e", pmf_Z(9)^6);
