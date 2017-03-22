%% Quentin MASCRET - Copyright 2017 %%
%% MAJ impulsion_removal - 02.27.17

function Flags=remove_impulsion(Signal, flags)
    
     % initialization
    w=1;
    i=1;
    j=1;
    c=0;
   
    
    % variables
    Flags=flags;
    flag=+flags;
    
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
   
    %% check if width of entropy value
    % local variables 
    d=1;
    for i=1:c
        count=0;
        %% add 02.27.17 - 18.17
        count_sommet=0;
        mean_s=mean(Signal(beg_end(1,i):beg_end(2,i)));
        for j=beg_end(1,i):beg_end(2,i)-1
            if (Signal(j)<mean_s && Signal(j+1)>=mean_s)
                count_sommet=count_sommet+1;
            end
        end
        if( count_sommet==0)
             Flags((beg_end(1,i)):beg_end(2,i))=0;
        else
            while (d<=count_sommet)
            %% end add
            begin=beg_end(1,i);
                for j=begin:(beg_end(2,i)-1)
                    if (Signal(j)>max(Signal(begin:beg_end(2,i)))/2 && Signal(j+1)~=0)
                        count=count+1;
                    end
                end

                if(count<20)
                    if (count_sommet~=1)
                        Flags((begin:count+begin))=0;
                        begin=count;
                        count=0;
                        if (begin>=beg_end(2,i))
                            break;
                        end
                    else
                        Flags((beg_end(1,i)):beg_end(2,i))=0;
                    end
                end
                d=d+1;
            end
        end
        
    end
end