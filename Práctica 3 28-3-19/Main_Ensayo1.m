% Autores: Dragan Valeria, Hamnstrom Luis, Rodriguez Ruiz Diaz Hernan
% SAPS: 1er Cuatrimestre 2019
% Fecha 14-3-19
% Ensayo 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
clc;
clear all;
close all;

%................... LECTURA DE ARCHIVO DE LA SENIAL ...................

% Cuadro de diálogo para abrir archivos, 
% guarda nombre de archivo y dirección
[filename,pathname,~] = uigetfile('*.csv','Archivos de Seniales');
 
% Concatena dirección y nombre de archivo
file_senial = strcat(pathname,filename);
[vector_tiempo, vector_senial, num_muestras, frec_muestreo, esc_vertical] = leerCsv(file_senial);

%%%%% Usamos esto para leer la FFT del Osc y sacar la RESOl. FREC
% [filename,pathname,~] = uigetfile('*.csv','Archivos de FFT');
% file_fft = strcat(pathname,filename);
% [resfrec_osc] = leerfftCsv(file_fft); %%% Resolucion Frecuencias Oscilos

................... ACONDICIONAMIENTO DE LA SENIAL ......................

%%%%%%% Recorte de la senial por problemas en el Osciloscopio
%%%% Solamente se hizo para las seniales de 55 y 27.5 Hz

%%%% inicio: 1, final: 2195 para 55 hz
%%%% inicio: 30, final: 2261 para 27.5 hz

% inicio_recorte = 30;
% final_recorte = 2261; 
% vector_senial = vector_senial(inicio_recorte:final_recorte);
% vector_tiempo = vector_tiempo(inicio_recorte:final_recorte);
% num_muestras = final_recorte-inicio_recorte;

%%%%% Extraemos el valor medio de la senial %%%%%
vector_senial = vector_senial - mean(vector_senial);

%...................... GRAFICA SENIAL TEMPORAL ........................

figure1 = figure ('Color',[1 1 1],'Name','Senial Temporal','NumberTitle','off');
plot(vector_tiempo, vector_senial,'LineWidth',1);grid on;    

title('Sinusoidal','FontSize',11,'FontName','Arial')
xlabel('Tiempo [seg]','FontSize',11,'FontName','Arial')
ylabel('Amplitud','FontSize',11,'FontName','Arial')

%......................... CALCULO DE FFT ..............................

FFT1  = fft(vector_senial, num_muestras) / num_muestras;
% Módulo de FFT
Modulo1 = 2*abs(FFT1);

%%%%Nos quedamos con las frecuencias positivas

Modulo1_positivas = Modulo1(1:floor(num_muestras/2));
vector_frec_positivas = frec_muestreo/2*linspace(0,1,floor(num_muestras/2));
vector_frec = frec_muestreo*linspace(0,1,num_muestras); 

%...................... GRAFICA ESPECTRO MODULO ........................

figure2 = figure('Color',[1 1 1],'Name','Espectro de Amplitud','NumberTitle','off');
stem(vector_frec_positivas, Modulo1_positivas, 'r','LineWidth',3);grid on;

title('Espectro de Amplitud')
xlabel('Frecuencia [Hz]','FontSize',11,'FontName','Arial')
ylabel('Modulo','FontSize',11,'FontName','Arial')

%................... CALCULO FRECUENCIA FUNDAMENTAL .....................

[M, orden_max] = max(Modulo1); 
% orden_max es el indice donde encontro el maximo
frec_fund = vector_frec(orden_max);                         

%..................... CALCULO ERROR PORCENTUAL .........................

%%% Frecuencia en Hz de la EDUCIA %%%
val_exact = 440;                                     

%%% Error relativo porcentual de la frecuencia medida %%%
error_relativo_porc = ERel(val_exact,frec_fund);     

%%% Cálculo de Resolución frecuencial en MatLab %%%
resfrec_Matlab = frec_muestreo/num_muestras;

%............................ CALCULO THD ..............................

%%%%% THD Total
THD_1Total = 10^(thd(vector_senial)/20)*100;

%%%%% THD con 2 Armonicos
THD_2Arm = 10^(thd(vector_senial,frec_muestreo,2)/20)*100;

%%%%% THD con 3 Armonicos
THD_3Arm = 10^(thd(vector_senial,frec_muestreo,3)/20)*100;

%%%%% THD con 4 Armonicos
THD_4Arm = 10^(thd(vector_senial,frec_muestreo,4)/20)*100;

  