function E=Expectation(data,mu,sigma,weight, index)

    %% calculation of denominator of Expectation
    total_prob = Probability_of_X(data,mu,sigma,weight);
    %% calculation of numerator of Expectation
    PX=(weight(index)*ProbabilityDensityFunction(data,mu(:,index),sigma(:,index)));
    
    %% exit
    E=PX/total_prob;
end