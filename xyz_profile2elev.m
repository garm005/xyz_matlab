function xyz_profile2elev(datos,pl,ex)
% _________________________________________________________________________
% OBSOLETO, YA QUE PRESENTA PERFILES ERRONEOS CUANDO EXISTEN DUNAS Y SI 
% CONSIDERAR UNA TRAYECTORIA DE TIERRA MAR!!!
% Funcion clasifica perfiles de playa considerando el dato de la elevacion
% como criterio de seleccion.
% Inputs:
% datos : registro con datos
% pl =  1 si se desean guardar las graficas
% ex = 1 si se desean guardar los perfiles en archivos txt
% 
% Ejemplos
% load('a.mat');
% xyz_profile2elev(a,0,0)
% xyz_profile2elev(a,1,0)
% xyz_profile2elev(a,1,1)
%
% Gabriel Ruiz
% _________________________________________________________________________
% Iniciando contadores y variables
i = 1;
k = 1;
j = 1;
perfiles = cell(1,1);
c(1,1) = 1;

% Clasificando los perfiles, tomando en cuenta como criterio de
% clasificacion la elevacion
% C1 Trayectoria sesgada de Tierra a Mar
% C2 Trayectoria Escalonada de mar a tierra
% C3 Trayectoria Escalonada de tierra a mar
while i ~= length(datos) 
     %fprintf('%3.2f\n',datos(i,3));
      if  sign(datos(i,3)) == -1 && sign( datos(i+1,3)) == 1 &&  (datos(i,3) <datos(i+1,3)) && (datos(i-1,3) > datos(i,3)) % C1
             [i,k,j,c,perfiles] = limprofiles(i,k,j,c,datos,perfiles,1,pl,ex);
      elseif sign(datos(i,3)) == -1 && sign(datos(i+1,3)) == -1 && (datos(i,3) <datos(i+1,3)) && (datos(i-1,3) > datos(i,3)) % C2
             [i,k,j,c,perfiles] = limprofiles(i,k,j,c,datos,perfiles,1,pl,ex);
      elseif i~=1 && sign(datos(i,3)) == 1 && sign(datos(i+1,3)) == 1 && sign(datos(i-1,3)) == 1  && (datos(i,3) >datos(i+1,3)) && (datos(i-1,3) < datos(i,3)) % C3
             [i,k,j,c,perfiles] = limprofiles(i,k,j,c,datos,perfiles,2,pl,ex);
      else 
             i = i + 1;
      end 
end

% Ultimo perfil
c(k,2) = i;
bdum = datos(c(k,1):c(k,2),:);
% Ordenando los perfiles para que su orden sea descendente
if datos(c(k,1),3) < datos(c(k,2),3)
    bdum = flipud(bdum);
end
perfiles{j,1} = bdum;
oo = 0;
if pl == 1
   oo = 1;
end
ploting(bdum,oo,k); 
if ex == 1
   export2txt(bdum,k);
end

save('perfiles.mat','perfiles','-mat');
clear perfiles;
return

% ***************************
% * S U B F U N C I O N E S *
% ***************************
function [ii,kk,jj,output,perfiles] =  limprofiles(ii,kk,jj,output,data,perfiles,cs,pl,ex)
% _________________________________________________________________________
% Gabriel Ruiz
% ii - contador que me controla el desplazamiento entre lineas de los datos
% kk - contador que me controla el desplazamiento entre lineas en la
% variable donde se guarda el inicio y fin del perfil, puede ser
% interpretada como numero de perfil
% jj - contador que me controla el desplazamiento entre las lineas de la
% celda
% output - variable con el registro de datos
% perfiles - celda donde se guardar de manera ordenada los perfiles
% cs - es un flag relacionado a agrupar de manera ascendente los valores
% pl - es un flag relacionado a la exportacion de las graficas (ver
% ploting)
% ex - es un flag relacionado a la exportacion de los datos a archivo txt (
% ver export2txt)
%__________________________________________________________________________
output(kk,2) = ii;
bp = data(output(kk,1):output(kk,2),:);
if cs == 2 % Ordenando los perfiles para que su orden sea descendente    
   bp = flipud(bp);
end
perfiles{jj,1} = bp;
ooo = 0;
if pl == 1
   ooo = 1; 
end
ploting(bp,ooo,kk);
if ex == 1
   export2txt(bp,kk);
end

% Incrementando los contadores
kk = kk + 1;
ii = ii + 1;
jj = jj + 1;
output(kk,1) = ii;
return

function ploting(d,sa,l)
% _________________________________________________________________________
% Funcion que me grafica el perfil
% Gabriel Ruiz
% d - variable con datos a graficar
% sa - flag relacionada a la exportacion de la figura
% l - variable con el numero de perfil
%__________________________________________________________________________
figure
%Calculando la distancia transversal
x = d(:,2)-min(d(:,2));
plot(x,d(:,3),'Color',[rand(1) rand(1) rand(1)]);
xlabel('Offshore distance, [m]');
ylabel('Elevation, [m]');
if sa == 1
   print(horzcat('profile',num2str(l),'.png'),'-r300','-dpng');
end
close(gcf);
return

function export2txt(e,k)
% _________________________________________________________________________
% Funcion que exporta los datos del perfila a un archivo txt
% Gabriel Ruiz
%__________________________________________________________________________
fid = fopen(horzcat('profile',num2str(k),'.txt'),'w');
for u = 1:length(e)
   fprintf(fid,'%9.3f\t %10.3f\t %6.3f\r\n',e(u,1),e(u,2),e(u,3)); 
end
fclose all;
return
