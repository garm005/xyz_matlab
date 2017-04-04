function [ang,angrad] = xyz_slope_ptos(xi,xf,yi,yf)
% Funcion que me calcula la pendiente que 
% existe entre dos puntos
% Inputs:
% Coordenadas de los puntos
% Outputs:
% Angulo, angulo en radianes
%
% Gabriel Ruiz
% ______________________________

ang = atan((yf-yi)/(xf-xi));
angrad = ang *(pi/180);