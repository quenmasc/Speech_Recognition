% Allow to record a sample of a word %
% Quentin MASCRET %
% Copyright 2017 %

function [V_im, Etiquette]=recorder(etiquette_name,time)
<<<<<<< HEAD
    recObj1= audiorecorder(16000,16,1);
    disp(etiquette_name)
=======
    recObj1= audiorecorder(8000,16,1);
    disp(strcat(etiquette_name))
>>>>>>> Word
    recordblocking(recObj1,time);
    disp('End of Recording.');
    V_im = getaudiodata(recObj1,'double');
    %V_im = son([find(son>0.01,1,'first'):find(son>0.01,1,'last')]);
    Etiquette=etiquette_name;
end