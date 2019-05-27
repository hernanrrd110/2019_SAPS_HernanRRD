%% ............................ ENSAYO 3 ..................................
% Autores: Dragan Valeria, Hamnstrom Luis, Rodriguez Ruiz Diaz Hernan
% SAPS: 1er Cuatrimestre 2019
% 09-05-19
%--------------------------------------------------------------------------

%%
clear all; close all; clc;
 % Hacemo chevy;
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


%% ..................... Visualizacion de Polos ..........................
close all;
[P_desn,Z_desn]= pzmap(Hs_desn);
P_desn
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

%% ....................... Diseño del Pasabajos ...........................

% ---- Coeficientes del Polinomio del Denominador de Sallen-Key con
% ---- ganancia unitaria
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

% Se realizaron las siguientes simplieficaciones. Las secciones de
% Pasabajos tendran ganancia unitaria, y se llevara el resto de la ganancia
% al pasa altos digital. Tomamos a las resistencias como multiplos, como
% tambien los capacitores.

% Celda 1

C_1 = 1*10^(-11);

m_1 = 2;

R_1 = a1/((m_1+1)*C_1); %Da 150K

R2_1= m_1*R_1; %Da 300K

n_1 = a2/(m_1*R_1*R_1*C_1*C_1);

C2_1 = C_1*n_1; %Nos da 6044p, tomamos 5600p

% Celda 2

C_2 = 1*10^(-9);

m_2 = 2;

R_2 = b1/((m_2+1)*C_2);  % Tomamos 9.1K

R2_2 = m_2 * R_2; %Daria 18.2 K, tomamos 18K

n_2 = b2/(m_2*R_2*R_2*C_2*C_2);

C2_2 = C_2*n_2; %Tomamos 82n



%% ........................... Graficacion ................................

% ---------------------- Graficacion Bode PasaBanda ----------------------
close all;
figure('Color',[1 1 1],'Name','Bode H(jw) desnormalizada','NumberTitle','off');

N = 2000;
W = logspace(2,6,N);
Respuesta_Freq_PasaBanda = freqs(Hs_desn.Numerator{1},Hs_desn.Denominator{1},W);
Maginitud_Pasabanda = 20*log10(abs(Respuesta_Freq_PasaBanda));

semilogx(W,Maginitud_Pasabanda);grid on;
title('H(jw) desnormalizada Pasabanda')
xlabel('Frecuencia angular w [rad/s]');
ylabel('Magnitud H(jw) [dB]');

% ------------------------- Graficacion Polos ----------------------------

figure('Color',[1 1 1],'Name','Polos y Ceros de H(s)','NumberTitle','off');
pzmap(Hs_desn)
title('Polos y Ceros de H(s)')

% ------------ Graficacion Bode Secciones de forma analitica -------------
figure('Color',[1 1 1],'Name','H(jw) de Secciones','NumberTitle','off');

% Primer Seccion
Respuesta_L_Pass1 = freqs(L_Pass1.Numerator{1},L_Pass1.Denominator{1},W);
Maginitud_L_Pass1 = 20*log10(abs(Respuesta_L_Pass1));

semilogx(W,Maginitud_L_Pass1,'r');grid on; hold on;

% Segunda Seccion
Respuesta_L_Pass2 = freqs(L_Pass2.Numerator{1},L_Pass2.Denominator{1},W);
Maginitud_L_Pass2 = 20*log10(abs(Respuesta_L_Pass2));

semilogx(W,Maginitud_L_Pass2,'g');grid on; hold on;

% Tercera Seccion
Respuesta_L_Passtotal = freqs(L_Passtotal.Numerator{1},L_Passtotal.Denominator{1},W);
Maginitud_L_Passtotal = 20*log10(abs(Respuesta_L_Passtotal));

semilogx(W,Maginitud_L_Passtotal,'b');grid on; 
legend('PasaBajos 1','PasaBajos 2','PasaBajos Total');
title('H(jw) de Seccion 1, 2 y total')
xlabel('Frecuencia angular w [rad/s]');
ylabel('Magnitud H(jw) [dB]');

% ---------- Graficacion Bode LTSpice y  Pasabajos Analitico -------------

figure('Color',[1 1 1],'Name','H(jw) de Secciones','NumberTitle','off');

% LTSpice
[freq,dB] = import_ac_LTSpice('LTSpice_Cell3.txt');

freq = freq*2*pi;
semilogx(freq,dB,'r');
hold on;
grid on;

% Pasabajos Analitico
semilogx(W,Maginitud_L_Passtotal,'g');grid on;

legend('PasaBajos LTSpice','PasaBajos analitico');
title('Función H(jw) Analítica, Simulación')
xlabel('Frecuencia angular w [rad/s]');
ylabel('Magnitud H(jw) [dB]');

% ----- Graficacion Bode LTSpice, Pasabajos Analitico e Implementado -----

figure('Color',[1 1 1],'Name','H(jw) de Secciones','NumberTitle','off');

% LTSpice
[freq,dB] = import_ac_LTSpice('LTSpice_Cell3.txt');

freq = freq*2*pi;
semilogx(freq,dB,'r');
hold on;
grid on;

% Pasabajos Analitico
semilogx(W,Maginitud_L_Passtotal,'g');grid on;

% Pasabajos Implementado

load('Datos_Implementacion.mat');
Frecuencias_Implementado = Frecuencias_Implementado*2*pi;
semilogx(Frecuencias_Implementado,GananciadB_Implementado,'b');grid on;

legend('PasaBajos LTSpice','PasaBajos analitico', 'PasaBajos Implementado');
title('Función H(jw) Analítica, Simulación e Implementación')
xlabel('Frecuencia angular w [rad/s]');
ylabel('Magnitud H(jw) [dB]');


