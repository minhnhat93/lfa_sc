function [Z, num_iter] = ista( X, Wd, alpha, L, thres )
% Z = lista( X, Wd, alpha, L, thres )
% 0<thres<1: repeat until converge
% thres=0 or thres>1: repeat thres times
%   Detailed explanation goes here
  Z=zeros(size(Wd,2),1);
  Zd=Inf;
  num_iter=0;
  while true
    if thres<1 && thres>0
      if all(Zd(:)<thres); break; end
    else
      if num_iter>=thres; break; end
    end
    num_iter=num_iter+1;
    Z1=h_theta(Z-1/L*(Wd'*(Wd*Z-X)),alpha/L);
    Zd=abs(Z1-Z);
    Z=Z1;
  end
end