function MFCCs=MFCCsFilter(MFCCsInit)
   %% addpath
   addpath('Tools');
   MFCCs=conv2(MFCCsInit,gaussian2d(4,2.5),'same');
end