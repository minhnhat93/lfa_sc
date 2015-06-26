function Wd = dict_learn( X, alpha, coeff_size, conv_thres )
%DICT_LEARN Summary of this function goes here
%   Wd = dict_learn( X, alpha, coeff_size, conv_thres )
  Wd=col_norm(rand(size(X,1),coeff_size),2);
  %%
  disp('Training');
  iter=0;
  Wd_diff=Inf;
  while any(abs(Wd_diff(:))>=conv_thres)
    t=mod(iter,size(X,2))+1;
    iter=iter+1;
    Zstar=cod(X(:,t), Wd, alpha, conv_thres);
    %%
    dEWd=zeros(size(Wd));
    for u=1:size(X,1)
      for v=1:coeff_size
        dEWd(u,v)=(sum(Wd(u,:).*Zstar(:)')-X(u,t))*Zstar(v);
      end
    end
    Wd_diff=dEWd/iter;
    Wd=col_norm(Wd-Wd_diff,2);
    %%
    disp(['Iteration ' num2str(iter,'%d') ': ']);
    k=abs(Wd_diff(:))==max(abs(Wd_diff(:)));
    %disp(num2str(max(abs(Wd_diff(:))),'%.5f'));
    disp(num2str(Wd_diff(k),'%.5f'));
  end
  disp('Finished');
end