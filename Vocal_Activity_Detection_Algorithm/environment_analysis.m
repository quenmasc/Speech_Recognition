function Init=environment_analysis()
    %% addpath
    addpath('../ressources');
    
    %% code
    time_init=1;
    label1='';
    [Init,~]=recorder(label1,time_init);
    Init=Init(400:end);
    Init=Init-mean(Init);
    Init=Init/max(abs(Init));
end