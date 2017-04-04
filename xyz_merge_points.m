function xyz_merge_points(opti)
% ___________________________________________________
% Funcion que une el contenido de dos archivos con datos de x,y,z
% Syntaxis: 
%       xyz_merge_points(opti)
%
% Inputs:
%       opti = 1 por medio de ventanas graficas se proporcionaran los 2
%       archivos, de tipo texto, con los datos a unir.
%       opti = 2 por medio de ventanas graficas se proporcionaran los 2
%       archivos, de tipo mat, con los datos a unir.
%       opti = 3 por medio de ventanas graficas se proporcionaran las 2
%       variables del workspace con los datos a unir.
%
% Output:
%       archivo txt
% Ejemplo:
%       xyz_merge_points(1);
%
% Gabriel Ruiz 2014
% LAPCOF
% _________________________________________________________________________
clc;
clc;

if nargin ~=1
   error('Hay un problema con los argumentos de entrada en la funcion. Intenta de nuevo!');
end
if opti <1 && opti > 3
   error('valor de opt incorrecto. Intenta de nuevo!'); 
end

if opti == 1
        [dirdat,ruta] = uigetfile({'*.dat';'*.txt';'*.xyz'},'Selecciona el archivo donde se encuentran el archivo 1');
        if dirdat ==0
            error('No se selecciono ninguna carpeta'); 
        end
        % Generando el path del archivo que se analizara
        file2run = fullfile(ruta,dirdat);
    
        % Cargando los datos
        a = load(file2run);

        [dirdat1,ruta1] = uigetfile({'*.dat';'*.txt';'*.xyz'},'Selecciona el archivo donde se encuentran el archivo 2');
        if dirdat1 ==0
           error('No se selecciono ninguna carpeta'); 
        end
        file2run1 = fullfile(ruta1,dirdat1);
        b = load(file2run1);
elseif opti == 2
        [dirdat,ruta] = uigetfile('*.mat','Selecciona el archivo donde se encuentran el archivo 1');
        if dirdat ==0
           error('No se selecciono ninguna carpeta'); 
        end
        file2run = fullfile(ruta,dirdat);
        a = load(file2run);
        [dirdat1,ruta1] = uigetfile('*.mat','Selecciona el archivo donde se encuentran el archivo 2');
        if dirdat1 ==0
            error('No se selecciono ninguna carpeta'); 
        end
        file2run1 = fullfile(ruta1,dirdat1);
        b = load(file2run1);
else
        enu = {'Ingresa el nombre de la matriz A:','Ingresa el nombre de la matriz B:'};
        tit = 'Variables a unir:';
        lin = 1;
        valo = {'',''};
        resp = inputdlg(enu,tit,lin,valo);
        a = resp{1,1};
        b = resp{2,1}
end

% Creando una funcion anonima para conocer el tamaño de las columnas
col = @(x) size(x,2);

% Asegurandonos que los datos en ambas matrices sean valores de triadas
if col(a) ~= col(b)
    error('Las columnas de las matrices no coinciden. Intenta de nuevo!');
end

% Uniendo los datos
c = [a;b];

% Exportando los datos
[d2,d1] = uiputfile('*.txt','Exportando datos a:');
fid = fopen(fullfile(d1,d2),'w');
for k = 1:length(c)
        fprintf(fid,'%9.3f\t %10.3f\t %8.3f\r\n',c(k,1),c(k,2),c(k,3));
end
fclose all;