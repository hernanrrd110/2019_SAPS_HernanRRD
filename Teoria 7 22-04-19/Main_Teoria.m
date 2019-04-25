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
[filename,pathname,~] = uigetfile('*.wav','Archivo de audio');
 
% Concatena dirección y nombre de archivo
file_senial = strcat(pathname,filename);
[vector_senial_estereo, frec_muestreo] = audioread(file_senial);

fprintf('.........Track AUDIO Seleccionado......... \r\n %s\r\n',file_senial);

%%%%El audio tiene dos canales, sacamos solo un canal
vector_senial_monoL  = vector_senial_estereo(:,1);


%%
%..................... ACONDICIONAMIENTO DE LA SENIAL .....................

num_muestras = length(vector_senial_monoL);

vector_tiempo = 0:1/frec_muestreo:(num_muestras-1)/frec_muestreo;
%%%% Podemos usar tambien: linspace(0,1/frec_muestreo,0)

%%%%% Extraemos el valor medio de la senial %%%%%
vector_senial_monoL = vector_senial_monoL - mean(vector_senial_monoL);

%......................... CALCULO DE FFT AUDIO ..........................

FFT1  = fft(vector_senial_monoL, num_muestras) / num_muestras;
% Módulo de FFT
Modulo1 = 2*abs(FFT1);

%%%%Nos quedamos con las frecuencias positivas
Modulo1 = Modulo1(1:floor(num_muestras/2));
freq = frec_muestreo/2*linspace(0,1,floor(num_muestras/2));% vector frecuencias [Hz]

% %.............................. FILTRADO...................................
% 
% load('Filtro_FIR_PB.mat')
% load('Filtro_IIR_PB.mat')
% 
% vector_senial_sucia_filtrada = filter(Coeficientes_flitroPB,1,vector_senial_sucia);
% 
% %......................... FTT DEL SENIALFILTRADA .........................
% 
% FFT_filtrada  = fft((vector_senial_sucia_filtrada), num_muestras) / num_muestras;
% Modulo_filtrada = 2*abs(FFT_filtrada);
% Modulo_filtrada = Modulo_filtrada(1:floor(num_muestras/2)); %%%%floor = truncar

%%
%.............................. GRAFICAS ...............................

close all;

figure1 = figure ('Color',[1 1 1],'Name','Track Audio','NumberTitle','off');
plot(vector_tiempo, vector_senial_monoL,'LineWidth',1);grid on;    

title('Sinusoidal','FontSize',11,'FontName','Arial')
xlabel('Tiempo [seg]','FontSize',11,'FontName','Arial')
ylabel('Amplitud','FontSize',11,'FontName','Arial')

%................. GRAFICACION FFT senial sin ruido .......................
figure2 = figure('Color',[1 1 1],'Name','Track Audio','NumberTitle','off');
stem(freq, Modulo1, 'b','LineWidth',1);grid on;

title('Espectro')
xlabel('Frecuencia [Hz]','FontSize',11,'FontName','Arial')
ylabel('Modulo1','FontSize',11,'FontName','Arial')


% %................. GRAFICACION senial con ruido filtrada .......................
% 
% figure5 = figure('Color',[1 1 1],'Name','Track Audio filtrada','NumberTitle','off');
% plot(vector_tiempo, (vector_senial_sucia_filtrada), 'r','LineWidth',1);grid on;
% 
% title('Sinusoidal','FontSize',11,'FontName','Arial')
% xlabel('Tiempo [seg]','FontSize',11,'FontName','Arial')
% ylabel('Amplitud','FontSize',11,'FontName','Arial')
% 
% %%..................... GRAFICACION FFT Tono 7K ...........................
% figure6 = figure('Color',[1 1 1],'Name','Track Audio filtrada','NumberTitle','off');
% stem(freq, Modulo_filtrada, 'r','LineWidth',1);grid on;
% 
% title('Espectro')
% xlabel('Frecuencia [Hz]','FontSize',11,'FontName','Arial')
% ylabel('Modulo1','FontSize',11,'FontName','Arial')





