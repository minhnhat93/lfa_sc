load('trained_network/lcod_network.mat');
datapath='USPS data/';
test_data=load([datapath 'USPS_Test_Data.mat']);
test_data=test_data.Test_Data;
dict=load([datapath 'Dictionary2.mat']);
dict=dict.Dict;
base_sp_code=zeros(size(dict,2),size(test_data,2));
sp_code=zeros(size(base_sp_code));
for j=1:size(sp_code,2)
  tic;
  base_sp_code(:,j)=cod(test_data(:,j),dict, 0.5, 0.0001);
  toc;
  sp_code(:,j)=lcod_fprop(test_data(:,j),network.We,network.S,network.theta,network.T);
end
err=abs(base_sp_code-sp_code);