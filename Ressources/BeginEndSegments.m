function Flags=BeginEndSegments(Signal,Flags)
    Flags=+Flags;
    for i=2:length(Flags)
        if(Flags(i-1)==0 && Flags(i)==1)
            w=i;
            while(Signal(w-1)<=Signal(w))
                Flags(w)=1;
                w=w-1;
                if(0==(w-1))
                    break;
                end
            end
        elseif(Flags(i-1)==1 && Flags(i)==0) 
            v=i-1;
            while(Signal(v)>=Signal(v+1))
                Flags(v)=1;
                v=v+1;
                if(v+1>numel(Signal))
                    break;
                end
            end
        end
    end
end