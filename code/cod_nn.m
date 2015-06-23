function Z = cod_nn( X, We, S, theta, num_iter )
%LCOD Summary of this function goes here
%input: X, (We=Wd^T, S, theta=alpha), num_iter
%output: Z
%   Detailed explanation goes here
  B=We*X;
  Z=zeros(sizeof(shrink_func(B,theta)));
  for iter=1:num_iter
    Z1=shrink_func(B,theta);
    Z_d=Z1-Z;
    k=find(abs(Z_d)==max(abs(Z_d(:))));
    k=k(1);
    B=B+S(:,k).*(Z_d);
    Z(k)=Z1(k);
  end
  Z=shrink_func(B,theta);
end