DATASET='MNIST';
ALPHA=0.5;
NET_DEPTH=1;
if strcmp(DATASET,'USPS')
  load(sprintf('trained_network/USPS_lista_network_%f_%d.mat',ALPHA,NET_DEPTH));
  Wd=load('USPS Data/Dictionary2.mat');
  Wd=Wd.Dict;
  test_data=load('USPS Data/USPS_Test_Data.mat');
  test_data=test_data.Test_Data;
  IM_SIZE=[16 16];
  base_sp_code=load('USPS Data/coef_2000_0dot5.mat');
  base_sp_code=base_sp_code.sp;
elseif strcmp(DATASET,'MNIST')
  load(sprintf('trained_network/MNIST_lista_network_%f_%d.mat',ALPHA,NET_DEPTH));
  Wd=load('MNIST Data/Simplified_MNIST_Dic.mat');
  Wd=Wd.WDict;
  test_data=load('MNIST Data/MNIST_Data.mat');
  test_data=test_data.tt_dat;
  IM_SIZE=[28 28];
  base_sp_code=load('MNIST Data/coef.mat');
  base_sp_code=base_sp_code.sp;
end
sp_code=mass_lista_fprop(test_data,network.We,network.S,network.theta,network.T);
%%
bright_mul=8;
plot_flag=true;
if plot_flag
  for j=1:size(test_data,2)
  disp(j);
  %%
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
    title('LISTA sparse code');
    subplot(3,3,8);
    plot(Wd*sp_code(:,j));
    title('Reconstructed signal');
    subplot(3,3,9);
    imshow(reshape(xp,IM_SIZE)*bright_mul);
    pause;
  end
end
%%
err=test_data-Wd*sp_code;
clear result;
result.mean_absolute_error=mean(abs(err(:)));
result.mean_squared_error=mean(err(:).*err(:));
save(sprintf('result/%s_result_lista_%f_%d.mat',DATASET,ALPHA,NET_DEPTH),'result');