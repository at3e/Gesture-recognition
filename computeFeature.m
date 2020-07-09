load('.\fileList.mat');
src_dir ='.\Sig\EMG-S8\';
tar_dir = '.\Feat\EMG-S8\';
mkdir(tar_dir);

level = 7;
num = length(fname);

for inum = 1:num
    filename = fname{inum,1};
    filename = filename(1:end-4);
    load([src_dir,filename,'.mat']);
    
    C1 = C1*(1e4); C2 = C2*(1e4);
    %% Level 4 wavelet decomposition
    [c1,l] = wavedec(C1,level,'coif4');
    [c2,l] = wavedec(C2,level,'coif4');
    L4c1 = wrcoef('a',c1,l,'coif4',4);
    L4c2 = wrcoef('a',c2,l,'coif4',4);
    
    %% Mean and variance
    [m1,v1] = Mean_Var(C1,100);
    [m2,v2] = Mean_Var(C2,100);
    
    %% TEO
    E1 = TEO(C1);
    E2 = TEO(C2);
    
    %% RMS, skewness, kurtosis
    [rms1,skew1,kurt1] = Rms(C1,100);   
    [rms2,skew2,kurt2] = Rms(C2,100);   
    
    %% Zero-crossing
    Zcr1 = Zerocr(C1);
    Zcr2 = Zerocr(C2);
    
    %% Feature matrix
    F1Mat = [L4c1 m1 v1 E1 rms1 skew1 kurt1 Zcr1];
    F2Mat = [L4c2 m2 v2 E2 rms2 skew2 kurt2 Zcr2];
    
    save([tar_dir,filename,'.mat'],'F1Mat','F2Mat');  
%     
end
