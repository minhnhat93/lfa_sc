function [ dWe, dS, dtheta, dX ] = lcod_bprop( X, Zstar, Z, We, S, theta, e, K, b, B, T )
%LCOD_BPROP Summary of this function goes here
% d<something> mean derivative of L with respect to <something>
% [ dWe, dS, dtheta, dX ] = lcod_bprop( X, Zstar, Z, We, S, theta, e, K, b, B, T )
% Input:
%  lcod_bprop( X, Zstar, Z, We, S, theta, e, k, b, B, T )
%  e,k,b,B result of lcod_fprop
% Output:
%   dWe, dS, dtheta, dX, Z
  dS=zeros(size(S));
  dZ=zeros(size(Z));
  %sum(abs(Z-Zstar))
  dB=h_prime(B,theta)*(Z-Zstar);
  dtheta=zeros(size(theta));
  for t=T-1:-1:1
    k=K(t); de=sum(dB.*S(:,k));
    dS(:,k)=dS(:,k)+dB*e(t);
    dB(k)=dB(k)+h_prime(b(t),theta(k))*(dZ(k)+de);
    dtheta(k)=dtheta(k)-sign(b(t))*h_prime(b(t),theta(k))*(dZ(k)+de);
    %disp(num2str(dZ(k),'dZ(k) is %d'));
    dZ(k)=-de;
%     sum(dS(:))
  end
  dWe=dB*X';
  dX=We'*dB;
end