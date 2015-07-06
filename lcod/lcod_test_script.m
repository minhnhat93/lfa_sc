append='';
load(strcat('trained_network/lcod_network',append,'.mat'));
datapath='USPS Data/';
test_data=load([datapath 'USPS_Test_Data.mat']);
test_data=test_data.Test_Data;
train_data=load([datapath 'USPS_Train_Data.mat']);
train_data=train_data.Train_Data;
Wd=load('USPS Data/Dictionary2.mat');
Wd=Wd.Dict;
base_sp_code=load('USPS Data/coef_2000_0dot5.mat');
base_sp_code=base_sp_code.sp;
sp_code=zeros(size(base_sp_code));
L=max(eig(Wd'*Wd))+1;
S=eye(size(Wd'*Wd))-(Wd'*Wd);
%%
bright_mul=4;
plot_flag=true;
for j=1:200
  [base_sp_code(:,j),num_iter]=cod(test_data(:,j),Wd,S,0.005,0.0001,Inf);
  sp_code(:,j)=lcod_fprop(test_data(:,j),network.We,network.S,network.theta,network.T);
  %%
  if plot_flag
    xp=Wd*sp_code(:,j);
    subplot(3,3,2);
    plot(test_data(:,j));
    subplot(3,3,3);
    imshow(reshape(test_data(:,j),16,16)*bright_mul);
    subplot(3,3,4);
    plot(base_sp_code(:,j));
    title('Ground truth sparse code');
    subplot(3,3,5);
    plot(Wd*base_sp_code(:,j));
    title('Reconstructed signal');
    subplot(3,3,6);
    imshow(reshape(Wd*base_sp_code(:,j),16,16)*bright_mul);
    subplot(3,3,7);
    plot(sp_code(:,j));
    title('LCOD sparse code');
    subplot(3,3,8);
    plot(Wd*sp_code(:,j));
    title('Reconstructed signal');
    subplot(3,3,9);
    imshow(reshape(xp,16,16)*bright_mul);
    pause;
  end
end
%%
err=base_sp_code-sp_code;
L1err=zeros(1,size(err,2));
L2err=zeros(2,size(err,2));
for j=1:size(err,2)
  L1err(j)=norm(err(:,j),1);
  L2err(j)=norm(err(:,j),2);
end
result.mean_absolute_error=mean(L1err);
result.mean_squared_error=mean(L2err);