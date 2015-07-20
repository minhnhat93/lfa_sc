DATASET='USPS';
ALPHA=0.5;
NET_DEPTH=0;
if strcmp(DATASET,'USPS')
  load(sprintf('trained_network/USPS_lcod_network_%f_%d.mat',ALPHA,NET_DEPTH));
  Wd=load('USPS Data/Dictionary2.mat');
  Wd=Wd.Dict;
  test_data=load('USPS Data/USPS_Test_Data.mat');
  test_data=test_data.Test_Data;
  IM_SIZE=[16 16];
  base_sp_code=load('USPS Data/coef_2000_0dot5.mat');
  base_sp_code=base_sp_code.sp;
elseif strcmp(DATASET,'MNIST')
  load(sprintf('trained_network/MNIST_lcod_network_%f_%d.mat',ALPHA,NET_DEPTH));
  Wd=load('MNIST Data/Simplified_MNIST_Dic.mat');
  Wd=Wd.WDict;
  test_data=load('MNIST Data/MNIST_Data.mat');
  test_data=test_data.tt_dat;
  IM_SIZE=[28 28];
  base_sp_code=load('MNIST Data/coef.mat');
  base_sp_code=base_sp_code.sp;
end
S=eye(size(Wd'*Wd))-Wd'*Wd;
L=max(eig(Wd'*Wd))+1;
sp_code=mass_lcod_fprop(test_data,network.We,network.S,network.theta,network.T);
sp_code_b=zeros(size(sp_code));
sp_code_c=mass_lcod_fprop(test_data,Wd',S,repmat(ALPHA,size(Wd,2),1),NET_DEPTH);
%%
bright_mul=4;
plot_flag=false;
for j=1:size(test_data,2)
  disp(j);
  sp_code_b(:,j)=cod(test_data(:,j),Wd,S,repmat(ALPHA,size(Wd,2),1),1e-6);
  if plot_flag
  %%
    xp=Wd*sp_code(:,j);
    subplot(4,3,2);
    plot(test_data(:,j));
    subplot(4,3,3);
    imshow(reshape(test_data(:,j),IM_SIZE)*bright_mul);
    subplot(4,3,4);
    plot(sp_code_b(:,j));
    title('Ground truth sparse code');
    subplot(4,3,5);
    plot(Wd*sp_code_b(:,j));
    title('Reconstructed signal');
    subplot(4,3,6);
    imshow(reshape(Wd*sp_code_b(:,j),IM_SIZE)*bright_mul);
    subplot(4,3,7);
    title('COD sparse code');
    plot(sp_code_c(:,j));
    subplot(4,3,8);
    plot(Wd*sp_code_c(:,j));
    subplot(4,3,9);
    imshow(reshape(Wd*sp_code_c(:,j),IM_SIZE)*bright_mul);
    subplot(4,3,10);
    plot(sp_code(:,j));
    title('LCOD sparse code');
    subplot(4,3,11);
    plot(Wd*sp_code(:,j));
    title('Reconstructed signal');
    subplot(4,3,12);
    imshow(reshape(xp,IM_SIZE)*bright_mul);
    pause;
  end
end
%%
err=abs(sp_code_b-sp_code);
err_cod=abs(sp_code_b-sp_code_c);
clear result;
result.MAE=max(mean(err,1));
result.MSE=max(mean(err.*err,1));
result.MAE_cod=max(mean(err_cod,1));
result.MSE_cod=max(mean(err_cod.*err_cod,1));
save(sprintf('result/%s_result_lcod_%f_%d.mat',DATASET,ALPHA,NET_DEPTH),'result');