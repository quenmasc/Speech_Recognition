function G_M_M=GaussianMixtureModel(data,mu,sigma,weight,label)
   [n,m]=size(data);
   [~,cluster]=size(mu);
   %% allocation
   GMM=zeros(n,1);
   for j=1:cluster
       Cov=zeros(n);
       for k=1:n
           for l=1:n
               if(k==l)
                    Cov(k,l)=sigma(k,1);
               else
                    Cov(k,l)=mean(data(k,:).'.*data(l,:).')-mean(data(k,:))*mean(data(l,:));
               end      
           end
       end
       keyboard;
       for i=1:m
                meanDiff = bsxfun(@minus, data(:,i), mu(:,j));
                GM=weight(j)*(1./sqrt((2*pi)^(n)*det(Cov)))*exp((-1/2)*(transpose(meanDiff)*inv(Cov).*meanDiff));
                GMM=GMM+GM;
       end
   end
   keyboard;
   G_M_M=0;
end