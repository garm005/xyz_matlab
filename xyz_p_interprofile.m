function escarpe = xyz_p_interprofile(datos)

%% Revisando que un punto no tenga dos elevaciones 
% y con ello, tener una serie en orden monotonico para la interpolacion de los puntos
[~,iu,~] = unique(datos(:,1),'rows','stable');
datos = datos(iu,:);
   
%% Estableciendo las distancias relativas de cada punto del perfil
% escarpe.seg: col. 1 dist. relativas entre ptos y col. 2 dist. total acum.
   for k = 1:length(datos)
        if k == 1
           escarpe.seg(k,1) = 0;
           escarpe.seg(k,2) = 0;
        else
%            fprintf('calculando distancia relativa del punto %i\n',k);
           escarpe.seg(k,1) = sqrt((datos(k,1) - datos(k-1,1))^2 + (datos(k,2) - datos(k-1,2))^2);
%            fprintf('calculando total acum del punto %i\n',k);
           escarpe.seg(k,2) = escarpe.seg(k-1,2)+escarpe.seg(k,1);
        end
   end
   
%% Estableciendo los puntos donde se interpolara el perfil (esp. 1 cm)
escarpe.xainter = (min(escarpe.seg(:,2)):0.05:max(escarpe.seg(:,2)))';
      
%% Interpolando el perfil
escarpe.perfilinter = interp1(escarpe.seg(:,2),datos(:,3),escarpe.xainter);