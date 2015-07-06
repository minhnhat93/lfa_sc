function [ Z0, Z, C, B ] = lista_fprop( X, We, S, theta, T )
%LISTA_FPROP Summary of this function goes here
% [ Z0, Z, C, B ] = lista_fprop( X, We, S, theta, T )
%   Detailed explanation goes here
  B=We*X;
  C=zeros(numel(B),T);
  Z=zeros(numel(B),T+1);
  Z(:,1)=h_theta(B,theta);
  for t=1:T
    C(:,t)=B+S*Z(:,t);
    Z(:,t+1)=h_theta(C(:,t),theta);
  end
  Z0=Z(:,T+1);
end