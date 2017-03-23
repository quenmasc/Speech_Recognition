function PlotGMM(model)
    if (size(model.mu,1)>2)
        disp('Error of dimension');
        return;
    else
        obj = gmdistribution((model.mu).',model.sigma,model.weight);
        ezsurf(@(x,y)pdf(obj,[x y]),[-5 5],[-5 5]);
    end
        
end