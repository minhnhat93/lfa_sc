function network = gd_train( X, network, learning_rate, convergence,...
  num_of_classes, error_check_iter )
% network = gd_train( X, network, learning_rate, convergence, num_of_classes,
%           error_check_iter )
%
  We1=network.We1;
  S1=network.S1;
  theta1=network.theta1;
  T1=network.T1;
  We2=network.We2;
  S2=network.S2;
  theta2=network.theta2;
  T2=network.T2;
  %%
  Xp=gd_fprop_mass(X,network.We1,network.S1,network.theta1,network.T1,...
    network.We2,network.S2,network.T2,network.theta2,network.G,network.D);
  err=abs(X-Xp);
  LW1=0.5*mean(err(:).*err(:))*size(err,1);
  network.error=Inf;
  best_network=network;
  %%
  P=size(X,2);
  conv_count=0;
  j=0;
  while j<convergence.max_iter
    j=j+1;
    idx=mod(j-1,P,idx);
    [~,A,Z]=dg_fprop(X(:,idx),We1,S1,theta1,T1,We2,S2,theta2,T2network.D,network.G);
    [dG,dD]=dg_bprop(X(:,idx),A,Z,W1,theta1,T1,W2,theta2,T2);
    conv_coef=1/(learning_rate.alpha*...
      (double((idivide(uint64(j-1),uint64(num_of_classes))+1)))+learning_rate.t0);
    network.G=network.G-conv_coef*dG;
    network.D=network.D-conv_coef.*dD;
    if mod(j,error_check_iter)==min([1;error_check_iter-1]) || j==max_iter
      fprintf('Iteration %d:\n',j);
      Xp=gd_fprop_mass(X,network.We1,network.S1,network.theta1,network.T1,...
        network.We2,network.S2,network.T2,network.theta2,network.G,network.D);
      err=abs(X-Xp);
      LW=0.5*mean(err(:).*err(:))*size(err,1);
      network.error=LW;
      fprintf('dG:   %e\n',max(abs(dG(:)))*conv_coef);
      fprintf('dD:   %e\n',max(abs(dD(:)))*conv_coef);
      fprintf('LW:   %e\n',LW);
      fprintf('Diff: %f%%\n',(LW-LW1)/LW1*100);
      if network.error<best_network.error
        best_network=network;
      end
      if abs(LW-LW1)/LW1>convergence.conv_thres
        conv_count=0;
      else
        conv_count=conv_count+1;
      end
      if conv_count==convergence.conv_count_thres
        break;
      end
      LW1=LW;
    end
  end
  if isinf(best_network.erro); best_network=network; end;
  network=best_network;
  fprintf('Finished.\n');
end