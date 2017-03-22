%% MASCRET Quentin - Copyright 2017 %%
% This function is based on an analysis. First of all, I saw that during
% stray time, attack of Wang & Al. 2011 algorithm parameter will be short
% less than 4 windows over my adaptive threshold. Moreover, peak are
% numerous and by the way have a short attack. My idea is to create a kind
% of adaptative gate. First of all, the goal will be to compare each attack
% peak under threshold with a fixed attack (4 windows seem interesting).
% Then, if attack peak is under attack threshold, the last adaptive
% threshold is change to the minimum of the studied peak. I repeat this
% operation as long as I have short attack peak. In the case where peak
% attack over attack threshold, gate stay opened as long as it is over
% threshold. 
% Moreover, I use input signal envelope in order to accurate my algorithm. Indeed, if you
% speak very flastly, attack is too fast and you speach is analysed as a
% stray time. 
%% INPUT %%
% Parameter : Wang & Al. 2011 algorithm parameter (check EndPoint.m function)
% Threshold : adaptive threshold (check adaptive_threshold.m function);
% flag : input flag which compare Parameter to threshold 

%% OUTPUT %%
% Flags : new flags properties excluding stray time.

%% FUNCTION %%
function Flags=impulsion_removal(Signal,flag, entropy)
    % initialization
    w=1;
    i=1;
    j=1;
    c=0;
   
    
    % variables
    Flags=flag;
    window_min=10;
    
    % internal function
     windows=@(y)((window_min*y));
     y=@(difference,ymax)(difference./ymax);
    % First loop for allocation
     while(w<=length(Signal)-1)
        if(flag(w)==0 && flag(w+1)==1)
            c=c+1;
        end
        w=w+1;
     end
     % allocation
    count=zeros(numel(Signal),c);
    w=1;
    % Loop
    while(w<=length(Signal))
        if(flag(w)~=0)
            count(i,j)=w;
            i=i+1;
        end
        if(w>2)
            if(flag(w-1)==1 && flag(w)==0)
                j=j+1;
                i=1;
            end
        end
        w=w+1;
    end
    count(count~=0);
    % allocation 
    beg_end=zeros(2,c);
    beg_end(1,:)=count(1,:);
    for i=1:size(count,2)
        for j=1:size(count,1)
            if(count(j,i)~=0)
                beg_end(2,i)=count(j,i);
            end
        end
    end
    
    % size max 
    size_frame=beg_end(2,:)-beg_end(1,:);
    size_max=max(beg_end(2,:)-beg_end(1,:));
    
    % allocation 
    local_maxima=zeros(c,size_max);
    position_maxima=zeros(c,size_max);
    local_minima=zeros(c,size_max);
    position_minima=zeros(c,size_max);
    
    % Loop to find local maxima of each subframe
    for i=1:c
        if(size_frame(i)>5)
            [maxima,position]=findpeaks(entropy(beg_end(1,i):beg_end(2,i)));
            for j=1:length(maxima)
                local_maxima(i,j)=maxima(j);
                position_maxima(i,j)=beg_end(1,i)+position(j);
            end;
        else
            local_maxima(i,1)=max(entropy(beg_end(1,i):beg_end(2,i)));
            position_maxima(i,1)=find(entropy==local_maxima(i,1));
        end
    end
    
    % Loop to find local minima of each subframe
    SignalInv = 1.01*max(entropy) - entropy;
     for i=1:c
        if(size_frame(i)>5)
            [minima,position]=findpeaks(SignalInv(beg_end(1,i):beg_end(2,i)));
            for j=1:length(minima)
                position_minima(i,j)=beg_end(1,i)+position(j);
                local_minima(i,j)=entropy(position_minima(i,j));
            end;
        else
            local_minima(i,1)=min(entropy(beg_end(1,i):beg_end(2,i)));
            position_minima(i,1)=find(entropy==local_minima(i,1));
        end
     end
    %% add the first value of the subframe (if this value is the same as the
    %% first min, don't change it, else add at the first place
    % allocation
    local_min=zeros(c,size_max+1);
    position_min=zeros(c,size_max+1);
    for i=1:c
        if(find(entropy==local_minima(i,1))~=beg_end(1,i))
            position_min(i,:)=[beg_end(1,i), position_minima(i,:)];
            local_min(i,:)=[entropy(beg_end(1,i)) , local_minima(i,:)];
            
        end
        
    end
    % keep only the peaks of each local_maxima subframe
    maxima=zeros(c,size_max);
    position=zeros(c,size_max);
    count=0;
    p=1;
    flag=0;
    for i=1:c
        for j=1:size_max-2
            if(local_maxima(i,j)~=0 && local_maxima(i,j+1)==0 && j<=1)
                maxima(i,p)=local_maxima(i,p);
                position(i,p)=position_maxima(i,p);
                break;
            else
                if(local_maxima(i,j)==0)
                    break;
                else
                    if (local_maxima(i,j)<=local_maxima(i,j+1))
                        count=count+1;
                        flag=0;
                    end
                    if (local_maxima(i,j)>local_maxima(i,j+1) && j==1)
                        count=1;
                    end
                    if (local_maxima(i,j)>local_maxima(i,j+1))
                        flag=1;
                    end
                
                    if (count~=0 && flag==1)
                        maxima(i,p)=local_maxima(i,j);
                        position(i,p)=position_maxima(i,j);
                        p=p+1;
                        count=0;
                    end
                end
            end
        end
        p=1;
    end
    
    %% allocation
    mini=zeros(c,size_max);
    position_mini=zeros(c,size_max);
    p=2;
    for i=1:c
        mini(i,1)=local_min(i,1);
        position_mini(i,1)=position_min(i,1);
        for j=2:size_max-3
                if(local_min(i,j)~=0 && local_min(i,j+1)==0 && j<=2)
                    mini(i,p)=local_min(i,j);
                    position_mini(i,p)=position_mini(i,j);
                    break;
                else
                    if(local_min(i,j)==0)
                        break;
                    else
                        if (local_min(i,j)>=local_min(i,j+1))
                            count=count+1;
                            flag=0;
                        end
                        if (local_min(i,j)<local_min(i,j+1) && j==2)
                            count=1;
                        end
                        if (local_min(i,j)<local_min(i,j+1))
                            flag=1;
                        end

                        if (count~=0 && flag==1)
                            mini(i,p)=local_min(i,j);
                            position_mini(i,p)=position_min(i,j);
                            p=p+1;
                            count=0;
                        end
                    end
                end
        end
        p=2;
    end
    attack=zeros(c,size_max);
    % loop to determinate attack
    
    for i=1:c
        for j=1:size_max
            if(mini(i,j)~=0 && maxima(i,j)~=0)
                
                attack(i,j)=position(i,j)-position_mini(i,j);
            else
                break;
            end
        end
    end
    for i=1:c
        if(attack(i,1)<windows(maxima(i,1)))
            Flags(beg_end(1,i):beg_end(2,i))=0;
        end
    end
   keyboard;
end
