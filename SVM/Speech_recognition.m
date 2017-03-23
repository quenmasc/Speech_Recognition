function r=Speech_recognition(Mdl)
    %% addpath
    addpath('../ressources');
    addpath('../VAD');
    addpath('../Feacture_Extraction_File');
    Init=environment_analysis();
    [segments,~,~,fs]=Vocal_algorithm_dectection(Init);
    labelsave=[];
    for i=1:length(segments)
    [features]=SetFeactureExtraction(cell2mat(segments(i)),fs,15,5);
    [label,score] = predict(Mdl,features);
    labelsave=[labelsave,label];
    end

    r=labelsave;
end
