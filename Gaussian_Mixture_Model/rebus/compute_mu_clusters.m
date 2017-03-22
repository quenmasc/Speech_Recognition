function mu=compute_mu_clusters(data,mu,sigma,weight,index)

    % define local variables
    [~,cluster]=size(data);
    P_xi=0;
    P=0;
    % loop
    for i=1:cluster
        P_xi=P_xi+Expectation(data(:,i),mu,sigma,weight, index)*data(:,i);
        P=P+Expectation(data(:,i),mu,sigma,weight, index);
        
    end
    mu=P_xi/P;
end