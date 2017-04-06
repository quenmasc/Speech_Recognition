function d=correlation_distance(x,y)
    % variable
    [~,C]=size(x);
    
    % covariance
    CovXX=sum((x-mean(x)*ones(C,1)).^2)/(length(x)-1);
    CovYY=sum((y-mean(y)*ones(C,1)).^2)/(length(y)-1);
    CovXY=sum((x-mean(x)*ones(C,1)).*(y-mean(y)*ones(C,1)))/(length(x)-1);
    r_xy=CovXY/sqrt(CovYY*CovXX);
    d=1-r_xy;
end