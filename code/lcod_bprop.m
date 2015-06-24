function [ dWe, dS, dtheta, dX ] = lcod_bprop( X, Zstar, Z, We, S, theta, e, k, b, B, T )
%LCOD_BPROP Summary of this function goes here
% d<something> mean derivative of L with respect to <something>
% Input:
%  lcod_bprop( X, Zstar, Z, We, S, theta, e, k, b, B, T )
%  e,k,b,B result of lcod_fprop
% Output:
%   dWe, dS, dtheta, dX, Z
  dS=zeros(size(S));
  dZ=zeros(size(Z));
  dB=h_prime(B,theta)*(Z-Zstar);
  dtheta=zeros(size(theta));
  for t=T-1:-1:1
    k1=k(t); de=sum(dB.*S(:,k1));
    dS(:,k1)=dS(:,k1)+dB*e(t);
    dB(k1)=dB(k1)+h_prime(b(t),theta(k1))*(dZ(k1)+de);
    dtheta(k1)=dtheta(k1)-sign(b(t))*h_prime(b(t),theta(k1))*(dZ(k1)+de);
    dZ(k)=-de;
%     sum(dS(:))
  end
  dWe=dB*X';
  dX=We'*dB;
end