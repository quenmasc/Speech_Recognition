%% MASCRET Quentin - Copyright 2017
%% 03.02.17
% This function allows to set feactures of all segment find by the VAD
% algorithm. 
%% Input 
% Segments : Segments find by VAD algorithm
% fs : sample rate (Hz)
% window_ms : length of studied window in ms 
% stepMs : overlap in ms 

%% Output 
% Features is a matrix N_feature by M_window. Features appear as follow :
% features (1,:)= Log Energy
% features(2:13,:)= MFCC
% features (14,:)=  Delta Log Energy
% features(15:26,:)=Delta MFCC
% features (27,:)= Delta DeltaLog Energy
% features(28:39,:)=Delta Delta MFCC
function [features]=SetFeactureExtraction(Segments,fs,window_ms,step_ms)
    %% add path to folder
    addpath('../Ressources');
    
    % ms to sample
    window_sample =floor(window_ms*10^-3*fs);
    step_sample = floor(step_ms*10^-3*fs);
    
    % local variable
    number_of_feature=39;
    % nbFrame 
    nbFrame = floor((numel(Segments)-window_sample)/step_sample);
    nbFrameMax=150;
    Lmax=nbFrameMax*number_of_feature;
    % Allocation
    features =zeros(number_of_feature,nbFrame);
    
    %% FEATURES %%
    features(1,:)=log(sum(short_time_fourier_transform(Segments, window_ms, step_ms, fs)));
    features(2:13,:)=MFCC(Segments,window_ms,step_ms,fs);
    features(14:26,:)=Delta_feature(features(1:13,:));
    features(27:end,:)=Delta_feature(features(14:26,:));
    features=reshape(features,1,[]);
    if (length(features)<Lmax)
        features=[features , zeros(1,Lmax-length(features))];
    end
    
end
