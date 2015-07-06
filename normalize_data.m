load('USPS Data/Dictionary2.mat');
datapath='USPS Data/';
train_data=load([datapath 'USPS_Train_Data.mat']);
train_data=train_data.Train_Data;
Wd=Dict;
coeff_trainset=zeros(size(Dict,2),size(train_data,2));
[Wd,w]=col_norm(Wd,2);
L=max(eig(Wd'*Wd))+0.1;
S=eye(size(Wd'*Wd))-(Wd'*Wd);
for j=1:size(train_data,2)
  disp(j);
  coeff_trainset(:,j)=cod(train_data(:,j),Wd, S, 0.5, 0.000001, Inf);
end
save('normalized_data/coeff_train_2000.mat','coeff_trainset');
%%
train_data=load([datapath 'USPS_Test_Data.mat']);
train_data=train_data.Test_Data;
coeff_trainset=zeros(size(Dict,2),size(train_data,2));
for j=1:size(train_data,2)
  disp(j);
  coeff_trainset(:,j)=cod(train_data(:,j),Wd, S, 0.5, 0.000001, Inf);
end
save('normalized_data/coeff_test_2000.mat','coeff_trainset');