function Xp=gd_fprop_mass(X,We1,S1,theta1,T1,We2,S2,T2,theta2,G,D)
% Syntax:
% [Xout,A,Z]=dg_fprop(X,We1,S1,theta1,T1,We2,S2,theta2,T2,G,D)
  a1=lista_mass_fprop(X,We1,S1,theta1,T1);
  y=G*a1;
  a2=lista_mass_fprop(y,We2,S2,theta2,T2);
  Xp=D*a2;
end
