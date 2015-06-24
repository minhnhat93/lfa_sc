function network = lcod_train( X, W, Zstar, alpha, T, num_iter )
%TRAIN Summary of this function goes here
% X: training input signal nxm (m input of size n)
% W: dictionary nxk (k basis vector size n)
% Zstar: kxm (m sparse code with coeffs size k)
% alpha: sparse penalty
% T: depth of the neural network
% P: number of training iteration
% Training use Back-propagation through time
% Ask Ms. Homa about the alpha value
  %initialize variables
  disp(strcat({'Alpha is '}, num2str(alpha)));
  disp(strcat({'Network depth is '}, num2str(T)));
  disp(strcat({'Num_iter is '}, num2str(num_iter)));
  We=W';
  L=max(eig(W'*W))+0.1;
  S=eye(size(W'*W))-1/L*(W'*W);
  P=size(X,2);
  theta=alpha*ones(size(Zstar,1),1);
  for j=1:num_iter
    disp(strcat({'Iteration '},num2str(j)));
    [Z,k,b,e,B]=lcod_fprop(X(:,mod(j-1,P)+1),We,S,theta,T);
    [dWe,dS,dtheta,dX]=lcod_bprop(X(:,mod(j-1,P)+1),Zstar(:,mod(j-1,P)+1),Z,We,S,theta,e,k,b,B,T);
    We=We-1/j*dWe;
    S=S-1/j*dS;
    theta=theta-1/j*dtheta;
%     sum(dWe(:))
%     sum(dS(:))
%     sum(dtheta(:))
  end
  network.We=We;
  network.S=S;
  network.theta=theta;
  network.T=T;
  network.num_iter=num_iter;
end