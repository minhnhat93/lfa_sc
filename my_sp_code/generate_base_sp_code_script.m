coeff_size=256;
load(['my_sp_code/dict_',num2str(coeff_size,'%d.mat')]);
datapath='USPS data/';
%%
train_data=load([datapath 'USPS_Train_Data.mat']);
train_data=train_data.Train_Data;
sp_code=zeros(coeff_size,size(train_data,2));
for j=1:size(train_data,2)
  sp_code(:,j)=cod(train_data(:,j),dict.Wd,dict.alpha,dict.thres);
end
r_train_data=dict.Wd*sp_code;
err_train=abs(r_train_data-train_data);
save('my_sp_code/train_sp_code.mat','sp_code');
%%
%{
train_data=load([datapath 'USPS_Test_Data.mat']);
train_data=train_data.Test_Data;
sp_code=zeros(coeff_size,size(train_data,2));
for j=1:size(train_data,2)
  sp_code(:,j)=cod(train_data(:,j),dict.Wd,dict.alpha,dict.thres);
end
r_train_data=dict.Wd*sp_code;
err_test=abs(r_train_data-train_data);
save('my_sp_code/test_sp_code.mat','sp_code');
%}