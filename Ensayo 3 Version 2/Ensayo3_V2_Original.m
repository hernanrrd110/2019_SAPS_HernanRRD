%% ............................ ENSAYO 3 ..................................
% Autores: Dragan Valeria, Hamnstrom Luis, Rodriguez Ruiz Diaz Hernan
% SAPS: 1er Cuatrimestre 2019
% 09-05-19
%--------------------------------------------------------------------------

%%
clear all; close all; clc;

w1 = 2*pi*1000; % Frecuencia de corte inferior [rad/s]
w2 = 2*pi*3000; % Frecuencia de corte superior [rad/s]
B = w2-w1; % Ancho de banda de paso [rad/s]

w0 = sqrt(w1*w2); % Frecuencia central de desnormalizacion de Pasabanda
w_8000 = 2*pi*8000;
w_Normalizado_8000 = (w_8000^2-w0^2)/(B*w_8000);

% El numero de bits de resolucion que tiene el conversor AD
numero_bits  = 10;

% Rango dinámico del conversor para la atenuación en la banda de rechazo
RD = -6.02*numero_bits - 1.76 ; % en DB

% orden del filtro, inicializado en 0 (de esta manera dentro de ciclo 
% while se comienza evaluando desde orden 1)
n = 0;

Rp = 3;
% genero un vector de frecuencias para la graficación
w = linspace(0.1,10,1000); 

figure(1)
At_Actual = 0;

% repito el ciclo aumentando el orden hasta que se cumpla con el requisito 
% de atenuación 
while (At_Actual > RD)
    
    % pruebo con el orden siguiente
    n = n+1; 
    
    % obtengo polos, ceros y ganancia del filtro pasa bajos normalizado de 
    % orden n
    [z,p,k]=cheb1ap(n,Rp); 
    
    % obtengo numerador y denominador de la funcion de transferencia del 
    % filtro normalizado de orden n
    [Num,Den] = zp2tf(z,p,k); 
    
    h = 20*log10(abs(freqs(Num,Den, [0 w_Normalizado_8000])));
    At_Actual = h(2); 
    
    % Con fines demostrativos, graficamos la respuesta de los filtros de 
    % distinto orden
    
    % respuesta en magnitud del filtro de orden n
    mag_n = 20 * log10 (abs(freqs(Num,Den,w)));
    %%% Funcion de transferencia en s normalizada de Chevyshev
    
    semilogx(w,mag_n);
    hold on
    
end

% graficamos tb el requisito de atenuación a cumplir
semilogx(w_Normalizado_8000,RD,'*');
title('Filtro Pasabajo Chebyshev Normalizado');
ylabel('|H(w)|^2 [dB]');
xlabel('Frecuencia (rad/s)');

grid on
hold off

%% .................... PARAMETROS DEL FILTRO CHEVYSHEV ...................

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
Magnitud_Pasabanda = 20*log10(abs(Respuesta_Freq_PasaBanda));
freq = W/(2*pi);

semilogx(freq,Magnitud_Pasabanda);grid on;
title('H(jw) desnormalizada Pasabanda')
xlabel('Frecuencia f [Hz]');
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

semilogx(freq,Maginitud_L_Pass1,'r');grid on; hold on;

% Segunda Seccion
Respuesta_L_Pass2 = freqs(L_Pass2.Numerator{1},L_Pass2.Denominator{1},W);
Magnitud_L_Pass2 = 20*log10(abs(Respuesta_L_Pass2));

semilogx(freq,Magnitud_L_Pass2,'g');grid on; hold on;

% Tercera Seccion
Respuesta_L_Passtotal = freqs(L_Passtotal.Numerator{1},L_Passtotal.Denominator{1},W);
Magnitud_L_Passtotal = 20*log10(abs(Respuesta_L_Passtotal));

semilogx(freq,Magnitud_L_Passtotal,'b');grid on; 
legend('PasaBajos 1','PasaBajos 2','PasaBajos Total');
title('H(jw) de Seccion 1, 2 y total')
xlabel('Frecuencia f [Hz]');
ylabel('Magnitud H(jw) [dB]');

% ---------- Graficacion Bode LTSpice y  Pasabajos Analitico -------------

figure('Color',[1 1 1],'Name','H(jw) de Secciones','NumberTitle','off');

% LTSpice
[freqLTSpice,dB] = import_ac_LTSpice('LTSpice_Cell3.txt');

% freq = freq*2*pi;
semilogx(freqLTSpice,dB,'r');
hold on;
grid on;

% Pasabajos Analitico
semilogx(freq,Magnitud_L_Passtotal,'g');grid on;

legend('PasaBajos LTSpice','PasaBajos analitico');
title('Función H(jw) Analítica, Simulación')
xlabel('Frecuencia f [Hz]');
ylabel('Magnitud H(jw) [dB]');

% ----- Graficacion Bode LTSpice, Pasabajos Analitico e Implementado -----

figure('Color',[1 1 1],'Name','H(jw) de Secciones','NumberTitle','off');

% LTSpice
[freqLTSpice,dB] = import_ac_LTSpice('LTSpice_Cell3.txt');

semilogx(freqLTSpice,dB,'r');
hold on;
grid on;

% Pasabajos Analitico
semilogx(freq,Magnitud_L_Passtotal,'g');grid on;

% Pasabajos Implementado

load('Datos_Implementacion.mat');
semilogx(Frecuencias_Implementado,GananciadB_Implementado,'b');grid on;

legend('PasaBajos LTSpice','PasaBajos analitico', 'PasaBajos Implementado');
title('Función H(jw) Analítica, Simulación e Implementación')
xlabel('Frecuencia f [Hz]');
ylabel('Magnitud H(jw) [dB]');


