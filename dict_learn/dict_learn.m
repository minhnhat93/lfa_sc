function Wd = dict_learn( X, Wd, alpha, coeff_size, lr, conv_thres, conv_count, max_iter )
%DICT_LEARN Summary of this function goes here
%   Wd = dict_learn( X, alpha, coeff_size, conv_thres )
  if all(Wd(:)==0)
    Wd=col_norm(rand(size(X,1),coeff_size),2);
  end;
  %%
  disp('Training');
  j=0;
  Wd_diff1=0;
  count=0;
  while j<max_iter
    j=j+1;
    t=mod(j,size(X,2))+1;
    Wt=Wd'*Wd;
    S=eye(size(Wt))-Wt;
    Zstar=cod(X(:,t), Wd, S, alpha, 10e-4);
    %%
    dEWd=(repmat(sum(Wd.*repmat(Zstar',size(X,1),1),2)-X(:,t),1,coeff_size))...
      .*repmat(Zstar',size(X,1),1);
%     for u=1:size(X,1)
%       %dEWd(u,:)=(repmat(sum(Wd(u,:).*Zstar(:)')-X(u,t),1,coeff_size)).*Zstar';
% %       for v=1:coeff_size
% %         dEWd(u,v)=(sum(Wd(u,:).*Zstar(:)')-X(u,t))*Zstar(v);
% %       end
%     end
    Wd_diff=1/(lr.alpha*(lr.t0+j))*dEWd;
    Wd=col_norm(Wd-Wd_diff,2);
    %%
    fprintf('Iteration %d:\n',j);
    fprintf('Mean: %e\n',mean(abs(Wd_diff(:))));
    fprintf('Max:  %e\n',max(abs(Wd_diff(:))));
    fprintf('Grad: %e\n',max(abs(dEWd(:))));
    if max(abs(Wd_diff1(:)./Wdiff))<conv_thres
      count=count+1;
    else
      count=0;
    end
    if count==conv_count
      fprintf('Converged.');
      break;
    end
    Wd_diff1=Wd_diff;
  end
  disp('Finished');
end