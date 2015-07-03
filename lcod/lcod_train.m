function network = lcod_train( X, Wd, Zstar, alpha, T, num_of_classes, learning_rate, conv_thres, conv_count_thres )
%TRAIN Summary of this function goes here
% X: training input signal nxm (m input of size n)
% W: dictionary nxk (k basis vector size n)
% Zstar: kxm (m sparse code with coeffs size k)
% alpha: sparse penalty
% T: depth of the neural network
% P: number of training iteration
% Training use Back-propagation through time
% Learning rate is n(j)=1/(learning_rate.alpha*(t+t0))
% Ask Ms. Homa about the alpha value
  %initialize variables
  disp(strcat({'Alpha is '}, num2str(alpha)));
  disp(strcat({'Network depth is '}, num2str(T)));
  disp(strcat({'Convergence threshold is '}, num2str(conv_thres)));
  We=Wd';
  S=eye(size(Wd'*Wd))-(Wd'*Wd);
  P=size(X,2);
  theta=alpha*ones(size(Zstar,1),1);
  %for j=1:num_iter
  %dWe=Inf; dS=Inf; dtheta=Inf;
  j=0;
  conv_count=0;
  %%
  while true
    j=j+1;
    idx=mod(j-1,P)+1;
    disp(strcat({'Iteration '},num2str(j)));
    [Z,K,b,e,B]=lcod_fprop(X(:,idx),We,S,theta,T);
    [dWe,dS,dtheta,dX]=lcod_bprop(X(:,idx),Zstar(:,idx),Z,We,S,theta,e,K,b,B,T);
    %%
    conv_coef=1/(learning_rate.alpha*...
      (double((idivide(uint64(j-1),uint64(num_of_classes))+1)))+learning_rate.t0);
    We=We-conv_coef*dWe; We=col_norm(We',2)';
    S=S-conv_coef*dS;
    theta=theta-conv_coef*dtheta;
    %%
    max(abs(conv_coef*dWe(:)))
    max(abs(conv_coef*dS(:)))
    max(abs(conv_coef*dtheta(:)))
%     sp=lcod_fprop(X(:,idx),We,S,theta,T);
%     subplot(2,2,1); plot(Zstar(:,idx));
%     subplot(2,2,2); plot(Wd*Zstar(:,idx));
%     subplot(2,2,3); plot(sp);
%     subplot(2,2,4); plot(Wd*sp);
%     pause;
    %%
    if any(conv_coef*[max(abs(dWe(:))); max(abs(dS(:))); max(abs(dtheta(:)))]>=conv_thres)
      conv_count=0;
    else
      conv_count=conv_count+1;
    end
    if (conv_count==conv_count_thres)
      break;
    end
  end
  network.We=We;
  network.S=S;
  network.theta=theta;
  network.alpha=alpha;
  network.T=T;
  network.conv_thres=conv_thres;
  disp('Finished');
end