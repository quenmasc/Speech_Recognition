function [weight,label] = Cluster_belonging(data,Mu)
    % local variables 
    [~,m] = size(data);
    [~,clusters] = size(Mu);
    
    % initialization
    weight(1:clusters) = 0;
    label(1:m) = 0;

    % allocation
    Distance=zeros(m,clusters);
    for i=1:m
        for j = 1:clusters
            Distance(i,j) = sqrt(dot(data(:,i)-Mu(:,j),data(:,i)-Mu(:,j)));
        end
    end

    for i=1:m
        [~,idx] = min(Distance(i,:));
        weight(idx) = weight(idx)+1;
        label(i) = idx;
    end

    weight = weight/m;
end