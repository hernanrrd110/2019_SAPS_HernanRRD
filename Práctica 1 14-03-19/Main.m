% Autores: Drag�n Valeria, Hamnstrom Luis, RRD Hern�n
% SAPS: 1er Cuatrimestre 2019
% 14-3-19
% Actividad aliasing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
clc;
clear all;
close all;


%%%%% GENERACI�N DE LA SE�AL %%%%%
% Cuadro de di�logo para abrir archivos, guarda nombre de archivo y direcci�n
[filename,pathname,~] = uigetfile('*.csv','Archivos de Seniales');
 
% Concatena direcci�n y nombre de archivo
file = strcat(pathname,filename);

[vector_tiempo, vector_senial, num_muestras, frec_muestreo, esc_vertical] = leerCsv(file);
%%
clc;
close all;

% En esta secci�n trabajamos con la se�al F0007CH2
%%%%% Extraemos el valor medio de la senial %%%%%
vector_senial = vector_senial - mean(vector_senial);

%%%%% Graficamos la se�al temporalmente %%%%%
figure1 = figure ('Color',[1 1 1]);
plot(vector_tiempo, vector_senial,'LineWidth',1);grid on;    
                            
% axes1 = axes('Parent',figure1,'LineWidth',2,'FontSize',12,...
%     'FontName','Arial'); %Formato para las leyendas de los ejes

freq = frec_muestreo*linspace (0,1,num_muestras);           % vector de frecuencias en Hz

title('Sinusoidal','FontSize',11,'FontName','Arial')
xlabel('Tiempo [seg]','FontSize',11,'FontName','Arial')
ylabel('Amplitud','FontSize',11,'FontName','Arial')


%%%%% C�LCULO DE FFT %%%%%
FFT1  = fft(vector_senial, num_muestras) / num_muestras;       
Modulo1 = 2*abs(FFT1);                                      % M�dulo de FFT

%%%%% Graficaci�n de M�dulo de FFT %%%%%
figure2 = figure('Color',[1 1 1]);
stem(freq, Modulo1, 'r','LineWidth',3);grid on;

%xlim([0,frec_muestreo]);
xlim([0,100]);
title('Espectro')
xlabel('Frecuencia [Hz]','FontSize',11,'FontName','Arial')
ylabel('Modulo1','FontSize',11,'FontName','Arial')


%%%%% C�LCULOS EXTRA %%%%%
%%%%% C�lculo de la frecuencia fundamental de la se�al %%%%%

[M, orden_max] = max(Modulo1);                       % Encuentra el m�ximo
frec_fund = freq(orden_max);                         % Frecuencia de La0 medida


%%%%% C�lculo de Error Relativo Porcentual %%%%%

val_exact = 27.50;                                   % Frecuencia en Hz de La0 (de tabla)

error_relativo_porc = ERel(val_exact,frec_fund);     % Error relativo porcentual de la frecuencia medida


%%%%% C�lculo de TDH (Distorsi�n Arm�nica Total) %%%%%
THD = THD_amano(Modulo1, freq, frec_fund, 3);        % Calcula la THD para 3 arm�nicos

%dBTDH = thd(vector_senial);  

%%
%%%%% EJERCICIO EXTRA %%%%%
% Calcular la atenuaci�n (en dB) que debe aplicarse sobre los arm�nicos 2, 3 y 4 de la se�al F0011CH2
%   para lograr que la misma tenga una distorsi�n arm�nica menor al 5%.

THD_buscado = 4; % TDH Porcentual buscado

factor_atenuador = atenuarTHD(Modulo1, freq, frec_fund, 3, THD_buscado);    % Calcula el factor de atenuaci�n

factor_atenuador_dB = 20* (log(factor_atenuador));                           % Convierte a dB
                            
