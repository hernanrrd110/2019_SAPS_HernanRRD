% Autores: RRD Hernan
% SAPS: 1er Cuatrimestre 2019
% 11504-19
% Demodulacion
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
clc;
clear all;
close all;

%.....................GENERACION SENIALES .....................
 
%%%% Parametros
Tadq = 2; % Duracion
frec_muestreo = 48000;

%%%% Moduladora
F1 = 10;      % Frecuencia de la señal modulante
F2 = 5;      % Frecuencia de la señal modulante
 

N = floor(Tadq*frec_muestreo);
% Vector de tiempo en segundos
t = 0:1/frec_muestreo:Tadq-(1/frec_muestreo); 

% Vector de frecuencia en Hz
freq = frec_muestreo/2*linspace(0,1,floor(N/2)); 

%Seniales moduladoras
Moduladora1 = 0.1*cos(2*pi*F1*t); 
Moduladora2 = 0.5*cos(2*pi*F2*t);
Moduladora = 1 + Moduladora1 + Moduladora2;

%%%% Portadora
F3 = 200; 
Portadora = cos(2*pi*F3*t);

%%%% Senial en conjunto
Senial = Portadora.*Moduladora; 

%......................... CALCULO DE FFT ..........................

Mod_Moduladora = 2*abs(fft(Moduladora, N)/N);
Mod_Moduladora = Mod_Moduladora(1:floor(N/2));

Mod_Portadora = 2*abs(fft(Portadora, N)/N);
Mod_Portadora = Mod_Portadora(1:floor(N/2));

Mod_Senial = 2*abs(fft(Senial, N)/N);
Mod_Senial = Mod_Senial(1:floor(N/2));

%................. GRAFICACION seniales ....................

figure1 = figure ('Color',[1 1 1],'Name','Seniales','NumberTitle','off');
plot(t, Senial,'LineWidth',1);grid on;    

title('Seniales','FontSize',11,'FontName','Arial')
xlabel('Tiempo [s]','FontSize',11,'FontName','Arial')
ylabel('Amplitud','FontSize',11,'FontName','Arial')

xlim([0 0.5]);

%................. GRAFICACION FFT senial ....................
figure2 = figure('Color',[1 1 1],'Name','FFTs seniales','NumberTitle','off');
stem(freq, Mod_Senial, 'b','LineWidth',1);grid on;

title('Espectro')
xlabel('Frecuencia [Hz]','FontSize',11,'FontName','Arial')
ylabel('Modulo','FontSize',11,'FontName','Arial')

xlim([0 3000]);




