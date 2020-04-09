function datos = xyz_preview_ptos
% _________________________________________________________________________
% Funcion que me permite visualizar todos los puntos de varios archivos txt
% con datos xyz. Considerando que la 1er col. pertenece a valores de X, la
% 2da. a valores de Y y la 3ra. a Z
% Sintaxis:
%           var_out = xyz_preview_ptos
%
% Inputs:
%        todos los archivos a visualizar deberan estar almacenados en una
%        misma carpeta y a traves de una ventana grafica se proporcionara
%        la ubicacion de esta.
%
% Output:
%        grafico con los puntos 2D de los archivos proporcionados. Se
%        encuentra activada la funcion brush para seleccionar datos.
%        var_out -> variable celda con valores de los puntos
%
% Ejemplo:
%        datos = xyz_preview_ptos;
%
% Gabriel Ruiz 2014
% LAPCOF
% _________________________________________________________________________
% Ruta de acceso donde se localiza este script
dircur = pwd;

% Especificando la ruta de la carpeta donde se almacenaran los archivos txt
dirdat = uigetdir('C:\','Selecciona el directorio donde se encuentran los archivos *.txt');
if dirdat ==0
   error('No se selecciono ninguna carpeta'); 
end

% Cambiando flujo del programa a la carpeta donde se encuentran los
% archivos txt.
cd(dirdat);

% Guardando en variables las caracteristicas de los archivos txt que se
% encuentren en la carpeta seleccionada
casos = dir('*.txt');

% Conociendo el numero de archivos que analizaran
ncasos = numel(casos);

figure;
hold on

for i = 1 : ncasos
    % Generando el path del archivo que se analizara
    file2run = horzcat(dirdat,'\',casos(i).name);
    
    % Cargando los datos
    d = load(file2run);
    
    x = d(:,1);
    y = d(:,2);
    cm = [rand(1) rand(1) rand(1)];
    plot(x,y,'LineStyle','none','Marker','.','MarkerEdgeColor',cm,'MarkerFaceColor',cm);
    
    xim(i) = min(d(:,1));
    yia(i) = min(d(:,2));
    xima(i) = max(d(:,1));
    yima(i) = max(d(:,2));
    
    datos{i,1} = d;
end

% Ajustando los ejes
axis equal
axis([min(xim) max(xima) min(yia) max(yima)]);

jframe = get(handle(gcf),'JavaFrame');
pause(0.01);
jframe.setMaximized(true);

brush on
return