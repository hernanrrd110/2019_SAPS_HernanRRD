% Autores: Dragán Valeria, Hamnstrom Luis, RRD Hernán
% SAPS: 1er Cuatrimestre 2019
% 14-3-19
% Ensayo 1: Parte a
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
clc;
clear all;
close all;

%%%%% LECTURA DE LA SEÑAL %%%%%
% Cuadro de diálogo para abrir archivos, guarda nombre de archivo y dirección
[filename,pathname,~] = uigetfile('*.csv','Archivos de Seniales');
 
% Concatena dirección y nombre de archivo
file_senial = strcat(pathname,filename);
[vector_tiempo, vector_senial, num_muestras, frec_muestreo, esc_vertical] = leerCsv(file_senial);


[filename,pathname,~] = uigetfile('*.csv','Archivos de FFT');
file_fft = strcat(pathname,filename);
[resfrec_osc] = leerfftCsv(file_fft);

%%%%%%% Recorte de la senial para cuando aparece un bajon

%%%% 2195 para 55 hz
%%%% inicio: 11, final: 2261 para 27.5 hz

inicio_recorte =30;
final_recorte = 2261; 
vector_senial = vector_senial(inicio_recorte:final_recorte);
vector_tiempo = vector_tiempo(inicio_recorte:final_recorte);
num_muestras = final_recorte-inicio_recorte;

%%%%% Extraemos el valor medio de la senial %%%%%
vector_senial = vector_senial - mean(vector_senial);

%%%%% Graficamos la señal temporalmente %%%%%
figure1 = figure ('Color',[1 1 1]);
plot(vector_tiempo, vector_senial,'LineWidth',1);grid on;    
                            
% axes1 = axes('Parent',figure1,'LineWidth',2,'FontSize',12,...
%     'FontName','Arial'); %Formato para las leyendas de los ejes

freq = frec_muestreo*linspace (0,1,num_muestras);           % vector de frecuencias en Hz

title('Sinusoidal','FontSize',11,'FontName','Arial')
xlabel('Tiempo [seg]','FontSize',11,'FontName','Arial')
ylabel('Amplitud','FontSize',11,'FontName','Arial')


%%%%% CÁLCULO DE FFT %%%%%
FFT1  = fft(vector_senial, num_muestras) / num_muestras;       
Modulo1 = 2*abs(FFT1);                                      % Módulo de FFT

%%%%% Graficación de Módulo de FFT %%%%%
figure2 = figure('Color',[1 1 1]);
stem(freq, Modulo1, 'r','LineWidth',3);grid on;

%xlim([0,frec_muestreo]);
%xlim([0,100]);
title('Espectro')
xlabel('Frecuencia [Hz]','FontSize',11,'FontName','Arial')
ylabel('Modulo1','FontSize',11,'FontName','Arial')


%%%%% Cálculo de la frecuencia fundamental de la señal %%%%%

[M, orden_max] = max(Modulo1);                       % Encuentra el máximo
frec_fund = freq(orden_max);                         


%%%%% Cálculo de Error Relativo Porcentual %%%%%

val_exact = 27.5;                                     % Frecuencia en Hz de la EDUCIA

error_relativo_porc = ERel(val_exact,frec_fund);     % Error relativo porcentual de la frecuencia medida

%%%%% Cálculo de Resolución frecuencial en MatLab %%%%%
resfrec_Matlab = frec_muestreo/num_muestras;
  



