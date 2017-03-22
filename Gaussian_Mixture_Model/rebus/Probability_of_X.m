function PX = Probability_of_X(X,mu,sigma,weight)
PX = 0;
[~,c] = size(mu);
for i=1:c
    PX = PX + weight(i)*ProbabilityDensityFunction(X,mu(:,i), sigma(:,i));
end;