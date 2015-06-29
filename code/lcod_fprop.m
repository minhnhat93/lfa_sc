function [Z, K, b, e, B] = lcod_fprop( X, We, S, theta, T )
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
  K=zeros(T-1,1); b=zeros(T-1,1); e=zeros(T-1,1);
  %idx=B<0;
  for t=1:T-1
    Z1=h_theta(B,theta);
    Zd=Z1-Z;
    k=find(abs((abs(Zd)-max(abs(Zd))))<eps, 1 );
    K(t)=k; 
    b(t)=B(k); 
    e(t)=Z1(k)-Z(k);
    B=B+S(:,k)*e(t);
    Z(k)=Z1(k);
    %plot(B); pause;
    %B(idx)
  end
  Z=h_theta(B,theta);
  %Z(idx)
end