function J = h_prime( V, theta )
%H_PRIME Summary of this function goes here
%   Detailed explanation goes here
% Ask Ms Homa about degraded case where abs(V_i)-theta_i=0
  h=h_theta(V,theta);
  J=diag(h~=0);
end