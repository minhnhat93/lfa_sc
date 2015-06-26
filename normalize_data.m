load('USPS Data/Dictionary2.mat');
datapath='USPS Data/';
train_data=load([datapath 'USPS_Train_Data.mat']);
train_data=train_data.Train_Data;
Wd=Dict;
coeff_trainset=zeros(size(Dict,2),size(train_data,2));
[Wd,w]=col_norm(Wd,2);
for j=1:size(train_data,2)
  disp(j);
  coeff_trainset(:,j)=cod(train_data(:,j),Wd, 0.0001, 0.0001);
end
save('normalized_data/dict_2000.mat','Wd');
save('normalized_data/coeff_train_2000.mat','coeff_trainset');
%%
load('USPS Data/Dictionary1.mat');
datapath='USPS Data/';
train_data=load([datapath 'USPS_Train_Data.mat']);
train_data=train_data.Train_Data;
Wd=Dict;
coeff_trainset=zeros(size(Dict,2),size(train_data,2));
[Wd,w]=col_norm(Wd,2);
for j=1:500
  disp(j);
  coeff_trainset(:,j)=cod(train_data(:,j),Wd, 0.0001, 0.0001);
end
save('normalized_data/dict_1000.mat','Wd');
save('normalized_data/coeff_train_1000.mat','coeff_trainset');