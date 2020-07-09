load('.\gestureList.mat');
src_dir = '.\Feat\EMG-S';
tar_dir = '.\Data\';
mkdir(tar_dir)

n = length(gname);
nclass = 10;
ntrial = 6;
nsub = 8;
N = nsub*ntrial;

Data={};
for fnum = 1:n
    fn = gname(fnum,:);
    switch fn
        case 'HC-'
            for tr = 1:ntrial
                for isub = 1:8
                    count = (isub-1)*ntrial+tr;
                    load([src_dir,num2str(isub),'\',fn,num2str(tr),'.mat']);
                    PCA1 = computePCA(F1Mat);
                    PCA2 = computePCA(F2Mat);
                    Data{1,count,1} = [PCA1(:) PCA2(:)] ;
                    Data{1,count,2} = 1;
                end
            end
            
        case 'I-I'
            for tr = 1:ntrial
                for isub = 1:8
                    count = (isub-1)*ntrial+tr;
                    load([src_dir,num2str(isub),'\',fn,num2str(tr),'.mat']);
                    PCA1 = computePCA(F1Mat);
                    PCA2 = computePCA(F2Mat);
                    Data{2,count,1} = [PCA1(:) PCA2(:)];
                    Data{2,count,2} = 2;
                end
            end
            
        case 'L-L'
            for tr = 1:ntrial
                for isub = 1:8
                    count = (isub-1)*ntrial+tr;
                    load([src_dir,num2str(isub),'\',fn,num2str(tr),'.mat']);
                    PCA1 = computePCA(F1Mat);
                    PCA2 = computePCA(F2Mat);
                    Data{3,count,1} = [PCA1(:) PCA2(:)];
                    Data{3,count,2} = 3;
                end
            end
            
        case 'M-M'
            for tr = 1:ntrial
                for isub = 1:8
                    count = (isub-1)*ntrial+tr;
                    load([src_dir,num2str(isub),'\',fn,num2str(tr),'.mat']);
                    PCA1 = computePCA(F1Mat);
                    PCA2 = computePCA(F2Mat);
                    Data{4,count,1} = [PCA1(:) PCA2(:)];
                    Data{4,count,2} = 4;
                end
            end
            
        case 'R-R'
            for tr = 1:ntrial
                for isub = 1:8
                    count = (isub-1)*ntrial+tr;
                    load([src_dir,num2str(isub),'\',fn,num2str(tr),'.mat']);
                    PCA1 = computePCA(F1Mat);
                    PCA2 = computePCA(F2Mat);
                    Data{5,count,1} = [PCA1(:) PCA2(:)];
                    Data{5,count,2} = 5;
                end
            end
            
        case 'T-I'
            for tr = 1:ntrial
                for isub = 1:8
                    count = (isub-1)*ntrial+tr;
                    load([src_dir,num2str(isub),'\',fn,num2str(tr),'.mat']);
                    PCA1 = computePCA(F1Mat);
                    PCA2 = computePCA(F2Mat);
                    Data{6,count,1} = [PCA1(:) PCA2(:)];
                    Data{6,count,2} = 6;
                end
            end
            
        case 'T-L'
            for tr = 1:ntrial
                for isub = 1:8
                    count = (isub-1)*ntrial+tr;
                    load([src_dir,num2str(isub),'\',fn,num2str(tr),'.mat']);
                    PCA1 = computePCA(F1Mat);
                    PCA2 = computePCA(F2Mat);
                    Data{7,count,1} = [PCA1(:) PCA2(:)];
                    Data{7,count,2} = 7;
                end
            end
            
        case 'T-M'
            for tr = 1:ntrial
                for isub = 1:8
                    count = (isub-1)*ntrial+tr;
                    load([src_dir,num2str(isub),'\',fn,num2str(tr),'.mat']);
                    PCA1 = computePCA(F1Mat);
                    PCA2 = computePCA(F2Mat);
                    Data{8,count,1} = [PCA1(:) PCA2(:)];
                    Data{8,count,2} = 8;
                end
            end
            
        case 'T-R'
            for tr = 1:ntrial
                for isub = 1:8
                    count = (isub-1)*ntrial+tr;
                    load([src_dir,num2str(isub),'\',fn,num2str(tr),'.mat']);
                    PCA1 = computePCA(F1Mat);
                    PCA2 = computePCA(F2Mat);
                    Data{9,count,1} = [PCA1(:) PCA2(:)];
                    Data{9,count,2} = 9;
                end
            end
            
        case 'T-T'
            for tr = 1:ntrial
                for isub = 1:8
                    count = (isub-1)*ntrial+tr;
                    load([src_dir,num2str(isub),'\',fn,num2str(tr),'.mat']);
                    PCA1 = computePCA(F1Mat);
                    PCA2 = computePCA(F2Mat);
                    Data{10,count,1} = [PCA1(:) PCA2(:)];
                    Data{10,count,2} = 10;
                end
            end
    end
    
end


for nc = 1:nclass
    tar_folder = [tar_dir,'Data_class',num2str(nc)];
    mkdir(tar_folder);
    
    save([tar_folder,'\Data_class',num2str(nc),'.mat'],...
        ['Data_class',num2str(nc)]);
end

%% Create training and tesing data
DataSet = [];
for n=1:10
    DataSet = [DataSet; squeeze(Data(n,1:24,:))];
end

TestDataSet = [];
for n=1:10
    TestDataSet = [TestDataSet; squeeze(Data(n,25:48,:))];
end

p = randperm(length(DataSet));
DataSet = DataSet(p,:);
TestDataSet = TestDataSet(p,:);

save([tar_dir,'Data.mat'],'DataSet','TestDataSet');

