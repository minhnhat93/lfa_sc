function Z = ista_nn( X, We, S, theta, numiter )
%emulate ista neural network for k iterations
  Z=zeros(size(X));
  for i=1:numiter
    Z=shrink_f(We*X+S*Z,theta);
  end
end