DATASET='MNIST';
ALPHA=0.5;
NET_DEPTH=2;
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
sp_code=mass_lcod_fprop(test_data,Wd',S,repmat(ALPHA,size(Wd,2),1),network.T);
base_sp_code=zeros(size(sp_code));
%%
bright_mul=8;
plot_flag=false;
for j=1:size(test_data,2)
  disp(j);
  base_sp_code(:,j)=cod(test_data(:,j),Wd,S,repmat(ALPHA,size(Wd,2),1),1e-6);
  if plot_flag
    xp=Wd*sp_code(:,j);
    subplot(3,3,2);
    plot(test_data(:,j));
    subplot(3,3,3);
    imshow(reshape(test_data(:,j),IM_SIZE)*bright_mul);
    subplot(3,3,4);
    plot(base_sp_code(:,j));
    title('Ground truth sparse code');
    subplot(3,3,5);
    plot(Wd*base_sp_code(:,j));
    title('Reconstructed signal');
    subplot(3,3,6);
    imshow(reshape(Wd*base_sp_code(:,j),IM_SIZE)*bright_mul);
    subplot(3,3,7);
    plot(sp_code(:,j));
    title('LCOD sparse code');
    subplot(3,3,8);
    plot(Wd*sp_code(:,j));
    title('Reconstructed signal');
    subplot(3,3,9);
    imshow(reshape(xp,IM_SIZE)*bright_mul);
    pause;
  end
end
%%
clear result;
err=base_sp_code-sp_code;
result.predict_MAE=max(mean(abs(err),1));
result.predict_MSE=max(mean(err.*err,1));
err=test_data-Wd*sp_code;
result.reconstruct_MAE=max(mean(abs(err),1));
result.reconstruct_MSE=max(mean(err.*err,1));
save(sprintf('result/%s_result_cod_%f_%d.mat',DATASET,ALPHA,NET_DEPTH),'result');