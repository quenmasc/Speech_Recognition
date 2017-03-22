function sigma=Covariance_cluster(data)
    [n,~]=size(data);
    sigma=zeros(n,1);
    for i=1:n
        sigma(i)= var(data(i,:));
    end
end