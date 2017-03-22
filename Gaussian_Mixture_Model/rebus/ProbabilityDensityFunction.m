function gaussian=ProbabilityDensityFunction(X,mu,sigma)
    PDF= exp(-0.5 * ((X - mu)./sigma).^2) ./ (sqrt(2*pi) .* sigma);
    [~,m]=size(PDF);
    
    %% initialisation 
    gaussian=0;
    
    %% lopp
    for i=1:m
        gaussian=gaussian+PDF(i);
    end
    gaussian=gaussian/m;
end