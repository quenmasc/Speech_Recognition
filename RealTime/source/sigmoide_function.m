function seuillage=sigmoide_function(lambda,feature)
        seuillage=1/(5+exp(-lambda*feature));
end