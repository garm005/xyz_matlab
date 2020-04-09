function xyz_seek_values(a,b,des)
% _________________________________________________________________________
% Esta funcion encuentra una serie de puntos x y y en un archivo con
% datos de batimetria.
%
% Inputs:
%        a = matriz de dimensiones m x 3 donde se encuentran los datos a
%        localizar
%        b = matriz de dimensiones r x k (donde k puede tomar los valores
%        de 1,2,3 y r<m) que se desean ubicar en la matriz a.
%        Si des = 1 Se exportan los datos de a que corresponden a los de b.
%           des = 2 Se borran los datos de a que corresponden a los de b.
% Ejemplo:
% En bati se encuentran todos los puntos de la batimetria de cancun 19352x3
% y en rsbati (4766x2) se encuentran los puntos de la batimetria que corresponden a 
% la zona del Royal S. Se desea obtener extraer de la batimetria general
% los puntos del Roya S y estos datos exportarlos a un nuevo archivo que se
% usara para unir los datos de batimetria y perfiles de playa.
%
% xyz_seekvalues(bati,rsbati,1);
%
%
% Gabriel Ruiz 2014
% LAPCOF
% _________________________________________________________________________
clc;

if nargin ~=3
   error('Hay un problema con los argumentos de entrada en la funcion. Intenta de nuevo!');
end
if des < 1 && des > 2
   error('valor de opt incorrecto. Intenta de nuevo!'); 
end

% Encontrando los elementos de la matriz b en la a
[lin,dummy] = ismember(a,b);

% Encontrando en la matriz a las lineas que corresponden a los elementos de b
[ind,dummy] = find(lin(:,1) ==1 & lin(:,2)==1);

if des == 1
    % Extrayendo los elementos y exportandolos a una variable nueva
    new_a = a(ind,:);
    exportando(new_a);
else
    % Eliminando en la matriz a, los valores de b
    a(ind,:) = [];
    exportando(a);
end
return

% ***************************
% * S U B F U N C I O N E S *
% ***************************
function exportando(va)
[a2,a1] = uiputfile('*.txt','Exportando los resultados a:');
fid = fopen(fullfile(a1,a2),'w');
for k = 1:length(va)
        fprintf(fid,'%9.3f\t %10.3f\t %8.3f\r\n',va(k,1),va(k,2),va(k,3));
end
fclose all;
return
