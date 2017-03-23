function [index,model]=Gaussian_mixture_model(feature, number_of_clusters)
    %% path
    addpath('../Kmean');
    addpath('../../Ressources');
    % variables
    loop=10; % by default
    max_iter=100;
%   [n,m]=size(feature);
    
    % become to initialize GMM with k-means 
    [index,mu]=kmean(feature,number_of_clusters,loop);
    init.label=index;
    init.mu=mu;
    %% initialize mean, covariance and weight
    [R, model_output]=Initialization(feature,init,max_iter);
    convergence=model_output.convergence;
    for i=2:max_iter
        [~,index]= max(R,[],2); % define a cluster label to each data
        R = R(:,unique(index)); % remove empty clusters
        model=Maximization(feature,R);
        [R,convergence(i)]=Expectation(feature,model);
        if abs(convergence(i)-convergence(i-1)) < 1e-6*abs(convergence(i))
            break;
        end
    end
end

function [R,model_input]=Initialization(data,init,max_iter)
    label=init.label;
    mu=init.mu;
    n = size(data,2);
    d = size(data,1);
    k = size(mu,2);
    R = full(sparse(1:n,label,1,n,k,n));
    nk = sum(R,1);
    weight = nk/n;
    sigma = zeros(d,d,k);
    r = sqrt(R);
    for i = 1:k
        Xo = bsxfun(@minus,data,mu(:,i));
        Xo = bsxfun(@times,Xo,r(:,i)');
        sigma(:,:,i) = Xo*Xo'/nk(i)+eye(d)*(1e-6);
    end
    convergence = -inf(1,max_iter);
    model_input.weight=weight;
    model_input.mu=mu;
    model_input.sigma=sigma;
    model_input.convergence=convergence;
end

function [R,convergence]=Expectation(data,model)
    weight=model.weight;
    mu=model.mu;
    sigma=model.sigma;
    
    n = size(data,2);
    k = size(mu,2);
    R = zeros(n,k);
    for i = 1:k
         R(:,i)=loggausspdf(data,mu(:,i),sigma(:,:,i));
    end
    R=bsxfun(@plus,R,log(weight)); 
    cc = ComputeLogSumExp(R);
    convergence=sum(cc)/n; %% Log Likelihood (LE)
    R= exp(bsxfun(@minus,R,cc));
    
end
function model=Maximization(data,R)
    [d,n] = size(data);
    k = size(R,2);
    nk = sum(R,1);
    weight = nk/n;
    mu = bsxfun(@times,data*R,1./nk);
    sigma = zeros(d,d,k);
    r = sqrt(R);
    for i = 1:k
        Xo = bsxfun(@minus,data,mu(:,i));
        Xo = bsxfun(@times,Xo,r(:,i)');
        sigma(:,:,i) = Xo*Xo'/nk(i)+eye(d)*(1e-6);
    end

    model.mu = mu;
    model.sigma = sigma;
    model.weight = weight;
    
end

function R = loggausspdf(data,mu,sigma)
    d=size(data,1);
    meandiff=bsxfun(@minus,data,mu);
    R=-0.5*(sum(meandiff.*(sigma\meandiff),1)+d*log(2*pi)+log(det(sigma)));
end

function z=ComputeLogSumExp(data)
    %% max
    a=max(data,[],2);
    z=a+log(sum(exp(bsxfun(@minus,data,a)),2));
    %% to avoid inf value
    i = isinf(a);
    if any(i(:))
       z(i) = a(i);
    end
   
end
