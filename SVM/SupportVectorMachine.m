function espace=SupportVectorMachine()
    %% clear , close , clear console
    close all;
    clear ; 
    clc ;
    
    %% import data
    imageDir = fullfile('../Data/features/features_filtered/ALL/');
    filenames = dir(fullfile(imageDir, '*.mat'));
    features=zeros(numel(filenames),5850);
    Output=zeros(numel(filenames),1);
        for i=1:numel(filenames)
            path=strcat(filenames(i).folder,'/',filenames(i).name);
            im=load(path); 
            features(i,:)=im.local_feature_w;
            Output(i)=im.local_classe;
        end
        keyboard;
        t = templateSVM('Standardize',1,'KernelFunction','rbf','KernelScale','auto');
% t = templateSVM('Standardize',1,'KernelFunction','rbf');

% Mdl = fitcecoc(X,Output,'Learners',t,'FitPosterior',1)
[Mdl,opt] = fitcecoc(features,Output,'Learners',t,'OptimizeHyperparameters','auto');

espace=Mdl;
end