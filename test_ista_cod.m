ALPHA=0.5;
CONV_THRES=1e-4;
datapath='USPS Data/';
test_data=load([datapath 'USPS_Test_Data.mat']);
test_data=test_data.Test_Data;
train_data=load([datapath 'USPS_Train_Data.mat']);
train_data=train_data.Train_Data;
Wd=load('USPS Data/Dictionary2.mat');
Wd=Wd.Dict;
base_sp_code=load('USPS Data/Sparse_Coef2.mat');
base_sp_code=base_sp_code.Train_Set_sparse_vector;
sp_cod=zeros(size(base_sp_code));
sp_ista=zeros(size(base_sp_code));
sp_cod_their=zeros(size(base_sp_code));
L=max(eig(Wd'*Wd))+1;
S=eye(size(Wd'*Wd))-(Wd'*Wd);
%%
for j=1:size(train_data,2)
  fprintf('%d\n',j);
  sp_cod(:,j)=cod(train_data(:,j),Wd,S,ALPHA,CONV_THRES,Inf);
  sp_ista(:,j)=ista(train_data(:,j),Wd,ALPHA,L,CONV_THRES);
  sp_cod_their(:,j)=coordlsl1(Wd,train_data(:,j),1/2/ALPHA);
end
%%
err1=sp_cod-base_sp_code;
err2=sp_ista-base_sp_code;
err3=sp_cod_their-base_sp_code;
L1err1=zeros(1,size(err1,2));
L1err2=zeros(1,size(err2,2));
L1err3=zeros(1,size(err3,2));
L2err1=zeros(1,size(err1,2));
L2err2=zeros(1,size(err2,2));
L2err3=zeros(1,size(err3,2));
for j=1:size(train_data,2)
  L1err1(j)=norm(err1,1);
  L1err2(j)=norm(err2,1);
  L1err3(j)=norm(err3,1);
  L2err1(j)=norm(err1,2);
  L2err2(j)=norm(err2,2);
  L2err3(j)=norm(err3,2);
end
result.ALPHA=ALPHA;
result.CONV_THRES=CONV_THRES;
result.cod_err=err1;
result.ista_err=err2;
result.cod_alt_err=err3;
result.cod_MAE=mean(L1err1(:));
result.ista_MAE=mean(L1err2(:));
result.cod_alt_MAE=mean(L1err3(:));
result.cod_MSE=mean(L2err1(:));
result.ista_MSE=mean(L2err2(:));
result.cod_alt_MSE=mean(L2err3(:));
save('result_0d5.mat','result');