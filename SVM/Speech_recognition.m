function [r]=Speech_recognition(Mdl_classe,Mdl_short,Mdl_long)
    %% addpath
    addpath('../Ressources');
    addpath('../Vocal_Activity_Detection_Algorithm');
    addpath('../Feature_Extraction/');
    Init=environment_analysis();
    [segments,~,~,fs]=Vocal_algorithm_dectection(Init,2,8000);
    labelsave=[];
    for i=1:length(segments)
    [~,features]=SetFeactureExtraction(cell2mat(segments(i)),fs,25,10);
    [label,score] = predict(Mdl_classe,features);
    if (label==1)
        new_feature=features(1,1:3000);
        [labels,score] = predict(Mdl_short,new_feature);
    else
        [labels,score] = predict(Mdl_long,features);
    end
    labelsave=[labelsave,labels,label];
    end

    r=labelsave;
end
