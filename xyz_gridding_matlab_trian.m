function datos = xyz_gridding_matlab_trian(ruta,filea,deltax,deltay,nexport,flagexpo)
%% Funcion que genera una malla numerica espacialmente uniforme, a partir
% de la interpolacion lineal de datos.
%
% Los resultados de la interpolacion pueden ser exportados a un
% archivo *.grd (para graficarse en Grapher o Surfer) o pueden ser
% almacenados en una estructura donde se encuentran todas las variables
% requeridas para volver a realizar la interpolacion, asi como las
% coordenadas ya interpoladas.
% 
% Inputs:
%        ruta = ruta de acceso donde se encuentra el archivo xyz o txt
%        filea = nombre del archivo con los datos a interpolar. El archivo
%                en su 1er columna debera tener los datos corresponden a
%                los valores de X, 2da columna valores Y, 3er columna
%                valores Z
%        deltax = valor de la resolucion de las celdas en x
%        deltay = valor de la resolucion de las celdas en y
%        flagexpo = si flagexpo = 1 los resultados se importan a un archivo mat
%               flagexpo = 2 los resultados se importan a un archivo xyz
%               flagexpo = 3 los resultados se importan a archivos mat y
%               xyz.
% Output:
%       datos = estructura con todos que contiene todas las variables
%               requeridas para realizar la interpolacion de datos
% Ejemplo:
% ruta = 'D:\Gabriel\Matlab Files\Matlab Files Cinvestav\TratamientoBatimetrias\';
% filea = 'BatiRegionalLocalProgreso.txt';
% datos =  xyz_gridding_matlab_trian(ruta,filea,5,5,'prueba',3);
%
% Programo: Gabriel Ruiz Mtz.
% _________________________________________________________________________

if nargin ~=6
   error('faltan argumentos de entrada en la funcion. Intenta de nuevo!');
end

if flagexpo < 1 && flagexpo > 3
   error('valor de flagexpo incorrecto. Intenta de nuevo!'); 
end

%% Creando el nombre del archivo
%ruta = 'D:\Gabriel\Matlab Files\Matlab Files Cinvestav\TratamientoBatimetrias';
%filea = 'Progreso5_Dx1m.xyz';
patha = horzcat(ruta,filea); 

%% Importando los datos a matlab
bati =importdata(patha);

%% Conociendo los valores maximos y minimos que serviran
% para definir la malla de computo
datos.xmin = min(bati(:,1));
datos.xmax = max(bati(:,1));
datos.ymin = min(bati(:,2));
datos.ymax = max(bati(:,2));

%% Asignando variables a columnas para su facil identificacion
datos.x = bati(:,1);
datos.y = bati(:,2);
datos.z = bati(:,3);

%% Agregando a los datos, la informacion del espaciamiento espacial
datos.deltax = deltax;
datos.deltay = deltay;

%% Estableciendo la resolucion espacial de la malla
%deltax = 5;
%deltay = 6;

%% Construyendo los vectores de x y y para crear la malla
datos.xd = datos.xmin:datos.deltax:datos.xmax;
datos.yd = datos.ymin:datos.deltay:datos.ymax;

%% Generando la malla numerica
[datos.XX,datos.YY] = meshgrid(datos.xd,datos.yd);

%% Interpolando los valores de z
fprintf('Si hay muchos datos que interpolar... tener paciencia...\n');
datos.ZZ = griddata(datos.x,datos.y,datos.z,datos.XX,datos.YY);

%% Graficando la batimetria
[con,han] = contourf(datos.XX,datos.YY,datos.ZZ,'LineStyle','None');
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
print(gcf,'-dpng','-r300',horzcat(nexport,'.png'));

%% Obteniendo el valor min y max de z
datos.zmin = min(min(datos.ZZ));
datos.zmax = max(max(datos.ZZ));

%% Exportando datos
switch flagexpo
    case 1
          export2mat(nexport,datos);
    case 2
          export2grdSurfer(nexport,datos);
    case 3
          export2mat(nexport,datos);
          export2grdSurfer(nexport,datos);
end

%% Limpiando el workspace
clear all
return

% ***************************
% * S U B F U N C I O N E S *
% ***************************
function export2mat(archi,a)
% _________________________________________________
% Subfuncion que exporta los datos de Z a un archivo .mat
% Inputs:
% archi = nombre del archivo donde se exportaran los datos
% a = estructura de celdas con todos lo valores almacenados
% Gabriel Ruiz
% _________________________________________________
save(horzcat(archi,'.mat'),'a','-mat');
return

function export2grdSurfer(archi,a)
% ____________________________________________________
% Subfuncion que exporta los datos de Z a un archivo *.GRD Surfer 6 Text
% Grid.
% Inputs:
% archi = nombre del archivo donde se exportaran los datos
% a = estructura de celdas con todos lo valores almacenados
%
% Esta subfuncion esta basada en el script de Alberto Avila.
% Gabriel Ruiz
% ____________________________________________________

% Abriendo el archivo de exportacion
fid = fopen(horzcat(archi,'.grd'),'w');

% Exportando las coordenadas ya rotadas a un archivo xyz
fprintf(fid,'%4s\n','DSAA');
fprintf(fid,'%i %i\n',[length(a.xd) length(a.yd)]);
fprintf(fid,'%f %f\n',[a.xmin a.xmax]);    
fprintf(fid,'%f %f\n',[a.ymin a.ymax]); 
fprintf(fid,'%f %f\n\n',[a.zmin a.zmax]);
for f=1:length(a.yd)                                 % Write matrix
    for c=1:length(a.xd)
       fprintf(fid,'%g %c',a.ZZ(f,c),' ');
    end
    fprintf(fid,'\n');
end
          
fclose all;
return



