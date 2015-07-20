function [Xout,A,Z]=dg_fprop(X,We1,S1,theta1,T1,We2,S2,theta2,T2,G,D)
% Syntax:
% [Xout,A,Z]=dg_fprop(X,We1,S1,theta1,T1,We2,S2,T2,theta2,G,D)
  [a1,Z1,C1,~]=lista_fprop(X,We1,S1,theta1,T1);
  y=G*a1;
  [a2,Z2,C2,~]=lista_fprop(y,We2,S2,theta2,T2);
  Xout=D*a2;
  A=cat(1,tocell(Z1),y,tocell(Z2),Xout);
  Z=cat(1,tocell(C1),a1,tocell(C2),a2);  
end
function C=tocell(M)
  C=cell(1,size(M,2));
  for j=1:size(M,2)
    C{j}=M(:,j);
  end
end