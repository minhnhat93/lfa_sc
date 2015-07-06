function network = lcod_train( X, Wd, Zstar, alpha, T, num_of_classes, learning_rate, max_iter, conv_thres, conv_count_thres, error_check_iter )
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
  display_iter=Inf;
  disp(strcat({'Alpha is '}, num2str(alpha)));
  disp(strcat({'Network depth is '}, num2str(T)));
  disp(strcat({'Convergence threshold is '}, num2str(conv_thres)));
  %%
  network.alpha=alpha;
  network.T=T;
  network.conv_thres=conv_thres;
  network.We=Wd';
  network.S=eye(size(Wd'*Wd))-(Wd'*Wd);
  network.error=Inf;
  best_network=network;
  P=size(X,2);
  network.theta=alpha*ones(size(Zstar,1),1);
  %%
  j=0;
  conv_count=0;
  LW1=Inf;
  %%
  sp=zeros(size(Zstar));
  LWm=zeros(size(X,2),1);
%   fprintf('Calculating base sparse code\n');
%   tic;
%   for i=1:size(X,2)
%       Zstar(:,i)=cod(X(:,i),Wd,S,alpha,1e-4,Inf);
%   end;
%   toc;
  while j<max_iter
    j=j+1;
    idx=mod(j-1,P)+1;
    fprintf('Iteration %d:\n',j);
    [Z,K,b,e,B]=lcod_fprop(X(:,idx),network.We,network.S,network.theta,T);
    [dWe,dS,dtheta,dX]=lcod_bprop(X(:,idx),Zstar(:,idx),Z,network.We,network.S,network.theta,e,K,b,B,T);
    %%
    conv_coef=1/(learning_rate.alpha*...
      (double((idivide(uint64(j-1),uint64(num_of_classes))+1)))+learning_rate.t0);
    network.We=network.We-conv_coef*dWe; network.We=col_norm(network.We',2)';
    network.S=network.S-conv_coef*dS;
    network.theta=network.theta-conv_coef*dtheta;
    %%
    if mod(j,error_check_iter)==0
      %tic;
      Z=mass_lcod_fprop(X,network.We,network.S,network.theta,T);
      %toc;
      err=Zstar-Z;
      %tic;
      for i=1:size(X,2)
        LWm(i)=norm(err(:,i),2)^2;
      end
      %toc;
      LW=0.5*mean(LWm);
      mdWe=max(abs(conv_coef*dWe(:)));
      mdS=max(abs(conv_coef*dS(:)));
      mdtheta=max(abs(conv_coef*dtheta(:)));
      fprintf('dWe:    %e\n',mdWe);
      fprintf('dS:     %e\n',mdS);
      fprintf('dtheta: %e\n',mdtheta);
      fprintf('L1(W):  %e\n',mean(sum(abs(err))));
      fprintf('L(W):   %e\n',LW);
      fprintf('L Diff: %f %%\n',100*(LW-LW1)/LW1);
      network.error=LW;
      %%
      if network.error<best_network.error
        best_network=network;
      end
      if (abs(LW-LW1)/LW1>conv_thres||LW<LW1)
        conv_count=0;
      else
        conv_count=conv_count+1;
      end
      if (conv_count==conv_count_thres)
        break;
      end
      LW1=LW;
    end
    %%
%     if mod(j,display_iter)==0
%       subplot(2,2,1); plot(Zstar(:,idx));
%       subplot(2,2,2); plot(Wd*Zstar(:,idx));
%       subplot(2,2,3); plot(spp);
%       subplot(2,2,4); plot(xpp);
%       pause;
%     end
    fprintf('\n');
  end
  network=best_network;
  disp('Finished');
end