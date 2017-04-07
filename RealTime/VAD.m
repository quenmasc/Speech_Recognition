%% MASCRET Quentin - Copyright 2017 
% This function allow to extract speech in a recording. 
%% DATE 02-24-17
%% Maj 1.2
%
%% INPUT 
% Signal = vector of 1 x n dimension -> mono
% window_ms= length of frame in ms
% step_ms = step between two windows in ms
% fs = sample rate 
%
%% OUTPUT 
% Segments : segments of speech extraction
%
function [segments]=VAD(Init_mfcc,Init_entropy,time_record,fs)

    %% add path
    addpath('source/');
    % variables
    weight=2;
    step_ms= 5;% fixed by default 
    window_ms = 15; % fixed by default
    

    % record
    label2=strcat('You can speak for ~',num2str(time_record),' s.');
    [Signal,~]=recorder(label2,time_record);
    
    % conversion ms to samples
    step_sample =floor(step_ms*10^-3*fs);
    window_sample=floor(window_ms*10^-3*fs);
    nbFrame=floor((numel(Signal)-window_sample)/step_sample);
    L=nwindow_sample;
    N=2^(nextpow2(window_sample));
    Signal=Signal-mean(Signal);
    Signal=Signal/max(abs(Signal));
   
    %% Initialization
    background_mfcc=Init_mfcc;
    background_entropy=Init_entropy;
    % buffer for entropy mean
    buffer_entropy=zeros(1,20);
    buffer_mfcc=zeros(1,20);
    buffer_th_mfcc=zeros(1,20);
    i=1;
    flag_control=0;
    flag_interruption=0;
    buffer_label_all=zeros(1,numel(Signal));
    %% tool  %%
    %% Pre-traitment in order to suppress percussive noise
    for w=1:nbFrame
        localFrame =Signal(1+(w-1)*step_sample):((w-1)*step_sample+window_sample);
        
        %% Discrete Fourier Transform
        stft=abs(fft(localFrame.* hamming(L),N));
        
        %% MFCCs
        coeff=mfcc(stft,fs);
        
        %% Entropy
        entropy=spectral_entropy(localFrame,N);
        
        %% background noise vector
        [background_mfcc, distance_mfcc]=updateBackgroundVectorAndDistance(background_mfcc,coeff,0.95);
        [background_entropy, distance_entropy]=updateBackgroundVectorAndDistance(background_entropy,entropy,0.9);
        
        %% threshold
        th_mfcc=sigmoide_function(10,distance_mfcc);
        
        %% for the first 20 frame 
        if (i<=20 && flag_interruption==0)
            buffer_entropy(i)=distance_entropy;
            buffer_mfcc(i)=distance_mfcc;
            buffer_th_mfcc(i)=th_mfcc;
            i=1+i;
        else
            flag_control=1;
            i=1;
        end
        if(flag_control==1 && flag_interruption==0)
            if (flag_interruption==0)
                th_entropy=mean(buffer_mean_entropy)+3*std(buffer_mean_entropy);
                buffer_th_entropy_init=repmat(th_entropy,1,20);
                flag_interruption=1;
            end
            
            buffer_label=(buffer_mfcc>=buffer_th_mfcc)&(buffer_entropy>=buffer_th_entropy_init);
        end
        %% end 20 first frames
        %% for the next frames
        if (i<=20 && flag_interruption==1)
            buffer_entropy(i)=distance_entropy;
            buffer_mfcc(i)=distance_mfcc;
            buffer_th_mfcc(i)=th_mfcc;
        else
            buffer_th_entropy=update_treshold(buffer_th_entropy_init,0.96,buffer_entropy);
            buffer_label=(buffer_mfcc>=buffer_th_mfcc)&(buffer_entropy>=buffer_th_entropy);
            buffer_th_entropy_init=buffer_th_entropy;
            i=1;
        end
        
        buffer_label_all=[buffer_label_all buffer_label];
        %% end frames
    end

    %% Segments
    [segments, ~, ~, ]=Segmentation_of_voiced_on_input_signal(+buffer_label_all,Signal,weight,window_sample,step_sample,fs);


end

