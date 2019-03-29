% Autores: Drag�n Valeria, Hamnstrom Luis, RRD Hern�n
% SAPS: 1er Cuatrimestre 2019
% 14-3-19
% Ensayo 1: Parte a
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
clc;
clear all;
close all;

%%%%% LECTURA DE LA SE�AL %%%%%
% Cuadro de di�logo para abrir archivos, guarda nombre de archivo y direcci�n
[filename,pathname,~] = uigetfile('*.csv','Archivos de Seniales');
 
% Concatena direcci�n y nombre de archivo
file_senial = strcat(pathname,filename);
[vector_tiempo, vector_senial, num_muestras, frec_muestreo, esc_vertical] = leerCsv(file_senial);

[filename,pathname,~] = uigetfile('*.csv','Archivos de FFT');
file_fft = strcat(pathname,filename);
[resfrec_osc] = leerfftCsv(file_fft);

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
%xlim([0,100]);
title('Espectro')
xlabel('Frecuencia [Hz]','FontSize',11,'FontName','Arial')
ylabel('Modulo1','FontSize',11,'FontName','Arial')


%%%%% C�lculo de la frecuencia fundamental de la se�al %%%%%

[M, orden_max] = max(Modulo1);                       % Encuentra el m�ximo
frec_fund = freq(orden_max);                         


%%%%% C�lculo de Error Relativo Porcentual %%%%%

val_exact = 440;                                     % Frecuencia en Hz de la EDUCIA

error_relativo_porc = ERel(val_exact,frec_fund);     % Error relativo porcentual de la frecuencia medida

%%%%% C�lculo de Resoluci�n frecuencial en MatLab %%%%%
resfrec_Matlab = frec_muestreo/num_muestras;
  



