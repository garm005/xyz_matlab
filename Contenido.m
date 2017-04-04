% Contenido
% Los diferentes programas o scripts de la libreria xyz_scripts_matlab
% han sido codificados para facilitar el postproceso de datos relacionados 
% a batimetrias y perfiles de playa. Los scripts han sido agrupados en dos
% categorias, según el tipo de datos que se desean procesar; cuando se
% requiera analizar informacion relacionada a batimetrias, en el nombre de la
% funcion, aparece la letra b que antecede la etiqueta "xyz_"; mientras que la
% letra p se encuentra en todos aquellas funciones relacionadas al procesamiento
% de perfiles de playa.
%
% La libreria cuenta con las siguientes funciones:
% xyz_b_clean_file_blanks -> funcion que elimina todas las lineas de un 
%       registro de datos que presenta la recurrencia de cierto valor 
%       para una determinanda columna.
%
% xyz_b_grd2matlab -> funcion que carga en matlab los datos que se encuentran
%       en un archivo grd, que ha sido generado con surfer (GRD 6 Surfer Text Grid). 
%       Grafica el mapa de contorno.
%
% xyz_b_gridding_matlab_trian -> funcion que genera una malla numerica 
%       espacialmente uniforme, a partir de la interpolacion lineal de datos.
%
% xyz_b_gridding_surfer_any -> funcion que crea un grid a partir de datos xyz
%       espacialmente irregulares, usando surfer.
%
% xyz_b_merge_points -> funcion que une el contenido de dos archivos 
%       con datos de x,y,z.
%
% xyz_b_minmax_profiles -> esta funcion encuentra los valores maximos y 
%       minimos de x,y,z en los archivos de los perfiles de playa.
%
% xyz_b_preview_ptos -> funcion que me permite visualizar todos los puntos
%       de varios archivos txt con datos xyz.
%
% xyz_b_rotar_ptos -> funcion que realiza una rotacion 2D de una serie de
%       puntos con respecto a un punto pivote.
%
% xyz_b_seek_values -> funcion que encuentra una serie de puntos x y y en un archivo con
%       datos de batimetria.
%
% xyz_b_slope_ptos -> funcion que calcula la pendiente que existe entre dos puntos.
% 
% xyz_p_eofprofiles ->
%
% xyz_p_GEprofile ->
%
% xyz_p_minmax_profiles ->
%
% xyz_p_profilesLeica ->
%
% xyz_p_rmsimplefit ->
%
% xyz_p_slope_ptos ->
%
% xyz_p_splitprofiles ->
%
% xyz_p_UTMIP ->
%
% xyz_p_voluprofdry ->

% Gabriel Ruiz 2014
% LAPCOF
% _________________________________________________________________________