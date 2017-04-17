function [Mdl_short, Mdl_long, Mdl_classe]=SupportVectorMachine()
    %% clear , close , clear console
    close all;
    clear ; 
    clc ;
    
    %% import data
    imageDir = fullfile('../Data/features/features_saved/ALL/');
    filenames = dir(fullfile(imageDir, 'quentin_8000*.mat'));
    features=zeros(numel(filenames),3900);
    Output=zeros(numel(filenames),1);
    Classe=zeros(numel(filenames),1);
        for i=1:numel(filenames)
            path=strcat(filenames(i).folder,'/',filenames(i).name);
            im=load(path); 
            features(i,:)=im.local_feature;
            Output(i)=im.local_classe;
            if (Output(i)==8 || Output(i)==9)
                Classe(i)=3;
            elseif (Output(i)==1 || Output(i)==2 || Output(i)==7)
                Classe(i)=2;
            else
                Classe(i)=1;
            end
        end
        t = templateSVM('Standardize',1,'KernelFunction','rbf','KernelScale','auto');
% t = templateSVM('Standardize',1,'KernelFunction','rbf');

% Mdl = fitcecoc(X,Output,'Learners',t,'FitPosterior',1)
[Mdl_classe,opt_classe] = fitcecoc(features,Classe,'Learners',t,'OptimizeHyperparameters','auto');
disp('First SVM done');
new_feature=features(Classe==1,1:3000);
[Mdl_short,opt_short] = fitcecoc(new_feature,Output(Classe==1),'Learners',t,'OptimizeHyperparameters','auto');
disp('Second SVM done');
[Mdl_long,opt_long] = fitcecoc(features(Classe==2,:),Output(Classe==2),'Learners',t,'OptimizeHyperparameters','auto');



end