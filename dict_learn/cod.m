function Z = cod(X, Wd, alpha, thres)
%COD Summary of this function goes here
%   Z = cod(X, Wd, alpha, thres)
  Wd=col_norm(Wd,2);
  S=eye(size(Wd'*Wd))-(Wd'*Wd);
  B=Wd'*X;
  Z=zeros(size(B));
  Zd=Inf;
  while any(abs(Zd(:))>=thres)
    Z1=h_theta(B,alpha);
    Zd=Z1-Z;
    k1=find(abs((abs(Zd)-max(abs(Zd))))<eps, 1 );
    B=B+S(:,k1)*(Z1(k1)-Z(k1));
    Z(k1)=Z1(k1);
  end
  Z=h_theta(B,alpha);
end