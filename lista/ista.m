function Z = ista( X, Wd, alpha, L, conv_thres )
% Z = lista( X, Wd, alpha, L, conv_thres )
%   Detailed explanation goes here
  Z=zeros(size(Wd,2),1);
  Zd=Inf;
  while any(Zd>conv_thres)
    Z1=h_theta(Z-1/L*(Wd'*(Wd*Z-X)),alpha/L);
    Zd=abs(Z1-Z);
    Z=Z1;
  end
end