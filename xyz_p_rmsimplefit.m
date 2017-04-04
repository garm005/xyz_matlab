function [rsq,dafit] = rmsimplefit(x,y)
% _____________________________________________________________
% Funcion que calcula la R2 de un ajuste. Esta medida estadistica mide que
% la confiabilidad de un ajuste para explicar la variación de los datos; es
% decir que R2 es el cuadrado de la correlacion entre los valores medidos y
% los calculados.R2 puede tomar cualquier valor entre 0 y 1; un 
% valor cercano a 1 indica que una gran proporcion de la varianza es considerada
% por el modelo.
%
% Inputs:
%        x = vector con los valores de x a ajustar
%        y = vector con los valores de y a ajustar
% Outputs:
%        rsq = valor de la r2 obtenida
%        dafit = valores de y ajustados
%
% Ejemplo:
% Se desea saber si la linea 0 representa el total del cambio volumetrico,
% por tal razon se analizaron 7 perfiles de los cuales se obtuvo el volumen
% de perfil "res(:,2)" con respecto al ancho de la playa "res(:,1)".
% Entonces:
%        load('Perfil01ChenKan.mat');
%        x = res(:,2);
%        y = res(:,1);
%        rsq = rmsimplefit(x,y);
%
% Gabriel Ruiz 2014.
% ________________________________________________________________________

% Obteniendo los coeficientes del polinomio de ajuste, para este caso el
% grado de la polinomio es 1
fitting.coef = polyfit(x,y,1);

% Evaluando el polinomio con los valores del volumen de playa
fitting.ty = polyval(fitting.coef,x);
dafit = fitting.ty;

% Graficando los puntos del volumen y dibujando la recta del ajuste
plot(x,y,'.',x,fitting.ty,'r-');
xlabel('Total volume, (m^3)');
ylabel('Beach width (m)');
jframe = get(handle(gcf),'JavaFrame');
pause(0.01);
jframe.setMaximized(true);
print(gcf,'-dpng','-r300',horzcat('ajuste','.png'));

% Calculando el r2 del ajuste
% Obteniendo la valores de la recta de ajuste
fitting.recfitt = (fitting.coef(1)*x) + fitting.coef(2);

% Calculando el valor residual entre el volumen de campo y el del ajuste
fitting.residual = y - fitting.recfitt;

% Estableciendo la suma de los cuadrados de la regresion
fitting.ssr = sum(fitting.residual.^2);

% Calculando la suma de los cuadrados alrededor de la media
fitting.sstotal = (length(y)-1)*var(y);

%Obteniendo la r2
rsq = 1 - (fitting.ssr/fitting.sstotal);
return