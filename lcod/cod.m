function [Z,num_iter] = cod(X, Wd, S, alpha, thres)
%COD Summary of this function goes here
% [Z,num_iter,Zout] = cod(X, Wd, S, alpha, thres, out_iter)
% S is mutual inhibation matrix S=I-Wd'*Wd
  B=Wd'*X;
  Z=zeros(size(B));
  Zd=Inf;
  num_iter=0;
  while any(abs(Zd(:))>thres)
    num_iter=num_iter+1;
    Z1=h_theta(B,alpha);
    Zd=Z1-Z;
    k1=find(abs((abs(Zd)-max(abs(Zd))))<eps, 1 );
    B=B+S(:,k1)*(Z1(k1)-Z(k1));
    Z(k1)=Z1(k1);
  end
  Z=h_theta(B,alpha);
end