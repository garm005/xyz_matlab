function rotaxyz(x,y,z,beta,x_ori,y_ori,nexport,flagexpo)
% _________________________________________________________________________
% Esta funcion realiza una rotacion 2D de una serie de puntos con respecto
% a un punto pivote.
% 
% Inputs:
% x = vector con valores de X 
% y = vector con valores de Y
% z = vector con valores de elevacion o profundidad
% beta = angulo de rotacion (grados); signo positivo es sentido antihorario,
%        signo negativo es sentido horario
% x_ori = coordenada x del punto de rotacion o pto. pivote
% y_ori = coordenada y del punto de rotacion o pto. pivote
% nexport = nombre del archivo de exportacion
% flagexpo = si flagexpo = 1 los resultados se importan a un archivo mat
%               flagexpo = 2 los resultados se importan a un archivo xyz
%               flagexpo = 3 los resultados se importan a archivos mat y
%               xyz.
% Outputs:
%
% Ejemplos:
% rotaxyz(bati(:,1),bati(:,2),bati(:,3),60,535678,2345678,'batirot',1);
% rotaxyz(bati(:,1),bati(:,2),bati(:,3),60,min(bati(:,1)),min(bati(:,2),'batirot',3);
%
% Notas:
% Matriz de rotacion considerada en el programa:
%             __                    __
%            | cos(theta) -sin(theta) |
% R =        | sin(theta) cos(theta)  |
%            |__                    __|

%% repmat hara "una" copia de las coordenadas del pto pivote y la colocara
% en "n" columnas segun el numero de coordenadas que se van a transformar,
% con ello cada par de coordenadas podra ser sumado o restado con una copia
% de las coordendas pivote.
%
% Este programa ha sido implementado a partir del script de mathworks
% que se encuentra en: 
% http://www.mathworks.com/matlabcentral/answers/93554-how-i-can-rotate
%          -a-set-of-points-in-a-certain-angle-about-an-arbitrary-point
%
% Gabriel Ruiz 2014
% _________________________________________________________________________

if nargin ~=6
   error('faltan argumentos de entrada en la funcion. Intenta de nuevo!');
end

if flagexpo <= 1 && flagexpo >= 4
   error('valor de flagexpo incorrecto. Intenta de nuevo!'); 
end

%% Angulo de rotacion
%beta = -90;

%% Creando la matriz con las coordenadas a rotar
%x = 1:10;
%y = 1:10; 

%% Proporcionando el punto de rotacion
%x_ori = x(1);
%y_ori = y(1);
x = x';
y = y';
v = [x;y];

%% Convirtiendo el angulo de rotacion a radianes
theta = beta*(pi/180);

%% Creando el mosaico del arreglo que es necesario para referenciar las
% coordenadas al sistema coordenado local con origen en el pto. pivote.
center = repmat([x_ori;y_ori],1,length(x));

%% Estableciendo la matriz de rotacion
R = [ cos(theta) -sin(theta); sin(theta) cos(theta) ];

%% Moviendo las coordenadas al sistema coordenado local con origen
% en el punto de rotacion
s = v - center;

%% Rotando el sistema de referencia local con respecto al pto pivote 
so = R * s;

%% Regresando las coordenadas que han sido rotadas
% a su sistema de referencia de original
vo = so + center;
xrot = vo(1,:);
yrot = vo(2,:);

%% Graficando las coordenadas sin rotar
%plot(x,y,xrot,yrot,'r',x_ori,y_ori,'g');
%axis equal

switch flagexpo
    case 1
          export2mat(nexport,xrot,yrot,z);
    case 2
          export2xyz(nexport,xrot,yrot,z)
    case 3
          export2mat(nexport,xrot,yrot,z);
          export2xyz(nexport,xrot,yrot,z)
end
return

% ***************************
% * S U B F U N C I O N E S *
% ***************************
function export2mat(archivo,a,b,c)
% _________________________________________________
% Subfuncion que exporta las coordenadas a un archivo .mat
% Inputs:
% archi = nombre del archivo donde se exportaran los datos
% a,b,c = variables que contienen los valores de xrot,yrot,z. respectivamente
% Gabriel Ruiz
% _________________________________________________
save(horzcat(archivo,'.mat'),'a','b','c','-mat');
return

function export2xyz(archivo,a,b,c)
% _________________________________________________
% Subfuncion que exporta las coordenadas a un archivo .xyz
% Inputs:
% archi = nombre del archivo donde se exportaran los datos
% a,b,c = variables que contienen los valores de xrot,yrot,z. respectivamente
% Gabriel Ruiz
% _________________________________________________
fid = fopen(horzcat(archivo,'.xyz'),'w');
fprintf('Se estan exportando las coordenadas a archivo\n');
for i = 1:length(a)
   fprint(fid,'%11.3f\t %11.3f\t %8.3\r\n',a(i,1),b(i,2),c(i,1)); 
end
fprint('Han sido exportados los datos\n');
fclose all;
return