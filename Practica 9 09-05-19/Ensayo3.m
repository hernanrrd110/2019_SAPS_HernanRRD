%% ............................ ENSAYO 3 ..................................
% Autores: Dragan Valeria, Hamnstrom Luis, Rodriguez Ruiz Diaz Hernan
% SAPS: 1er Cuatrimestre 2019
% 09-05-19
%--------------------------------------------------------------------------
% path( path, 'D:\Repositorio GitHub');
% cd 'D:\Repositorio GitHub'

%%
clear all; close all; clc;
 % Hacemo chevy;
cd 'D:\Repositorio GitHub\2019_SAPS_HernanRRD\Practica 9 09-05-19';
 
% El numero de bits de resolucion que tiene el conversor AD
numero_bits  = 10;

% Rango dinámico del conversor para la atenuación en la banda de rechazo
RD = 6.02*numero_bits + 1.76 ; % en DB

% Esto es la oscilacion que tiene el Chebyshev en la banda de paso
Rp = 3; % en Decibeles

% te da ceros, polos y ganancia;
n = 4;
% z ceros, p polos y k ganancia
[z,p,k] = cheb1ap(n,Rp);


%% .................... PARAMETROS DEL FILTRO CHEVYSHEV ...................

w1 = 2*pi*1000; % Frecuencia de corte inferior [rad/s]
w2 = 2*pi*3000; % Frecuencia de corte superior [rad/s]
B = w2-w1; % Ancho de banda de paso [rad/s]

w0 = sqrt(w1*w2); % Frecuencia central de desnormalizacion de Pasabanda

%%% Funcion de transferencia en s normalizada de Chevyshev

[Num,Den] = zp2tf(z,p,k);


% tomamos a s como funcion de transferencia
s = tf('s');

% Desnormalizacion de la funcion de transferencia a Pasabanda
s = (s^2+w0^2)/(B*s);

D_desn=0;
N_desn=0;

% Armado de la funcion de transferencia desnormalizada con los polos y
% ceros

for i=1:length(Den)
 D_desn=D_desn+Den(i)*(s^(n+1-i));
end

for i=1:length(Num)
 N_desn=N_desn+Num(i)*(s^(n+1-i));
end


Hs_desn = minreal(N_desn/D_desn)

figure('Color',[1 1 1],'Name','Bode H(s) desnormalizada','NumberTitle','off');
bode(Num,Den);

% Graficacion de los polos
figure('Color',[1 1 1],'Name','Polos de H(s)','NumberTitle','off');
[P_desn,Z_desn]= pzmap(Hs_desn);
pzmap(Hs_desn)

% Se seleccionaros los polos 3y4, y 5y6
P1=poly(P_desn(3:4))
P2=poly(P_desn(5:6))
P_total = poly(P_desn(3:6));

L_Pass1=tf(P1(3),P1)
L_Pass2=tf(P2(3),P2)
L_Passtotal=tf(P_total(5),P_total);


figure;
bode(L_Pass1)
hold on;

bode(Hs_desn.Numerator{1},Hs_desn.Denominator{1});
hold on;

bode(L_Pass2)
hold on;

bode(L_Passtotal)
