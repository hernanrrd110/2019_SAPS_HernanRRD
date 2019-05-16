%% ............................ ENSAYO 3 ..................................
% Autores: Dragan Valeria, Hamnstrom Luis, Rodriguez Ruiz Diaz Hernan
% SAPS: 1er Cuatrimestre 2019
% 09-05-19
%--------------------------------------------------------------------------

%%
clear all; close all; clc;
 % Hacemo chevy;
cd 'C:\Repositorio GitHub\2019_SAPS_HernanRRD\Practica 9 09-05-19';
 
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

%%
% Graficacion de los polos
close all;
figure('Color',[1 1 1],'Name','Polos de H(s)','NumberTitle','off');
[P_desn,Z_desn]= pzmap(Hs_desn);
pzmap(Hs_desn)

P_desn;
% Se seleccionaros los polos 1y2, y 5y6

% Polinomio de orden 2 con polos 1 y 2 con ganancia 1
P1 = poly(P_desn(1:2));
P1 = P1/P1(3);
L_Pass1 = tf(1,P1);

% Polinomio de orden 2 con polos 5 y 6 con ganancia 1
P2 = poly(P_desn(5:6));
P2 = P2/P2(3);
L_Pass2=tf(1,P2);

L_Passtotal = L_Pass1*L_Pass2;

% P_total = 
% P_total = poly(P_desn(3:6))
% P_total = P_total/P_total(5);
% L_Passtotal=tf(1,P_total)

figure;
bode(L_Pass1,'r')
hold on;
bode(L_Pass2,'g')
hold on;
bode(L_Passtotal,'b')

%% ................. Diseño del Pasabajos

%%%% Seccion 1 
a2 = P1(1);
a1 = P1(2);
a0 = P1(3);

L_Pass1

%%%% Seccion 2
b2 = P2(1);
b1 = P2(2);
b0 = P2(3);

L_Pass2

% Celda 1
C_1 = 1*10^(-11);

m_1 = 2;

R_1 = a1/((m+1)*C_1); %Da 150K

R2_1= m*R_1; %Da 300K

n_1 = a2/(m_1*R_1*R_1*C_1*C_1);

C2_1 = C_1*n; %Nos da 6044p, tomamos 5600p

% Celda 2

C_2 = 1*10^(-9);

m_2 = 2;

R_2 = b1/((m_2+1)*C_2);  %Tomamos 9.1K

R2_2 = m * R; %Daria 18.2 K, tomamos 18K

n_2 = b2/(m*R_2*R_2*C_2*C_2);

C2_2 = C_2*n; %Tomamos 82n


%% Graficacion

[freq,dB,deg] = import_ac_LTSpice('LTSpice_Cell3.txt');

freq = freq*2*pi;

subplot(2,1,1);
semilogx(freq,dB);
hold on;
grid on;

subplot(2,1,2);
semilogx(freq,deg);
bode(L_Passtotal,'m')
grid on;

