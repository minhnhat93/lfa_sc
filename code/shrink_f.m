function h0 = shrink_f( V, theta )
%implementation of shrinkage function h_0
%SHRINK_F Summary of this function goes here
%   Detailed explanation goes here
  h0=sign(V).*max(abs(V)-theta,zeros(size(V)));
end

