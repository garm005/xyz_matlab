function xyz_clean_file_blanks(opt)
% _________________________________________________________________________
% Esta funcion elimina todas las lineas de un registro de datos que presenta
% la recurrencia de cierto valor para una determinanda columna
% 
% Inputs:
%        opt = 1, ejecutar para un archivo, opt = 2 multiples archivos
%        proporcionar la ruta de acceso donde se encuentran los archivos
%        *.dat
%
% Outputs:
%        -> archivo txt con registro de datos filtrados
%
%
% Gabriel Ruiz, 2014
% LAPCOF
%__________________________________________________________________________
clc;

if nargin ~=1
   error('Son muchos los argumentos de entrada en la funcion. Intenta de nuevo!');
end
if opt < 1 && opt > 2
   error('valor de opt incorrecto. Intenta de nuevo!'); 
end

% Ruta de acceso donde se localiza este script
dircur = pwd;

if opt == 1
    [dirdat,ruta] = uigetfile('*.dat','Selecciona el archivo donde se encuentran el archivo *.dat');
    if dirdat ==0
        error('No se selecciono ninguna carpeta'); 
    end
    % Generando el path del archivo que se analizara
    file2run = fullfile(ruta,dirdat);
    
    % Cargando los datos
    datos = load(file2run);
    
    % Modificando el nombre del archivo y guardando
    namecaso = strrep(dirdat,'_','-');
    seeknkill(ruta,namecaso,datos);
else
    % Especificando la ruta de la carpeta donde se almacenaran los archivos txt
    dirdat = uigetdir('C:\','Selecciona el directorio donde se encuentran los archivos *.dat');
    if dirdat ==0
        error('No se selecciono ninguna carpeta'); 
    end

    % Cambiando flujo del programa a la carpeta donde se encuentran los
    % archivos txt.
    cd(dirdat);

    % Guardando en variables las caracteristicas de los archivos txt que se
    % encuentren en la carpeta seleccionada
    casos = dir('*.dat');

    % Conociendo el numero de archivos que analizaran
    ncasos = numel(casos);

    for i = 1 : ncasos
        file2run = horzcat(dirdat,'\',casos(i).name);
        datos = load(file2run);
        namecaso(i,:) = strrep(casos(i).name,'_','-');
        seeknkill(dirdat,namecaso(i,:),datos);
    end
end

% Regresando a la carpeta donde se encuentra el script
cd(dircur);
fprintf('Ha concluido la execucion de cleanfileblank\n');
return

% ***************************
% * S U B F U N C I O N E S *
% ***************************
function seeknkill(folder,nombre,triada)
% Identificando el valor que corresponde a la celdas que se quiere
% eliminar
ve = mode(triada(:,3));
    
% Encontrando las linea a eliminar
[ind,~] = find(triada(:,3)==ve);
    
% Eliminando lineas
triada(ind,:) = [];
    
%Exportando los resultados (K=kriging,B=Blank,F=filtrado)
fid = fopen(fullfile(folder,horzcat(nombre(1:1:end-9),'BF.txt')),'w');
for k = 1:length(triada)
        fprintf(fid,'%9.3f\t %10.3f\t %8.3f\r\n',triada(k,1),triada(k,2),triada(k,3));
end
fclose all;
return
    