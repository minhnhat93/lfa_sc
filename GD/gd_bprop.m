function [dG,dD]=dg_bprop(X,A,Z,W1,theta1,T1,W2,theta2,T2)
% [dG,dD]=dg_bprop(X,A,Z,W1,theta1,T1,W2,theta2,T2)
%
  err=cell(size(A,1),1);
  j=size(A,2);
  err{j}=A{j}-X;
  dD=A{j-1}*err{j}';
  while T2>0
    j=j-1;
    err{j}=(W2'*err{j+1}).*h_prime(Z{j},theta2);
    T2=T2-1;
  end
  dG=A{j-1}*err{j}';
end