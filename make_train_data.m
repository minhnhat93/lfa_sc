ALPHA=0.5;
amount=[0, 1005, 731, 658, 652, 556, 664, 645, 542, 644, 1194];
pos=cumsum(amount(:));
d=min(amount(2:end)); %d=100;
datapath='USPS Data/';
data=load([datapath 'USPS_Train_Data.mat']);
data=data.Train_Data;
sp_code=load('USPS Data/Sparse_Coef2.mat');
sp_code=sp_code.Train_Set_sparse_vector;
train_data=zeros(256,10*d);
sp=zeros(2000,10*d);
idx=0;
Wd=load('USPS Data/Dictionary2.mat');
Wd=Wd.Dict;
S=eye(size(Wd'*Wd))-(Wd'*Wd);
for i=1:d
  for j=1:10
    idx=idx+1;
    disp(idx);
    train_data(:,idx)=data(:,pos(j)+i);
    tic;
    sp(:,idx)=cod(train_data(:,idx),Wd,S,ALPHA,1e-2);
    toc;
  end
end
save('USPS Data/train_data.mat','train_data');
save(sprintf('USPS Data/coef_2000_0dot%f.mat',ALPHA),'sp');