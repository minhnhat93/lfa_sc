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
for j=1:size(test_data,2)
  fprintf('%d\n',j);
 %base_sp_code(:,j)=cod(test_data(:,j),Wd,S,ALPHA,CONV_THRES,Inf);
  sp_cod(:,j)=cod(test_data(:,j),Wd,S,ALPHA,CONV_THRES,Inf);
  sp_ista(:,j)=ista(test_data(:,j),Wd,ALPHA,L,CONV_THRES);
  sp_cod_their(:,j)=coordlsl1(Wd,test_data(:,j),1/2/ALPHA);
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
% for j=1:size(err1,2)
%   disp(j);
%   L1err1(j)=mean(abs(err1(:,j)));
%   L1err2(j)=mean(abs(err2(:,j)));
%   L1err3(j)=mean(abs(err3(:,j)));
%   L2err1(j)=mean(err1(:,j).*err1(:,j));
%   L2err2(j)=mean(err2(:,j).*err2(:,j));
%   L2err3(j)=mean(err3(:,j).*err3(:,j));
% end
result.ALPHA=ALPHA;
result.CONV_THRES=CONV_THRES;
result.cod_err=err1;
result.ista_err=err2;
result.cod_alt_err=err3;
result.cod_MAE=mean(abs(err1(:)));
result.ista_MAE=mean(abs(err2(:)));
result.cod_alt_MAE=mean(abs(err3(:)));
result.cod_MSE=mean(err1(:).*err1(:));
result.ista_MSE=mean(err2(:).*err2(:));
result.cod_alt_MSE=mean(err3(:).*err3(:));
save('result/result_0d5.mat','result');