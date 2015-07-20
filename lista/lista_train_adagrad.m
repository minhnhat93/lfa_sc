function network = lista_train_adagrad( X, Zstar, network, num_of_classes, learning_rate, max_iter, conv_thres, conv_count_thres, error_check_iter )
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
  disp(strcat({'Alpha is '}, num2str(network.alpha)));
  disp(strcat({'Network depth is '}, num2str(network.T)));
  disp(strcat({'Convergence threshold is '}, num2str(network.conv_thres)));
  %%
  T=network.T;
  conv_thres=network.conv_thres;
  best_network=network;
  P=size(X,2);
  %%
  conv_count=0;
  %%
  if isinf(network.error)
    LWm=zeros(size(X,2),1);
    Z=mass_lista_fprop(X,network.We,network.S,network.theta,T);
    err=Zstar-Z;
    for i=1:size(X,2)
      LWm(i)=norm(err(:,i),2)^2;
    end
    LW1=0.5*mean(LWm);
    skip_first_error_check=false;
    j=0;
  else
    LW1=network.error;
    skip_first_error_check=true;
    j=network.iter;
  end
  fprintf('Starting error is: %d\n',LW1);
  G=0.1*ones(numel(network.We)+numel(network.S)+numel(network.theta),1);
  while j<max_iter
    %fprintf('Iteration %d\n',j);
    j=j+1;
    idx=mod(j-1,P)+1;
    [~,Z,C,B]=lista_fprop(X(:,idx),network.We,network.S,network.theta,T);
    [dWe,dS,dtheta,dX]=lista_bprop(X(:,idx),Zstar(:,idx),Z,network.We,network.S,network.theta,C,B,T);
    %%
    cG=[dWe(:);dS(:);dtheta(:)];
    G=G+cG.*cG;
    grad=1/learning_rate.alpha*sqrt(G).*cG;
    gradWe=reshape(grad(1:numel(network.We)),size(network.We));
    gradS=reshape(grad(numel(network.We)+1:numel(network.We)+numel(network.S)),size(network.S));
    gradtheta=reshape(grad(numel(network.We)+numel(network.S)+1:end),size(network.theta));
    network.We=network.We-gradWe; %network.We=col_norm(network.We',2)';
    network.S=network.S-gradS;
    network.theta=network.theta-gradtheta;
    %%
    if (mod(j,error_check_iter)==min([1;error_check_iter-1]) || j==max_iter)...
       && ~skip_first_error_check
      fprintf('Iteration %d:\n',j);
      %tic;
      Z=mass_lista_fprop(X,network.We,network.S,network.theta,T);
      %toc;
      err=Zstar-Z;
      %tic;
      for i=1:size(X,2)
        LWm(i)=norm(err(:,i),2)^2;
      end
      %toc;
      LW=0.5*mean(LWm);
      mdWe=max(abs(gradWe(:)));
      mdS=max(abs(gradS(:)));
      mdtheta=max(abs(gradtheta(:)));
      fprintf('dWe:    %e\n',mdWe);
      fprintf('dS:     %e\n',mdS);
      fprintf('dtheta: %e\n',mdtheta);
      fprintf('L1(W):  %e\n',max(mean(abs(err),1)));
      fprintf('L(W):   %e\n',LW);
      fprintf('L Diff: %f %%\n',100*(LW-LW1)/LW1);
      network.error=LW;
      %%
      if network.error<best_network.error
        best_network=network;
        best_network.iter=j;
      end
      if (abs(LW-LW1)/LW1>conv_thres)
        conv_count=0;
      else
        conv_count=conv_count+1;
      end
      if (conv_count==conv_count_thres)
        break;
      end
      LW1=LW;
    end
    skip_first_error_check=false;
  end
  if isinf(best_network.error); best_network=network; end;
  network=best_network;
  disp('Finished');
end