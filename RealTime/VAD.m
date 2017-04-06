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
function [segments]=VAD(Init,time_record,fs)

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
   % Signal=Signal-mean(Signal);
   % Signal=Signal/max(abs(Signal));
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
        
        %% flags
        
        
    end
    
    th=sigmoide_function(10,endpoint);
    th_e_noise=mean(entropy(1:20))+3*std(entropy(1:20));
    th_e=variable_threshold(entropy,th_e_noise,0.96);
 
    flags=(endpoint>th)&(entropy>th_e);

    

    Flags_k=flags;
    %% Segments
    [segments, Limits, ~, ]=Segmentation_of_voiced_on_input_signal(Flags_k,Signal,weight,window_sample,step_sample,fs);


end

