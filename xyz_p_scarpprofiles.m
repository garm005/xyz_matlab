function escarpe = xyz_p_scarpprofiles(gber)
% ________________________________________________________________________
% Esta funcion encuentra los escarpes del perfil de playa
%
%
%
%
% Esta funcion es un complemento de la funcion xyz_p_splitprofiles_elev
%
% Gabriel Ruiz Martinez
% Abril 2015
% ________________________________________________________________________

if nargin ~= 1
   error('No se proporciono uno de los inputs de la funcion');
end

if verLessThan('matlab', '7.14.0.739')
   error('Esta funcion necesita ejecutarse en una version mas reciente de matlab');
end

%% Agregando la funcion de savefig a matlab
%
addpath(genpath('C:\Users\Gabriel\Documents\Matlab_Files\savefig_matlab_exchange'));
 
%% Abriendo archivo con datos
[dirdat,ruta] = uigetfile({'*.txt';'*.xyz';'*.dat';'*.mat'},'Selecciona el archivo donde se encuentran los datos X,Y,Z');
if dirdat ==0
   error('No se selecciono ninguna carpeta'); 
end

%% Generando el path del archivo que se analizara
file2run = fullfile(ruta,dirdat);

%% Cargando los datos
datos = load(file2run);

%% Eliminando los puntos acuaticos
ptosH20 = find(datos(:,3) < 0);
datos(ptosH20,:) = [];
   
%% Encontrando las coordenadas donde inicio el perfil aereo de la playa
inipro = datos(1,1:2);
   
%% Encontrando las coordenadas donde termina el perfil aereo
finpro = datos(end,1:2);
   
%% Revisando que un punto no tenga dos elevaciones 
% y con ello, tener una serie en orden monotonico para la interpolacion de los puntos
[~,iu,~] = unique(datos(:,1),'rows','stable');
datos = datos(iu,:);
   
%% Reporte de los perfiles donde hay un perfil que contiene ptos repetidos
%qw = histc(iv,1:numel(iu));
%qww = tmp(qw ~= 1);
%for o = 1 : length(qww);
%   fprintf('En el perfil %i hay %i ptos repetidos. Eliminando...\n',j,o);
%end
   
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
    
%% Optimizando: criterio de la 2da derivada para extremos
% Razon de cambio de las variaciones de la playa, adim
der2 = diff(escarpe.perfilinter,2);
   
%% Agregando las dos primeras lineas que se eliminan al diferenciar,
% esto lo hago para que la matriz tenga la misma dimension de xainter y 
% poder graficarlas.
escarpe.deri2 = zeros(length(der2) + 2,1);
escarpe.deri2(3:end,1) = der2;
   
%% Encontrando el inicio y final del escarpe
[az,~] =find(escarpe.deri2 == min(escarpe.deri2));
[azz,~] =find(escarpe.deri2 == max(escarpe.deri2));
   
%% Conociendo las caracteristicas del escarpe: 
% ancho, altura, coordenadas donde inicia y termina el escarpe
escarpe.dis = abs(escarpe.xainter(az,1)-escarpe.xainter(azz,1)); 
escarpe.h = abs(escarpe.perfilinter(az,1)-escarpe.perfilinter(azz,1));
escarpe.top = escarpe.xainter(az,1);
escarpe.top = escarpe.perfilinter(az,1);
escarpe.bottom = escarpe.xainter(azz,1);
escarpe.bottom = escarpe.perfilinter(azz,1);
   
%% Graficando los perfiles
if gber == 1
       figure;
       subplot(2,1,1);   % graficando el perfil con datos interpolados y la ubicacion
       plot(escarpe.xainter,escarpe.perfilinter,'-k','LineWidth',2);  % de la berma
       grid on;
       title(horzcat('Profile',num2str(j)));
       set(gca,'XMinorTick','on','YMinorTick','on');
       hold on
       plot(escarpe.xainter(az,1),escarpe.perfilinter(az,1),'LineWidth',2,'Marker','o',...
           'MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',4);
       plot(escarpe.xainter(azz,1),escarpe.perfilinter(azz,1),'LineWidth',2,'Marker','o',...
           'MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',4);
       set(gca,'XMinorTick','on','YMinorTick','on');
       xlabel('Distancia hacia altamar, [m]');
       ylabel('Elevacion, [m]');
       subplot(2,1,2)
       plot(escarpe.xainter,escarpe.deri2,'-k','LineWidth',2);
       grid on;
       set(gca,'XMinorTick','on','YMinorTick','on');
       xlabel('Distancia hacia altamar, [m]');
       ylabel({'Pendiente del cambio de las';'variaciones del perfil, [adim]'});
else
       figure;
       plot(datos(:,3));
       grid on;
       title(horzcat('Profile',num2str(j)));
       xlabel('Distancia hacia altamar, [m]');
       ylabel('Elevacion, [m]');
end
% savefig_matlab_exchange(horzcat('Profile',num2str(j)),'jpeg','-c0.1', '-r600');
%close(gcf);

%% Guardando analisis del escarpe en celda
%profiles{j,2} = escarpe;

return

