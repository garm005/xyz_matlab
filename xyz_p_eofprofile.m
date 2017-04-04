function xyz_p_eofprofile(h)
% __________________________________________________________
% Funcion que calcula los funciones empiricas ortogonales 
% Esta funcion es muy simple y esta basada segun el 
% libro de Dean y Darlymple pag. 139-144
%
% Gabriel Ruiz
% LAPCOF
% ________________________________________________________
%   h=[1 2 3;
%       1 2 2;
%       0 1 2;
%       1 3 4];
%aim = [ 25 9 12; 9 30 15; 12 15 48];

% Creando funciones anonimas para conocer las dimensiones de la matriz con
% datos
r = @(x) size(x,1);
c = @(x) size(x,2);

% Matriz de covarianza o correlacion  (eq. 6.9)
aim = h'*(h/(r(h)*c(h)));

% Calculando los eigenvalores (eq. 6.11)
[e,lambda]=eig(aim);

%  Ordenando los valores de los eigenvalores
[lambda, ind] = sort(diag(lambda));
ind = flipud(ind);
lambda = lambda(ind);
e = e(:,ind);

%  Calculando los coeficientes Cnk (eq. 6.5)
cnk = h*e;

% Calculando el porcentaje explicado de la varianza
pctevar = lambda/sum(lambda);

fprintf('Tabla de Eigenvalores\n');
fprintf('Lamda        Pcte.varia          Eigenvectores\n');
for ii = 1 : c(e) 
   fprintf('%11.7f\t %9.5f\t',lambda(ii,1),pctevar(ii,1));
   for j = 1 : r(e)
       if j == r(e) 
           fprintf('%8.5f\n',e(j,ii));
       else
           fprintf('%8.5f\t',e(j,ii));
       end
   end
end

fprintf('\nTabla de Cnk\n');
fprintf('K        n\n');
for iii = 1 : r(h)
   fprintf('%1.0i\t',iii); 
   for jj = 1 : c(h)
       if jj == c(h) 
           fprintf('%11.6f\n',cnk(iii,jj));
       else
           fprintf('%11.6f\t',cnk(iii,jj));
       end
   end
end
figure
subplot(3,1,1)
plot(h');
subplot(3,1,2)
plot(e);
legend;
subplot(3,1,3)
plot(cnk);
ylabel('c_{n_k}')