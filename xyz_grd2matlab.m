function datos = xyz_grd2matlab
% ________________________________________________________________________
% Funcion que carga en matlab los datos que se encuentran en un archivo
% grd, generado con surfer (GRD 6 Surfer Text Grid) y grafica el mapa de 
% contornos.
% Sintaxis:
%        var_output = xyz_grd2matlab
% Inputs:
%        A traves de una ventana grafica se proporcionara la ubicacion del 
%        archivo grd
%
% Output:
%        grafico con el mapa de contornos
%        datos = variable celda con todos los datos que se usan en la
%        funcion
%
% Ejemplo:
%        datos = xyz_preview_ptos;
%
% Esta funcion usa el script de Alberto para cargar en matlab el grd.
% Gabriel Ruiz 2014
% LAPCOF
% _________________________________________________________________________

[dirdat,ruta] = uigetfile('*.grd','Selecciona el archivo donde se encuentran el archivo *.grd');
if dirdat ==0
        error('No se selecciono ninguna carpeta'); 
end
%% Generando el path del archivo que se analizara
file2run = fullfile(ruta,dirdat);

%% Cargando el grd en matlab
[datos.ZZ datos.xmin datos.xmax datos.ymin datos.ymax datos.nx datos.ny] = grd_read_v2(file2run);

% Calculando el delta x y y
datos.deltax = (datos.xmax-datos.xmin)/datos.nx;
datos.deltay = (datos.ymax-datos.ymin)/datos.ny;

%% Construyendo los vectores de x y y para crear la malla
datos.xd = datos.xmin:datos.deltax:datos.xmax;
datos.yd = datos.ymin:datos.deltay:datos.ymax;

%% Generando la malla numerica
[datos.XX,datos.YY] = meshgrid(datos.xd,datos.yd);
datos.XX(end,:) = [];
datos.XX(:,end) = [];
datos.YY(end,:) = [];
datos.YY(:,end) = [];

%% Graficando la batimetria
[con,han] = contourf(datos.XX,datos.YY,datos.ZZ,'LineStyle','-');
clabel(con,han);

%% Encendiendo la barra de colores
colorbar;

%% Rotulando la figura
title('Bathymetry');
xlabel('X [m]');
ylabel('Y [m]');
jframe = get(handle(gcf),'JavaFrame');
pause(0.01);
jframe.setMaximized(true);

% Exportando a archivo la grafica
%print(gcf,'-dpng','-r300',horzcat(nexport,'.png'));
return

function [matrix xmin xmax ymin ymax nx ny]=grd_read_v2(namefile)
% Function to read a GRD file
%                  (from Golden Software Surfer, ASCII format)
%
% [matrix xmin xmax ymin ymax]=grd_read_v2(name of file)
%
% Input:
%      nomarch = name of the file to be read, including ".grd" extension
% Output:
%      matrix =  matrix of the read data
%      xmin xmax ymin ymax = grid limits
%
% Coded by Alberto Avila Armella.
%          UPDATED & IMPROVED BY Jose Maria Garcia-Valdecasas
% Modificada por Gabriel Ruiz

grdfile=fopen(namefile,'r');    
code=fgetl(grdfile);            
aux=str2num(fgetl(grdfile)); 
nx=aux(1); 
ny=aux(2);
aux=str2num(fgetl(grdfile)); 
xmin=aux(1); 
xmax=aux(2);
aux=str2num(fgetl(grdfile)); 
ymin=aux(1); 
ymax=aux(2);
aux=str2num(fgetl(grdfile)); 
zmin=aux(1); 
aux(2);
[matrix,count] = fscanf(grdfile, '%f', [nx,ny]);
matrix=matrix';
fclose(grdfile);
return