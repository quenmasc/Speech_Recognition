%% MASCRET Quentin - Copyright 2017
% 2017-03-18

function [index, mu]=kmean(data,clusters, loop)
    %% initialization
    % choose points of feature as the starting center
    [n,m]=size(data);
    random_number=randperm(m);
    random_number=random_number(1:clusters);
    mu=data(:,random_number);
    %% allocation
    index=zeros(m,1);
    distance=zeros(m,clusters);
    old_center=zeros(n,clusters);
    %% local parameters
    iter=0;
    %% Loop
    while iter<loop
        % define old center as the new center
        if (old_center==mu)
            break;
        else
            old_center=mu;
        end
        for i=1:clusters
            distance(:,i)=sum((data-repmat(mu(:,i),1,m)).^2,1);
        end
        % find min and assign it to closest mean
        [~,index] = min(distance,[],2);
         
        % calculate the new cluster centres 
        for i = 1:clusters
            mu(:,i) =mean(data(:,index == i),2);
        end
        iter=iter+1;
    end
end