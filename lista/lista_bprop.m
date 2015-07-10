function [ dWe, dS, dtheta, dX ] = lista_bprop( X, Zstar, Z, We, S, theta, C, B, T)
%LISTA_BPROP Summary of this function goes here
% [ dWe, dS, dtheta, dX ] = lista_bprop( Zstar, X, We, S, theta, Z, C, B)
%   Detailed explanation goes here
  
  dC=zeros(size(C));
  %%
  dB=zeros(size(B));
  dS=zeros(size(S));
  dtheta=zeros(size(theta));
  dZ=zeros(size(Z));
  dZ(:,T+1)=Z(:,T+1)-Zstar;
  %%
  for t=T:-1:1
    dC(:,t)=h_prime(C(:,t),theta)*dZ(:,t+1);
    dtheta=dtheta-sign(C(:,t)).*dC(:,t);
    dB=dB+dC(:,t);
    dS=dS+dC(:,t)*Z(:,t)';
    dZ(:,t)=S'*dC(:,t);
  end
  dB=dB+h_prime(B,theta)*dZ(:,1);
  dtheta=dtheta-sign(B).*(h_prime(B,theta)*dZ(:,1));
  dWe=dB*X';
  dX=We'*dB;
end

