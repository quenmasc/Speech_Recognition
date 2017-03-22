function sigma=compute_sigma_clusters(data,mu,sigma,weight,index)
   % define local variables
    [~,cluster]=size(data);
    P_xi=0;
    P=0;
    
    % loop
    for i=1:cluster
        P_xi=P_xi+Expectation(data(:,i),mu,sigma,weight, index)*(data(:,i)-(mu(:,index))).^2;
        P=P+Expectation(data(:,i),mu,sigma,weight, index);
    end
    sigma=P_xi/P;
end