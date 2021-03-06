function xyz_p_GEprofile(nombre,geomatriz)
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

%% Color de la linea de transecto en numero hexadecimal
cohex = 'ff0000ff';

%% Anco de la linea del transecto
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