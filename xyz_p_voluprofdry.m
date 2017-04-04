function voluprofdry
% _________________________________________________________________________
% Funcion que calcula si la posicion de la linea 0 puede ser representar
% los cambios volumetricos del perfil de playa. Si r2 es cercana a uno, la
% posicion de la linea 0 es un criterio aceptable.
%
% Inputs:
% Es necesario especificar la ruta de acceso donde se encuentran los
% archivos que tienen los perfiles de playa. Los archivos deberan de ser
% *.txt y deberan tener dos columnas la primera de ellas tendra los valores
% de la distancia transversal del perfil y la 2da. columna debera
% corresponder a los datos de la elevacion del perfil.
% Outputs:
%        se obtienen dos graficas, en una de ellas se muestra la variacion
%        del perfil. En la otra grafica se visualiza el ajuste.
%        se obtiene un archivo *.log con los valores de la distancia
%        transversal y el volumen de arena de cada perfil analizado y al 
%        final le archivo se tiene el valor de r2 del ajuste.
%
% Esta funcion la subfuncion rmsimplefit.
% Gabriel Ruiz, 2014
% _________________________________________________________________________

% Especificando la ruta de la carpeta donde se almacenaran los archivos txt
dirdat = uigetdir('C:\','Selecciona el directorio donde se encuentran los archivos *.txt');
if dirdat ==0
   error('No se selecciono ninguna carpeta'); 
end

% Guardando en variables las caracteristicas de los archivos txt que se
% encuentren en la carpeta seleccionada
casos = dir('*.txt');

% Conociendo el numero de archivos que analizaran
ncasos = numel(casos);

% Dimensionando variable
res = zeros(ncasos,2);

% Abriendo figura
figure;
hold on

for i = 1 : ncasos
    % Generando el path del archivo que se analizara
    file2run = horzcat(dirdat,'\',casos(i).name);
    
    % Cargando los datos
    datos = load(file2run);
    
    % Si el perfil no esta en coordenadas absolutas (que no empieza en 0)
    if datos(1,1) ~= 0
        datos(:,1) =datos(:,1)-min(datos(:,1));
    end
    
    % Encontrando todos los puntos del perfil de playa terrestre
    [ind,~] = find(datos(:,2)>=0);

    % Graficando el perfil aereo
    plot(datos(ind,1),datos(ind,2),'Color',[ rand(1), rand(1), rand(1)]);

    % Guardando la distancia que existe desde la cota 0 al ultimo punto
    % del perfil terrestre, (ancho del perfil seco)
    res(i,1) = datos(ind(end),1);

    % Encontrando el volumen del perfil de playa 
    res(i,2) = trapz(datos(ind,1),datos(ind,2));

    clear ind
end

% Estableciendo titulos a los ejes y exportando la figura
title('Beach profile evolution');
xlabel('Offshore distance (m)');
ylabel('Elevation (m)');
jframe = get(handle(gcf),'JavaFrame');
pause(0.01);
jframe.setMaximized(true);
print(gcf,'-dpng','-r300',horzcat('perfil','.png'));

% Obteniendo la r2, usando la funcion rmsimplefit
figure
[rsq,dafit] = rmsimplefit(res(:,2),res(:,1));

%Exportando los resultados
fid = fopen('resumen.log','w');
for k = 1:length(res)
    fprintf(fid,'%8.3f\t %10.3f\t %8.3f\r\n',res(k,1),res(k,2),dafit(k,1));
end
fprintf(fid,'%5.3f\r\n',rsq);
fclose all;
close all;
return
