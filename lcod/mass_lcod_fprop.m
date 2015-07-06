function Z = mass_lcod_fprop( X, We, S, theta, T )
% LCOD_FPROP Summary of this function goes here
% d<something> mean derivative of L with respect to <something>
% [Z, K, b, e, B] = lcod_fprop( X, We, S, theta, T )
% Input:
%   X is input signal nx1
%   We is trained filter matrix mxn: We=Wd^T
%   S is trained mutual inhibition matrix
%   theta
%   T
% Out:
%   Z sparse code
%   k,b,e saved for bprop
  
  B=We*X; %B is mx1
  Z=zeros(size(B)); %Z is mx1
  cols=1:size(X,2);
  for t=1:T-1
    Z1=h_theta(B,theta);
    Zd=Z1-Z;
    [~,k]=max(abs(Zd),[],1);
    k_2d=sub2ind(size(Zd),k,cols);
    B=B+S(:,k).*repmat(Zd(k_2d),size(S,1),1);
    Z(k_2d)=Z1(k_2d);
    %plot(B); pause;
    %B(idx)
  end
  Z=h_theta(B,theta);
  %Z(idx)
end