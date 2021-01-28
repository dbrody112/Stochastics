%% EpicQUESTion 1 
M = 5;
M = 1e6;
%% Part A
% P(Y=18) = P(X=6)^3 = (1/6)^3 = 0.0046
% 6^3 permutations
rolls = randi(6,3,M);
net = sum(rolls,1);
% What fraction of experiments result in 18?
sum(net==18)/M

%% Part B 
% P(Z=18) = P(Y)*3 = 0.0138
rolls = randi(6,3,M,3);
x = sum(rolls,1);
y = sum(x==18,3);
% Fraction of experiments resulting in at least one 18
sum(y>0)/M

%% Part C
% P(A) = P(Z=18)^6 = 6.9068e-12
% Array would be too large
M = 1e4;
n = 0;
for i = 0:M
    rolls = randi(6,3,3,6);
    x = sum(rolls,1);
    y = sum(x==18,2);
    n = n + double(sum(y>0)==6);
end
% Will almost always be zero
n
n/M

%% Part D
% 9 must be the greatest value in the best of 3 case
clc
M = 1e6;
n = 0;
parfor i = 0:M
    rolls = randi(6,3,3,6);
    x = sum(rolls,1);
    y = sum(x==18,2);
    n = n + double(sum(y>0)==6);
end
n
n/M

%% Part D revised
%M=1e8; %~60gb array
rolls = randi(6,3,M,3,6);
x = sum(rolls,1);
y = sum(x==18,3);
% Fraction of experiments resulting in at least one 18
sum(sum(y,4)==6)/M