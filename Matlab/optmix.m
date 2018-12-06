X = rand(4, 100); % rand conveniently returns values between 0 and 1, useful to shrink the starting scope of the walk
x0 = [0,0.2,0.5,0];

R = 1;

%% Constrained optimization
ub = [2,2,2,2];
lb = [0,0,0,0];
xCon = fmincon(@intersectionArea, X(:,1), [], [], [], [], lb, ub);


xCon
intersectionArea(xCon)

%% Unconstrained with random-walk
xUnc = 1; %area will return negative, starting xUnc arbitrarily at 1 to ensure it reduces

for i = 1:50
    xTmp = fminunc(@intersectionArea, X(:,i));
    if xUnc > xTmp
        xUnc = xTmp;
    end
end


% X
% intersectionArea(X)
% 
% xCon
% intersectionArea(xCon)
%%
xUnc
0-intersectionArea(xUnc)