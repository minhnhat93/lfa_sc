n_sample=100;
n_train_time=3;
datapath='USPS data/';
train_data=load([datapath 'USPS_Train_Data.mat']);
n_sample=min(n_sample,size(train_data.Train_Data,2));
train_data=train_data.Train_Data(:,1:n_sample);
sp_code=load([datapath 'Sparse_Coef2.mat']);
sp_code=sp_code.Train_Set_sparse_vector;
dict=load([datapath 'Dictionary2.mat']);
dict=dict.Dict;
network=lcod_train(train_data,dict,sp_code,0.5,7,n_sample*n_train_time);
save('trained_network/lcod_network.mat');