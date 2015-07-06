DATASET='MNIST';
LEARNING_RATE.alpha=10;
LEARNING_RATE.t0=0;
LEARNING_RATE.max_change=0.1;
MAX_ITER=100000;
ALPHA=0.005;
NET_DEPTH=3;
NUM_CLASSES=1;
CONV_THRES=1e-3;
CONV_COUNT=3;
ERROR_CHECK_ITER=5;
if strcmp(DATASET,'USPS')
  n_sample=Inf;
  train_data=load('USPS Data/train_data.mat');
  train_data=train_data.train_data;
  n_sample=min(n_sample,size(train_data.train_data,2));
  train_data=train_data(:,1:n_sample);
  dict=load('USPS Data/Dictionary2.mat'); dict=dict.Dict;
  sp_code=load('USPS Data/coef_2000_0dot1.mat'); sp_code=sp_code.sp(:,...
    1:n_sample);
elseif strcmp(DATASET,'MNIST')
  n_sample=Inf;
  train_data=load('MNIST Data/train_data.mat');
  train_data=train_data.train_data;
  n_sample=min(n_sample,size(train_data,2));
  train_data=train_data(:,1:n_sample);
  dict=load('MNIST Data/Simplified_MNIST_Dic.mat');
  dict=dict.WDict;
  sp_code=load('MNIST Data/coef.mat');
  sp_code=sp_code.sp(:,1:n_sample);
end
network=lcod_train(train_data,dict,sp_code,ALPHA,NET_DEPTH,NUM_CLASSES,...
  LEARNING_RATE,MAX_ITER,CONV_THRES,CONV_COUNT,ERROR_CHECK_ITER);
disp('Saving.');
save(sprintf('trained_network/%s_lcod_network_%f_%d.mat',DATASET,ALPHA,...
  NET_DEPTH),'network');