function MFCCs=MFCCsFilter(MFCCsInit)
   %% addpath
   addpath('Tools');
   MFCCs=conv2(MFCCsInit,gaussian1d(4,1),'same');
end