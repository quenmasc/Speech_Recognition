% Allow to record a sample of a word %
% Quentin MASCRET %
% Copyright 2017 %

function [V_im, Etiquette]=recorder(etiquette_name,time)
    recObj1= audiorecorder(8000,16,1);
    disp(strcat(etiquette_name))
    recordblocking(recObj1,time);
    disp('End of Recording.');
    V_im = getaudiodata(recObj1,'double');
    %V_im = son([find(son>0.01,1,'first'):find(son>0.01,1,'last')]);
    Etiquette=etiquette_name;
end