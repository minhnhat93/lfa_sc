function Z = mass_lista_fprop( X, We, S, theta, T )
%LISTA_FPROP Summary of this function goes here
% [ Z0, Z, C, B ] = lista_fprop( X, We, S, theta, T )
%   Detailed explanation goes here
  B=We*X;
  Z=h_theta(B,theta);
  for t=1:T
    Z=h_theta(B+S*Z,theta);
  end
end