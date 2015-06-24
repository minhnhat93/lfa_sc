function [Z, k, b, e, B] = lcod_fprop( X, We, S, theta, T )
% LCOD_FPROP Summary of this function goes here
% d<something> mean derivative of L with respect to <something>
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
  k=zeros(T-1,1); b=zeros(T-1,1); e=zeros(T-1,1);
  for t=1:T-1
    Z1=h_theta(B,theta);
    Zd=Z1-Z;
    k1=find(abs((abs(Zd)-max(abs(Zd))))<eps, 1 );
    k(t)=k1; 
    b(t)=B(k1); 
    e(t)=Z1(k1)-Z(k1);
    B=B+S(:,k1)*e(t);
    Z(k1)=Z1(k1);
  end
  Z=h_theta(B,theta);
end

