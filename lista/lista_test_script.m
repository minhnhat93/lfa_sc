DATASET='USPS';
ALPHA=0.5;
NET_DEPTH=3;
if strcmp(DATASET,'USPS')
  %load(sprintf('trained_network/USPS_lista_network_%f_%d.mat',ALPHA,NET_DEPTH));
  load(sprintf('GD/init_mat/USPS_lista_1.mat'));
  Wd=load('USPS Data/Dictionary2.mat');
  Wd=Wd.Dict;
  test_data=load('USPS Data/USPS_Test_Data.mat');
  test_data=test_data.Test_Data;
  IM_SIZE=[16 16];
elseif strcmp(DATASET,'MNIST')
  load(sprintf('trained_network/MNIST_lista_network_%f_%d.mat',ALPHA,NET_DEPTH));
  Wd=load('MNIST Data/Simplified_MNIST_Dic.mat');
  Wd=Wd.WDict;
  test_data=load('MNIST Data/MNIST_Data.mat');
  test_data=test_data.tt_dat;
  IM_SIZE=[28 28];
end
test_data=test_data*255;
L=max(eig(Wd'*Wd))+1;
S=eye(size(Wd'*Wd))-1/L*(Wd'*Wd);
sp_code=mass_lista_fprop(test_data,network.We,network.S,network.theta,network.T);
sp_code_b=zeros(size(sp_code));
sp_code_c=mass_lista_fprop(test_data,Wd',S,repmat(ALPHA,size(Wd,2),1),NET_DEPTH);
%%
bright_mul=8;
plot_flag=true;
for j=1:size(test_data,2)
  disp(j);
  sp_code_b(:,j)=cod(test_data(:,j),Wd,S,repmat(ALPHA,size(Wd,2),1),1e-2);
  if plot_flag
  %%
    xp=Wd*sp_code(:,j);
    subplot(4,3,2);
    plot(test_data(:,j));
    subplot(4,3,3);
    imshow(reshape(uint8(test_data(:,j)),IM_SIZE)*bright_mul);
    subplot(4,3,4);
    plot(sp_code_b(:,j));
    title('Ground truth sparse code');
    subplot(4,3,5);
    plot(Wd*sp_code_b(:,j));
    title('Reconstructed signal');
    subplot(4,3,6);
    imshow(reshape(uint8(Wd*sp_code_b(:,j)),IM_SIZE)*bright_mul);
    subplot(4,3,7);
    title('COD sparse code');
    plot(sp_code_c(:,j));
    subplot(4,3,8);
    plot(Wd*sp_code_c(:,j));
    subplot(4,3,9);
    imshow(reshape(uint8(Wd*sp_code_c(:,j)),IM_SIZE)*bright_mul);
    subplot(4,3,10);
    plot(sp_code(:,j));
    title('LISTA sparse code');
    subplot(4,3,11);
    plot(Wd*sp_code(:,j));
    title('Reconstructed signal');
    subplot(4,3,12);
    imshow(reshape(uint8(xp),IM_SIZE)*bright_mul);
    pause;
  end
end
%%
err=abs(sp_code_b-sp_code);
err_cod=abs(sp_code_b-sp_code_c);
clear result;
result.MAE=max(mean(err,1));
result.MSE=max(mean(err.*err,1));
result.MAE_lista=max(mean(err_cod,1));
result.MSE_lista=max(mean(err_cod.*err_cod,1));
save(sprintf('result/%s_result_lista_%f_%d.mat',DATASET,ALPHA,NET_DEPTH),'result');