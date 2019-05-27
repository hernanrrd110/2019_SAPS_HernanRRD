clear all; close all; clc;

% Autores: RRD Hernán
% SAPS: 1er Cuatrimestre 2019
% 22-3-19
% Ejercicio Procesamiento Audio 3 silbidos 1k alarma
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
clc;
clear all;
close all;

fprintf('.....Información.....\r\n');
fprintf('.....Autor:Hernan_RRD.....\r\n');
fprintf('.....Procesamiento de seniales de audio.....\r\n');

%...................... LECTURA DE LA SEÑAL DE AUDIO ......................
% Cuadro de diálogo para abrir archivos, guarda nombre de archivo y dirección
% [filename,pathname,~] = uigetfile('*.wav','Archivo de audio');
% file_senial = strcat(pathname,filename);

file_senial = 'C:\Repositorio GitHub\2019_SAPS_HernanRRD\Teoria 11 27-05-19\3_silbidos_1_5kHz_alarma_audacity.wav';
[vector_senial_estereo, frec_muestreo] = audioread(file_senial);

fprintf('.........Track AUDIO Seleccionado......... \r\n %s\r\n',file_senial);

%%%% El audio tiene dos canales, sacamos solo un canal
vector_senial  = vector_senial_estereo(:,1);


%%
%..................... ACONDICIONAMIENTO DE LA SENIAL .....................

num_muestras = length(vector_senial);

vector_tiempo = 0:1/frec_muestreo:(num_muestras-1)/frec_muestreo;
%%%% Podemos usar tambien: linspace(0,1/frec_muestreo,0)

%%%%% Extraemos el valor medio de la senial %%%%%
vector_senial = vector_senial - mean(vector_senial);

%......................... CALCULO DE FFT AUDIO ..........................

FFT1  = fft(vector_senial, num_muestras) / num_muestras;
% Módulo de FFT
Modulo1 = 2*abs(FFT1);

%%%%Nos quedamos con las frecuencias positivas
Modulo1 = Modulo1(1:floor(num_muestras/2));
freq = frec_muestreo/2*linspace(0,1,floor(num_muestras/2));% vector frecuencias [Hz]

%% .............................. FILTRADO...................................

load('FiltroFIR.mat')
load('FiltroIIR.mat')
load('FiltroIIR1K5')

vector_filtradaFIR = filter(NumeradorFIR,1,vector_senial);
vector_filtradaIIR = filter(NumeradorIIR,DenominadorIIR,vector_senial);
vector_filtrada1K5 = filter(NumIIR1K5,DenIIR1K5,vector_senial);

%......................... FTT DEL SENIAL FILTRADA .........................

FFT_filtradaFIR  = fft((vector_filtradaFIR), num_muestras) / num_muestras;
Modulo_filtradaFIR = 2*abs(FFT_filtradaFIR);
Modulo_filtradaFIR = Modulo_filtradaFIR(1:floor(num_muestras/2));

FFT_filtradaIIR  = fft((vector_filtradaIIR), num_muestras) / num_muestras;
Modulo_filtradaIIR = 2*abs(FFT_filtradaIIR);
Modulo_filtradaIIR = Modulo_filtradaIIR(1:floor(num_muestras/2));

FFT_filtrada1K5  = fft((vector_filtrada1K5), num_muestras) / num_muestras;
Modulo_filtrada1K5 = 2*abs(FFT_filtrada1K5);
Modulo_filtrada1K5 = Modulo_filtrada1K5(1:floor(num_muestras/2));

%% .............................. GRAFICAS ...............................
close all;

figure ('Name','Track Audio','NumberTitle','off');
plot(vector_tiempo, vector_senial,'LineWidth',1);grid on;    

title('Sinusoidal','FontSize',11,'FontName','Arial')
xlabel('Tiempo [seg]','FontSize',11,'FontName','Arial')
ylabel('Amplitud','FontSize',11,'FontName','Arial')

%................... GRAFICACION FFT senial cruda .........................

figure('Color',[1 1 1],'Name','Track Audio','NumberTitle','off');
stem(freq, Modulo1, 'b','LineWidth',1);grid on;

title('Espectro')
xlabel('Frecuencia [Hz]','FontSize',11,'FontName','Arial')
ylabel('Modulo1','FontSize',11,'FontName','Arial')

%................. GRAFICACION senial filtrada FIR .......................

figure('Color',[1 1 1],'Name','Track Audio filtrada','NumberTitle','off');
plot(vector_tiempo, (vector_filtradaFIR), 'r','LineWidth',1);grid on;

title('Sinusoidal','FontSize',11,'FontName','Arial')
xlabel('Tiempo [seg]','FontSize',11,'FontName','Arial')
ylabel('Amplitud','FontSize',11,'FontName','Arial')

%................. GRAFICACION senial filtrada IIR .......................

figure('Color',[1 1 1],'Name','Track Audio filtrada','NumberTitle','off');
plot(vector_tiempo, (vector_filtradaIIR), 'r','LineWidth',1);grid on;

title('Sinusoidal','FontSize',11,'FontName','Arial')
xlabel('Tiempo [seg]','FontSize',11,'FontName','Arial')
ylabel('Amplitud','FontSize',11,'FontName','Arial')

figure('Color',[1 1 1],'Name','Track Audio filtrada','NumberTitle','off');
plot(freq, Modulo_filtradaIIR, 'r','LineWidth',1);grid on;

title('Sinusoidal','FontSize',11,'FontName','Arial')
xlabel('Tiempo [seg]','FontSize',11,'FontName','Arial')
ylabel('Amplitud','FontSize',11,'FontName','Arial')

figure('Color',[1 1 1],'Name','Track Audio filtrada','NumberTitle','off');
plot(freq, Modulo_filtrada1K5, 'r','LineWidth',1);grid on;

title('Sinusoidal','FontSize',11,'FontName','Arial')
xlabel('Tiempo [seg]','FontSize',11,'FontName','Arial')
ylabel('Amplitud','FontSize',11,'FontName','Arial')

sound(vector_filtrada1K5,frec_muestreo);









