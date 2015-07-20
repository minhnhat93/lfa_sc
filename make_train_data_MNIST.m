ALPHA=0.5;
pos=[0, 5293, 12665, 18623, 24754, 30596, 36017, 41935, 48200, 54051, 60000];
p=pos;
for j=numel(pos):-1:2
  amount(j)=pos(j)-pos(j-1);
end
amount(1)=0;
d=min(amount(2:end));
data=load('MNIST Data/MNIST_Data.mat');
data=data.tr_dat;
Wd=load('MNIST Data/Simplified_MNIST_Dic.mat');
Wd=Wd.WDict;
sp_code=load('MNIST Data/Simplified_Sparse_Coef.mat');
sp_code=sp_code.Train_Set_sparse_vector;
train_data=zeros(size(Wd,1),10*d);
sp=zeros(size(Wd,2),10*d);
idx=0;
S=eye(size(Wd'*Wd))-(Wd'*Wd);
for i=1:d
  for j=1:10
    idx=idx+1;
    fprintf('%d\n',idx);
    train_data(:,idx)=data(:,pos(j)+i);
    if ALPHA==0
      sp(:,idx)=sp_code(:,pos(j)+i);
    else
      sp(:,idx)=cod(train_data(:,idx),Wd,S,ALPHA,1e-6);
    end
  end
end
save('MNIST Data/train_data.mat','train_data');
save('MNIST Data/coef.mat','sp');