
global buffer;
winsize=0.015;
winshift=0.005;
T = 0.5; % in seconds
samples =cell(100,1);
r = audiorecorder(16000,16,1);
k=1;
r.TimerPeriod = 0.2;
r.StopFcn = 'disp(''Completed sample '', k)';
r.TimerFcn = {@get_pitch,samples{k},winsize,winshift};
sl=[];
tim=1;
count=0;
while 1
     recordblocking(r,T);
     samples{k} =  getaudiodata(r);
     buffer=cell2mat(samples(k));
     sl=[sl; buffer];
     figure(1);
     plot(sl);
     if (mean(buffer)<=0.01)
         count=count+1;
         if (count>=10)
             break;
         end
     else 
         count=0;
     end
end  



