function [Mean,Var] = Mean_Var(x,win_size)
addpath('.\movingmean')
addpath('.\movingvar')
for i=1:size(x,2)
    Mean = movingmean(x,win_size);
    Var = movingvar(x,win_size);
end