function xyz_minmax_profiles
% _________________________________________________________________________
% Esta funcion encuentra los valores maximos y minimos de x,y,z en los
% archivos de los perfiles de playa. 
% 
% Inputs:
%        proporcionar la ruta de acceso donde se encuentran los archivos
%        *.txt
%
% Outputs:
%        -> archivo log donde se exportaron los valores min y max de cada
%                    archivo analizado y tiene el siguiente formato:
%        * nombre del archivo del cual se obtuvo la informacion
%        * Coord X, Coord Y y valor Z minimos del archivo.
%        * Coord X, Coord Y y valor Z maximos del archivo.
%        * valor de los limites del eje de las x donde se grafico el perfil
%        * valor de los limites del eje de las y donde se grafico el perfil
%        -> graficas de las secciones transversales en planta.
%
%
% Gabriel Ruiz, 2014
% LAPCOF
%__________________________________________________________________________
clc;

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

% Dimensionando variable
mini = zeros(ncasos,3);
maxi = zeros(ncasos,3);

for i = 1 : ncasos
    % Generando el path del archivo que se analizara
    file2run = horzcat(dirdat,'\',casos(i).name);
    
    % Cargando los datos
    datos = load(file2run);
    
    % Modificando el nombre del archivo y guardando
    namecaso(i,:) = strrep(casos(i).name,'_','-');
    
    % Encontrando los valores maximos
    mini(i,:) = min(datos);
    maxi(i,:) = max(datos);
    
    % Graficando los perfiles
    plot(datos(:,1),datos(:,2),'LineStyle','none','Marker','.');
    
    % Maquillaje
    title(namecaso(i,:));
    xlabel('X (m)');
    ylabel('Y (m)');
    
    % Exportando la grafica a archivo
    print(gcf,'-dpng','-r300',horzcat(namecaso(i,1:1:end-4),'.png'));
    
    % Encontrando las coordenadas de la ventana que contiene los perfiles
    limxplot = get(gca,'xlim');
    limyplot = get(gca,'ylim');
    
    close(gcf);
    clear datos
end

%Exportando los resultados
fid = fopen(horzcat('resul_minmaxprofiles.log'),'w');
for k = 1:ncasos
    fprintf(fid,'%-30s\r\n',namecaso(k,1:1:end-4));
    fprintf(fid,'%9.3f\t %10.3f\t %8.3f\r\n',mini(k,1),mini(k,2),mini(k,3));
    fprintf(fid,'%9.3f\t %10.3f\t %8.3f\r\n',maxi(k,1),maxi(k,2),maxi(k,3));
    fprintf(fid,'%9.3f\t %9.3f\r\n',limxplot(1,1),limxplot(1,2));
    fprintf(fid,'%10.3f\t %10.3f\r\n\r\n',limyplot(1,1),limyplot(1,2));
end
fclose all;

% Regresando a la carpeta donde se encuentra el script
cd(dircur);
fprintf('Ha concluido la execucion de minmaxprofiles\n');
return