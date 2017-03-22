%% MASCRET Quentin - Copyright 2017 
% This function allow to extract speech in a recording using Teager
% Kaiser Energy Method, Entropy and adaptive threshold.
%
%% INPUT 
% Signal = vector of 1 x n dimension
% window_ms= length of frame in ms
% step_ms = step between two windows in ms
% fs = sample rate 
%
%% OUTPUT 
% Segments : segments of speech extraction
%
function [segments,th_high]=speech_extraction()

    % clearing and closing
    clear;
    close all;
    clc;
    
    % variables
    nbin=100 ;  % fixed by default (need to be between 50 and 100 for best accuracy of adaptive threshold)
    weight=2;
    fs=16000; % fixed by default (need to be over 12 000 Hz according to Shanon Theorem
    time=3; % time of  recording fixed to 5s 
    step_ms= 5 ;% fixed by default 
    window_ms = 25; % fixed by default
    window_reshape=floor(window_ms);
    % conversion ms to samples
    step_sample =floor(step_ms*10^-3*fs);
    window_sample=floor(window_ms*10^-3*fs);
    
    % Recording 
    
    [Signal,vv]=recorder('Comptez de un à 10',time);
    disp(fs);
    Signal=Signal(400:end);
    % Calculation of TKE in order to decrease noise in the recorder
    TKE=Teager_Kaiser_Energy(Signal);
    
    %% PLOT of TKE and genuine Signal
     figure(1);
     hold on;
     plot(Signal); 
     plot(TKE);  
     hold off; 
     legend('Genuine Signal','Teager Kaiser Energy');
     title('Comparison between genuine signal and Teager Kaiser Energy Signal')
     xlabel(strcat('Samples at the sample rate : ',num2str(fs),' Hz'));
    
    % Calculation of entropy with our previous TKE for best accuracy
    entropy=entropy_estimation(TKE, window_ms,step_ms,fs);  
    figure(2);
    plot(entropy);
    title('Entropy');
    xlabel('Frame');
    ylabel('Amplitude absolue');
    disp(length(entropy));
    
    % Calculation of adaptive threshold in order to create Flags vector 
    th_high=adaptive_threshold(entropy,window_reshape, nbin);
    
    zrc=zero_cross_rate(Signal,window_ms, step_ms, fs);
    
    %% PLOT 
    Flags=(entropy>th_high);
    figure(3)
    plot(+Flags);
    % Generation of segments 
    [segments, Limits, Flags_correct]=Segmentation_of_voiced_on_input_signal(Flags,Signal,weight,window_sample,step_sample);

    % Flags Vector 
    figure(4);
    plot(zrc);
    title('zero crossing rate');
    
    %% PLOT RESULTS
    figure(5)
    time = 0:1/fs:(length(Signal)-1) / fs;
    for (i=1:length(segments))
        hold off;
        P1 = plot(time, Signal); set(P1, 'Color', [0.7 0.7 0.7]);    
        hold on;
        for (j=1:length(segments))
            if (i~=j)
                timeTemp = Limits(1,j)/fs:1/fs:Limits(2,j)/fs;
                P = plot(timeTemp, segments{j});
                set(P, 'Color', [0.4 0.1 0.1]);
            end
        end
        timeTemp = Limits(1,i)/fs:1/fs:Limits(2,i)/fs;
        P = plot(timeTemp, segments{i});
        set(P, 'Color', [0.9 0.0 0.0]);
        axis([0 time(end) min(Signal) max(Signal)]);
        sound(segments{i}, fs);
        clc;
        fprintf('Playing segment %d of %d. Press any key to continue...', i, length(segments));
        pause
    end
    clc
    hold off;
    P1 = plot(time, Signal); set(P1, 'Color', [0.7 0.7 0.7]);    
    hold on;    
    for (i=1:length(segments))
        for (j=1:length(segments))
            if (i~=j)
                timeTemp = Limits(1,j)/fs:1/fs:Limits(2,j)/fs;
                P = plot(timeTemp, segments{j});
                set(P, 'Color', [0.4 0.1 0.1]);
            end
        end
        axis([0 time(end) min(Signal) max(Signal)]);
    end
    title('Signal vs Segments');
end