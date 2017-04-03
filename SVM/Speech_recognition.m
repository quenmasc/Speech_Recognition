function r=Speech_recognition(Mdl_classe,Mdl_short,Mdl_long)
    %% addpath
    addpath('../Ressources');
    addpath('../Vocal_Activity_Detection_Algorithm');
    addpath('../Feature_Extraction/');
    Init=environment_analysis();
    [segments,~,~,fs]=Vocal_algorithm_dectection(Init,2,16000);
    labelsave=[];
    for i=1:length(segments)
    [features,~]=SetFeactureExtraction(cell2mat(segments(i)),fs,15,5);
    [label,score] = predict(Mdl_classe,features);
    if (label==1)
        new_feature=features(1,1:3000);
        [label,score] = predict(Mdl_short,new_feature);
    else
        [label,score] = predict(Mdl_long,features);
    end
    labelsave=[labelsave,label];
    end

    r=labelsave;
end
