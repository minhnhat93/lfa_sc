function [Wd, w] = col_norm( Wd, norm_mode )
%COL_NORM Summary of this function goes here
%[Wd, w] = col_norm( Wd, norm_mode )
  w=zeros(size(Wd,2),1);
  for j=1:size(Wd,2)
    w(j)=norm(Wd(:,j),norm_mode);
    Wd(:,j)=Wd(:,j)/w(j);
  end
end