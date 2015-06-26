load('USPS Data/Dictionary2.mat');
datapath='USPS data/';
train_data=load([datapath 'USPS_Train_Data.mat']);
train_data=train_data.Train_Data;
Wd=Dict;
coeff_trainset=zeros(size(Dict,2),size(train_data,2));
[Wd,w]=col_norm(Wd,2);
for j=1:size(train_data,2)
  disp(j);
  coeff_trainset(:,j)=cod(train_data(:,j),Wd, 0.0001, 0.0001);
end
