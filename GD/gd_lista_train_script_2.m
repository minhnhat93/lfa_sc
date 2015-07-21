function gd_lista_train_script_2(depth,alpha,t0,CONTINUE_TRAINING)
DATASET='USPS';
LEARNING_RATE.alpha=alpha;
LEARNING_RATE.t0=t0;
LEARNING_RATE.max_change=0.1;
LEARNING_RATE.momentum=0.5;
MAX_ITER=5000;
ALPHA=0.5;
NET_DEPTH=depth;
NUM_CLASSES=10;
CONV_THRES=1e-2;
CONV_COUNT=2;
ERROR_CHECK_ITER=100;
if strcmp(DATASET,'USPS')
  n_sample=Inf;
  train_data=load('GD/init_mat/USPS_y.mat');
  train_data=train_data.y;
  n_sample=min(n_sample,size(train_data,2));
  train_data=train_data(:,1:n_sample);
  Wd=load('GD/init_mat/USPS_G.mat'); Wd=Wd.G;
  sp_code=load('GD/init_mat/USPS_a.mat'); sp_code=sp_code.a(:,...
    1:n_sample);
elseif strcmp(DATASET,'MNIST')
  n_sample=Inf;
  train_data=load('MNIST Data/train_data.mat');
  train_data=train_data.train_data;
  n_sample=min(n_sample,size(train_data,2));
  train_data=train_data(:,1:n_sample);
  Wd=load('MNIST Data/Simplified_MNIST_Dic.mat');
  Wd=Wd.WDict;
  sp_code=load('MNIST Data/coef.mat');
  sp_code=sp_code.sp(:,1:n_sample);
end
% Wd=rand(size(Wd));
% Wd=orth(Wd')';
if (CONTINUE_TRAINING)
save(sprintf('GD/init_mat/%s_lista_2.mat',DATASET),'network');
  LEARNING_RATE.t0=network.iter+1;
  %network.error=1;
  network=lista_train(train_data,sp_code,network,NUM_CLASSES,...
  LEARNING_RATE,MAX_ITER,CONV_THRES,CONV_COUNT,ERROR_CHECK_ITER);
else
  network.alpha=ALPHA;
  network.T=NET_DEPTH;
  network.conv_thres=CONV_THRES;
  network.We=Wd';
  network.theta=ALPHA*ones(size(sp_code,1),1);
  network.error=Inf;
  L=max(eig(Wd'*Wd))+1;
  network.S=eye(size(Wd'*Wd))-1/L*(Wd'*Wd);
  network.iter=0;
  network=lista_train(train_data,sp_code,network,NUM_CLASSES,...
    LEARNING_RATE,MAX_ITER,CONV_THRES,CONV_COUNT,ERROR_CHECK_ITER);
end
disp('Saving.');
save(sprintf('GD/init_mat/%s_lista_2.mat',DATASET),'network');
end