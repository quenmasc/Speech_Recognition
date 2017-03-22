function Flags=correction_flag(flags,weight)

    % change logical to double values 
    if(weight==1)
        weight=weight+1;
    end
    if (mod(weight,2)~=0)
        weight=weight+1;
    end
    Flags=+flags;
    for i=1:length(Flags)
        if(i<weight)
            Weight=flags(i:weight*2+i);
        elseif((i+weight>length(Flags)))
            Weight=flags(i-weight-1:end);
        elseif(i>weight && (i+weight)<length(Flags))
            Weight=flags(i-weight:i+weight);
        end
        
        nber_one =length(find(Weight==1));
        nber_zero =length(find(Weight==0));
        if (nber_one<nber_zero)
            if(Flags(i)==0)
                Flags(i)=flags(i);
            else
                Flags(i)=0;
            end
        else
            if (Flags(i)==1)
                Flags(i)=flags(i);
            else
                Flags(i)=1;
            end
        end
    end
            

%     for i=weight:(length(Flags)-weight)
%         nber_one =length(find(flags(i-weight+1:i+weight-1)==1));
%         nber_zero =length(find(flags(i-weight+1:i+weight-1)==0));
%         if (nber_one<nber_zero)
%             if(Flags(i)==0)
%                 Flags(i)=Flags(i);
%             else
%                 Flags(i)=0;
%             end
%         else
%             if (Flags(i)==1)
%                 Flags(i)=Flags(i);
%             else
%                 Flags(i)=1;
%             end
%         end
%     end
    
    
    
end
