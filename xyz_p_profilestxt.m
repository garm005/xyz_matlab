function xyz_p_profilestxt
% ________________________________________________________________________
% Esta funcion encuentra los perfiles de playa del archivo con datos del
% GPS Leica. Los datos se obtiene del LEICA GeoOffice. El script tiene
% la capacidad de encontrar los perfiles de playa mediante la diferencia 
% de tiempo que existe entre los registros. Cada perfil que se encuentra
% se almacena y se grafica. Se obtienen archivos con la información de 
% cada perfil, su figura y el volumen de arena calculado.
%
% Para usar esta funcion, el registro de datos debe de ser del tipo *.txt y
% tener las siguientes columnas (10):
% Columnas:
%          1-6 -> Fecha y tiempo, 
%          7 -> Coordenadas X,
%          8 -> Coordenadas Y, 
%          9 -> Elevación ortometrica,
%          10 -> Elevacion elipsoidal.
%
%
% Script escrito por Gabriel Ruiz
% CINVESTAV-LAPCOF, 2015
% gruizm@mda.cinvestav.mx
% ________________________________________________________________________

%%% Intervalo del muestreo
% 1 s, en modo auto del GPS Leica
intt = 1;

%%% Estableciendo el ancho del perfil
% para calculo de volumenes (un metro unitario)
anc = 1;

%%% Eligiendo el archivo con los datos
[nom1,pat1] = uigetfile('*.txt','Please, select the data file');
if ischar(nom1) == 0 || ischar(pat1) == 0
        error('Not file found!!!');
elseif strcmp(nom1(end-3:end),'txt')
        error('Not file found!!!');
else
    %%% Importando los datos
    datagps = importdata(horzcat(pat1,nom1),' ');
    
    %%% Conociendo el numero de registros
    tam = length(datagps);
    
    %%% Inicializando contadores
    kon = 1;
    con = 1;
    co = 1;
    
    %%% Convirtiendo las fechas a numero serial
    datagps(:,11) = datenum(datagps(:,1),datagps(:,2),datagps(:,3),datagps(:,4),datagps(:,5),datagps(:,6));
    
    %%% Clasificando los perfiles
    while kon ~= tam + 1
        if kon ~= tam                             % Si la linea no es el fin del registro...
            actline = datagps(kon,6);
            nexline = datagps(kon+intt,6);
            
            % Transformando las coordenadas de UTM a geograficas
            [datagps(kon,12),datagps(kon,13)] = UTMIP(datagps(kon,7),datagps(kon,8),16,'N');
            
            if kon == 1                           % Iniciando el registro
                        temp(con,:) = datagps(kon,:);
                        con = con + 1;
            elseif actline+intt == nexline        % Comparando el tiempo entre lineas
                        temp(con,:) = datagps(kon,:); 
                        con = con + 1;
            elseif actline == 59 && nexline == 00 % Caso especial
                        temp(con,:) = datagps(kon,:);
                        con = con + 1;
            else
                        temp(con,:) = datagps(kon,:); % Si la comparacion no es la correcta,
                        per{co,1} = temp;             % esto significa un nuevo perfil.
                        clear temp;
                        con = 1;
                        co = co + 1;
            end
         
            kon = kon + 1;
         
        else                                      % Fin del registro
            temp(con,:) = datagps(kon,:);
            per{co,1} = temp;
            clear temp;
            break;
        end
    end

    %%% Limpiando el workspace
    clear actline co con intt kon nexline tam  
    
    %%% Salvando los datos en un archivo mat
    save('datosgpsmatlab.mat','datagps','-mat');
    
    % Generando la matriz que contiene todos los perfiles y se usara para el GE
    perfi = cell2mat(per);
    kmlwriteline('perfiles',perfi(:,12),perfi(:,13));
%     geomatrix = [perfi(:,9) perfi(:,12) perfi(:,13)];
%     GE_profile('perfiles',geomatrix);f = 
    
    %%% Salvando cada perfil en un archivo txt y un kml
    ele1 = input('Preparo salida para Grapher? 0 = No, 1 = Si: ');
    if ele1 == 1
        txtgprapher(per)
        mkdir('grapher');
        movefile('*.txt',horzcat(pat1,'/grapher'));
    end
    salvandotxt(per);
    
    % Creando el folder donde se guardaran los archivos de cada perfil
    mkdir('profiles');
    
    % Moviendo los archivos de los perfiles a su carpeta
    movefile('*.txt',horzcat(pat1,'/profiles'));
    
    % Creando el folder donde se guardaran los archivos de cada perfil
    mkdir('tracks');
    
    % Moviendo los archivos de los perfiles a su carpeta
    movefile('*.kml',horzcat(pat1,'/tracks'));
    
    %%% Calculando el volumen de arena
    volu = volumenes(per,anc);
    
    % Creando el folder donde se guardaran los archivos de cada volumen
    mkdir('volumenes');
    
    % Moviendo los archivos de los volumenes a su carpeta
    movefile('*.txt',horzcat(pat1,'/volumenes'));
    
    %%% Dibujando el perfil de playa
    graficando(per,volu);
    
    % Creando el folder donde se colocaran todas las figuras
    mkdir('figuras');
    
    % Moviendo las figuras a la carpeta
    movefile('*.png',horzcat(pat1,'/figuras'));
    
    % Agrupando las carpetas en un solo folder
    mkdir('InfoProces');
    movefile(horzcat(pat1,'datosgpsmatlab.mat'),horzcat(pat1,'/InfoProces'));
    movefile(horzcat(pat1,'/profiles'),horzcat(pat1,'/InfoProces'));
    if ele1 == 1
       movefile(horzcat(pat1,'/grapher'),horzcat(pat1,'/InfoProces')); 
    end
    movefile(horzcat(pat1,'/tracks'),horzcat(pat1,'/InfoProces'));
    movefile(horzcat(pat1,'/volumenes'),horzcat(pat1,'/InfoProces'));
    movefile(horzcat(pat1,'/figuras'),horzcat(pat1,'/InfoProces'));
    
    %%% Comprimiendo el folder
    qw = input('Deseas comprimir el archivo con la informacion, 1 = Si, 0 = No: ');
    if qw == 1
        zip(horzcat(pat1,'Infoproces.zip'),'InfoProces');
        rmdir('InfoProces','s');
    end
    fprintf('Ha terminado el script exitosamente!\n');
end

%  _______________               _________________________________
% /______________/ Subfunciones /________________________________/
function [latitude,longitude] = UTMIP(x,y,zone,hemis)
% _______________________________________________________________
% 1. With this little routine, you can get the transformation
% or the conversion of UTM coordinates to spherical 
% coordinates, You can choose different ellipsoids to execute
% the conversion.
% Gabriel Ruiz
% ______________________________________________________________
sa = 6378137.000000;
sb = 6356752.314245;            
e2 = (((sa^2)-(sb^2))^0.5)/sb;
e2cuadrada = e2^2;
c = (sa^2)/sb;
X = x-500000;  
if hemis == 'S' || hemis == 's'
    Y = y-10000000;
else
    Y = y;
end                                      
S = ((zone*6)-183); 
lat =  Y/(6366197.724*0.9996);                                    
v = (c/((1+(e2cuadrada*(cos(lat))^2)))^0.5)*0.9996;
a = X/v;
a1 = sin(2*lat);
a2 = a1*(cos(lat))^2;
j2 = lat+(a1/2);
j4 = ((3*j2)+a2)/4;
j6 = ((5*j4)+(a2*(cos(lat) )^2))/3;
alfa = (3/4)*e2cuadrada;
beta = (5/3)*alfa^2;
gama = (35/27)*alfa^3;
Bm = 0.9996*c*(lat-alfa*j2+beta*j4-gama*j6);
b = (Y-Bm)/v;
Epsi = ((e2cuadrada*a^2)/2)*(cos(lat))^2;
Eps = a*(1-(Epsi/3));
nab = (b*(1-Epsi))+lat;
senoheps = (exp(Eps)-exp(-Eps))/2;
Delt = atan(senoheps/(cos(nab)));
TaO = atan(cos(Delt)* tan(nab));
longitude = (Delt*(180/pi))+S;
latitude = (lat+(1+e2cuadrada*(cos(lat)^2)-(3/2)*e2cuadrada*sin(lat)* cos(lat)*(TaO-lat))*(TaO-lat))*(180/pi);
return

function GE_profile(nombre,geomatriz)
%_______________________________________________________________
% Esta funcion genera un archivo kml para cada perfil de playa
% En GE el perfil se visualizara como un track.
% Inputs:
%        nombre: nombre que tendra el archivo kml
%        geomatriz: matriz con los valores de la triada de valores del
%                   del perfil
% Gabriel Ruiz
% ______________________________________________________________
% Convert to RGB to hex color
% Generando un arreglo de colores aleatorio y obteniendo su valor en RGB
% rgb = [str2num(sprintf('%0.1f',rand(1))), str2num(sprintf('%0.1f',rand(1))), str2num(sprintf('%0.1f',rand(1)))].*255;
% hex1 = dec2hex(floor(rgb/16));
% hex2 = dec2hex(mod(rgb,16)*16);
% cohex = lower(['ff',hex1(1),hex2(1),hex1(2),hex2(2),hex1(3),hex2(3)]);
cohex = 'ff0000ff';
ancholine = '3';
qq = '#f';
qqq = '#f0';
ww = 'normal';
www = '#f1';
% Estableciendo el encabezado del archivo kml
tex1 = ['<?xml version="1.0" encoding="UTF-8"?>',...
        '<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">',...
        '<Document>',...
	        '<name>' nombre '</name>',...
            '<Style id="f">',...
                '<LineSytle>',...
                     '<color>' cohex '</color>',...
                     '<width>' ancholine '</width>',...
                '</LineSytle>',...
            '</Style>',...
            '<Style id="f0">',...
                '<LineSytle>',...
                     '<color>' cohex '</color>',...
                     '<width>' ancholine '</width>',...
                '</LineSytle>',...
            '</Style>',...
            '<StyleMap id="f1">',...
		        '<Pair>',...
			        '<key>' ww '</key>',...
			        '<styleUrl>' qq '</styleUrl>',...
		        '</Pair>',...
		        '<Pair>',...
			         '<key>highlight</key>',...
			         '<styleUrl>' qqq '</styleUrl>',...
		        '</Pair>',...
	        '</StyleMap>',...
	        '<Placemark>'...
		        '<name>' nombre '</name>',...
		        '<styleUrl>' www '</styleUrl>',...
		        '<LineString>',...
		            '<tessellate>1</tessellate>',...
		            '<coordinates>'];  
cie=[               '</coordinates>',...
                '</LineString>',...
            '</Placemark>',...
        '</Document>',...
        '</kml>'];
    
fida = fopen(horzcat(nombre,'.kml'),'w+');
geo = flipud(rot90(fliplr(geomatriz)));
fprintf(fida,'%s \n',tex1);
fprintf(fida,'%.6f,%.6f,%.6f\n',geo);
fprintf(fida,'%s',cie);
fclose(fida);

return

function salvandotxt(per)
%_______________________________________________
% Funcion que me exporta la informacion de cada 
% perfil a distintos archivos para usarse en 
% Google Earth o Grapher.
% Inputs:
%        per = arreglo celda con los datos de los perfiles
%        ele1 = valor del switch para exportar datos a un archivo
%               que se use en Grapher.
% Gabriel Ruiz
% ______________________________________________
for o = 1:length(per)
   nombre = horzcat('perfil',sprintf('%05i',o));
   fid = fopen(horzcat(nombre,'.txt'),'w');
   j = 1;
   fprintf('Generando archivo %05i\n',o);
   [impo,dummy] = size(per{o});
   while j ~= impo + 1
      fprintf(fid,'%05i %2.0f %2.0f %2.0f %2.0f %2.0f %2.0f %10.3f %11.3f %8.3f %8.3f %11.6f %11.6f\r\n',...
                    per{o}(j,1), per{o}(j,2), per{o}(j,3), per{o}(j,4), per{o}(j,5), per{o}(j,6),...
                    per{o}(j,7), per{o}(j,8), per{o}(j,9), per{o}(j,10), per{o}(j,11), per{o}(j,13), per{o}(j,14));
      j = j + 1;
   end   
   % Generando el archivo kml track para Google Earth
   geomatriz = [per{o}(:,10) per{o}(:,13) per{o}(:,14)];
   GE_profile(nombre,geomatriz);
   fclose all;
end
return

function txtgprapher(per)
% ____________________________________________________
%
%
%
% ____________________________________________________
 % Generando el archivo txt para Grapher
for o = 1:length(per)  
    nombre2 = horzcat('Gra_perfil',sprintf('%05i',o));
    fidgr = fopen(horzcat(nombre2,'.txt'),'w');
    fprintf('Generando archivo %05i para grapher\n',o);
    jj = 1;
    [impo,dummy] = size(per{o});
    while jj ~= impo + 1
         fprintf(fidgr,'%05i %8.3f %8.3f\r\n',jj,per{o}(jj,8)-min(per{o}(:,8)),per{o}(jj,10)); 
         jj = jj + 1; 
    end
end 
fclose all;
return

function volu = volumenes(per,anc)
% __________________________________________
% Funcion que calcula el volumen de un perfil.
% Inputs:
%        per = arreglo celda con los datos de los perfiles
% Output:
%        volu = vector con todos los volumenes de los perfiles
% Gabriel Ruiz
% __________________________________________
cont = 1;
for g = 1:length(per)
        % Obteniendo el numero de puntos del perfil analizado
        [l,dummy] = size(per{g});
        % Revisando que el perfil de playa tenga mas de un punto para obtener el volumen
        if l ~= 1
            % Identificando los puntos del perfil sumergido
            [ind,dummy] = find(per{g}(:,10)<0);
            % Si hay puntos en el perfil sumergido, que se calcule el area
            if isempty(ind) ~= 1
                % Area de arena en perfil sumergido
                su = trapz(per{g}(ind(1):ind(end),8),per{g}(ind(1):ind(end),10)); 
            else
                su = 0;
            end
        
            % Identificando los puntos del perfil emergido
            [in,dummy] = find(per{g}(:,10)>0);
            if isempty(in) ~= 1
                % Area de arena en perfil emergido
                ae = trapz(per{g}(in(1):in(end),8),per{g}(in(1):in(end),10));
            else
                ae = 0;
            end
        
            % Obteniendo el volumen total
            vol = (abs(ae) + abs(su))*anc;
            
            % Matriz donde se almacenan los volumenes totales de cada perfil
            volu(cont,1) = vol;
            cont = cont + 1;
      
            % Exportando el volumen total del perfil a un archivo
            fid2 = fopen(horzcat('vol',sprintf('%05i',g),'.txt'),'w');
            fprintf('Calculando el volumen del perfil %05i\n',g);
            fprintf('Volumen obtenido = %8.3f (m3-m)\n',vol);
            fprintf(fid2,'%8.3f\r\n',vol);
            fclose all;
        else
            fid = fopen(horzcat('ERRORvol',sprintf('%05i',g),'.txt'),'w');
            fprintf(fid,'%49s\r\n','Es necesario revisar los datos del este perfil');
            fclose all;
        end
end
return

function graficando(per,volu)
% __________________________________________
% Funcion que calcula grafica el perfil.
% Inputs:
%        per = arreglo celda con los datos de los perfiles
%        volu = vector con todos los volumenes de los perfiles
% Gabriel Ruiz
% ___________________________________________
% Abriendo la ventana grafica
fi = figure('Color',[1 1 1],'MenuBar', 'none',...
                 'NumberTitle','off','Toolbar','none');
             
% Maximizando la pantalla
jframe = get(handle(gcf),'JavaFrame');
pause(0.01);
jframe.setMaximized(true);

% Graficando el analisis de los volumenes
rt = bar(volu(:,1),'BarWidth',0.4,...
                'EdgeColor',[0 0 0],'FaceColor',[0.55 0.17 0.078]);
set(gca,'Box','off',...
                'FontName','Palatino Linotype',...
                'FontSize',10,...
               'FontWeight','Bold');
xlabel('Profile','FontName','Palatino Linotype',...
               'FontSize',14,...
               'FontWeight','Bold');
ylabel('Sand volume [m^3]','FontName','Palatino Linotype',...
               'FontSize',14,...
               'FontWeight','Bold');
title('Sand volume analysis','FontName','Palatino Linotype',...
               'FontSize',18,...
               'FontWeight','Bold');
saveas(rt,horzcat('VolumetricAna','.png'));
delete(rt);
    
for k = 1: length(per)
        set(gcf,'Name',horzcat('Beach Profile Analysis:',sprintf('%05i',k)));
        % Obteniendo la distancia crosshore relativa del perfil
        x = per{k}(:,8)-min(per{k}(:,8));
        % Graficando el perfil
        gr = plot(x,smooth(per{k}(:,10)),...
            'Color',[rand(1), rand(1), rand(1)],...
            'LineWidth',2,...
            'Marker','.',...
            'MarkerSize',20);
        % Ajustando el eje de las abscisas y agregando la linea cero
        [ss,dummy] = size(per{k}(:,8));
        if ss > 1
            xlim([min(x) max(x)]);
            hold on
            linea = line([min(x) max(x)],[0 0]);
            % Distorsionando los ejes para mejor visualizacion del perfil
            set(gca,'PlotBoxAspectRatio',[30 5 1]);
            text(0.3,0.1,'MSL','FontName','Palatino Linotype','FontSize',10,...
                 'FontWeight','Bold','Color',[0 0 1]);
        end
        % Rotulando los ejes de la grafica
        xlabel('Distance offshore [m]','FontName','Palatino Linotype',...
               'FontSize',14,...
               'FontWeight','Bold');
        ylabel('Height [m]','FontName','Palatino Linotype',...
               'FontSize',14,...
               'FontWeight','Bold');
        set(gca,'Box','off',...
                'FontName','Palatino Linotype',...
                'FontSize',10,...
               'FontWeight','Bold');
        title(horzcat('Beach profile ',sprintf('%05i',k)),...
               'FontName','Palatino Linotype',...
               'FontSize',18,...
               'FontWeight','Bold');
        % Salvando la grafica
        saveas(gr,horzcat('figperfil',sprintf('%05i',k),'.png'));
        % Borrando la grafica
        delete(gr);
        if ss > 1
           delete(linea);
        end
end

% Cerrando la ventana grafica
close(gcf);
return