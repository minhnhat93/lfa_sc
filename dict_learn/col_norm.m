function Wd = col_norm( Wd, norm_mode )
%COL_NORM Summary of this function goes here
%Wd = col_norm( Wd, norm_mode )
  for j=1:size(Wd,2)
    Wd(:,j)=Wd(:,j)/norm(Wd(:,j),norm_mode);
  end
end