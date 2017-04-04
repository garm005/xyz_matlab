function mat2cst(a,nombre)
% __________________________________________________
% Esta funcion escribe un archivo de texto plano (*.cst) a partir
% de una variable mat, que contiene los datos de un levantamiento
% de perfiles.
% 
% Inputs de la funcion:
%              a : nombre de la variable donde se encuentra los
%                  datos.
%              nombre: nombre del archivo cst donde se guardaran los datos
% Este rutina se puede podria anteceder al uso del script
% xyz_p_profilecst.m
%
% Las columnas que debera tener la variable:
% Columna 1-6: Año, Mes, Dia, Hora, Minutos, Segundos
%           7: Coordenada X
%           8: Coordenada Y
%           9: Altura Ortometrica
%          10: Altura Elipsoidal
% 
% Las columnas del archivo cst corresponden a:
% Columna   1: No. consecutivo
%         2-6: Año, Mes, Dia, Hora, Minutos, Segundos
%           7: Coordenada X
%           8: Coordenada Y
%           9: Altura Ortometrica
%          10: Altura Elipsoidal
% Script escrito por Gabriel Ruiz
% CINVESTAV-LAPCOF, 2013
% gruizm@mda.cinvestav.mx
% ________________________________________________________________________

% Abriendo el archivo
fid = fopen(nombre,'w');

% Exportando los datos al archivo cst
for i = 1: length(a)
    fprintf(fid,'%0.6i %0.2i %0.2i %0.2i %0.2i %0.2i %0.2i %10.3f %11.3f %4.3f %4.3f\r\n',i,a(i,1),...
           a(i,2),a(i,3),a(i,4),a(i,5),a(i,6),a(i,7),a(i,8),a(i,9),a(i,10));
end

% Cerrando el archivo
fclose all;