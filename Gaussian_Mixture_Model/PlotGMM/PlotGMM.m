function PlotGMM(model,Range)
    if (size(model.mu,1)>2)
        disp('Error of dimension');
        return;
    elseif (length(Range)<2)
        disp('Error ! Range need to have 2 values');
        return;
    else
        obj = gmdistribution((model.mu).',model.sigma,model.weight);
        ezsurf(@(x,y)pdf(obj,[x y]),Range,Range);
    end
        
end