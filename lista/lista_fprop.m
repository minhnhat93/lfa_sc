function [ Z0, Z, C, B ] = lista_fprop( X, We, S, theta, T )
%LISTA_FPROP Summary of this function goes here
% [ Z0, Z, C, B ] = lista_fprop( X, We, S, theta, T )
%   Detailed explanation goes here
  B=We*X;
  Z=zeros(numel(B),T+1);
  Z(:,1)=h_theta(B,theta);
  C=zeros(numel(B),T+1);
  for t=1:T
    C(:,t)=B+S*Z(:,t);
    Z(:,t+1)=h_theta(C(:,t),theta);
  end
  Z0=Z(:,t);
end