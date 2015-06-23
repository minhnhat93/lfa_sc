function [ dWe, dS, dtheta, dX ] = lcod_bprop( Zstar, X, Z, We, S, theta, e, k, b, B )
%LCOD_BPROP Summary of this function goes here
%  e,k,b,B result of lcod_fprop
  dS=0;
  deltaZ=0;
  deltaB=h_prime(B,theta)*(Z-Zstar);
  for t=T-1:-1:1
    k1=k(t); de=sum(deltaB.*S(:,k1));
    dS(:,k1)=dS(:,k1)+deltaB*e(t);
    deltaB(k1)=deltaB(k1)+h_prime(b(t),theta(k1))*(deltaZ(k1)+de);
    dtheta(k1)=dtheta(k1)-sign(b(t))*h_prime(b(t),theta(k1))*(deltaZ(k1)+de);
    deltaZ(k)=-de;
  end
  dWe=deltaB*X';
  dX=We'*deltaB;
end