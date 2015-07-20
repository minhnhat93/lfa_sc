DIM_Y=20;
DATASET='USPS';
if strcmp(DATASET,'USPS')
  D=load('USPS Data/Dictionary2.mat');
  D=D.Dict;
  a=load('USPS Data/coef_2000_0dot0.500000.mat');
  a=a.sp;
  IM_SIZE=[16 16];
elseif strcmp(DATASET,'MNIST')
  D=load('MNIST Data/Simplified_MNIST_Dic.mat');
  D=D.WDict;
  a=load('MNIST Data/coef.mat');
  a=a.sp;
  IM_SIZE=[28 28];
end
k=size(a,1);
G=rand(DIM_Y,k); G=orth(G')';
y=G*a;
save(sprintf('GD/init_mat/%s_G.mat',DATASET),'G');
save(sprintf('GD/init_mat/%s_a.mat',DATASET),'a');
save(sprintf('GD/init_mat/%s_y.mat',DATASET),'y');
save(sprintf('GD/init_mat/%s_D.mat',DATASET),'D');
