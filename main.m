iters=[0; 1; 5; 10];
t0_lcod=[0;0;0;0];
t0_lista=[0;0;89;399];
% for j=1:numel(iters)
%   lcod_train_script(iters(j)+1,t0_lcod(j));
% end
for j=1:numel(iters)
  lista_train_script(iters(j),t0_lista(j));
end