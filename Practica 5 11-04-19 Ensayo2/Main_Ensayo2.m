% Autores: Dragan Valeria, Hamnstrom Luis, RRD Hernan
% SAPS: 1er Cuatrimestre 2019
% 11-04-19
% ENSAYO 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
clc;
clear all;
close all;

fprintf('.....Información.....\r\n');
fprintf('.....Autores: Dragan Valeria, Hamnstrom Luis, RRD Hernan.....\r\n');
fprintf('.....Procesamiento de seniales de audio.....\r\n');

%...................... LECTURA DE LA SEÑAL DE AUDIO ......................
% Cuadro de diálogo para abrir archivos, guarda nombre de archivo y dirección
[filename,pathname,~] = uigetfile('*.wav','Archivo de audio');
 
% Concatena dirección y nombre de archivo
file_senial = strcat(pathname,filename);
[vector_senial_mono, frec_muestreo] = audioread(file_senial);

fprintf('.........Track AUDIO Seleccionado......... \r\n %s\r\n',file_senial);

load('HanningSilbido.mat');

%%
%..................... ACONDICIONAMIENTO DE LA SENIAL .....................
%%%% Recorte de la senial 

tiempo_inicial = 10;
tiempo_final = 12;
vector_recortada1 = recorte_tiempo(vector_senial_mono,...
    tiempo_inicial ,tiempo_final,frec_muestreo);

% tiempo_inicial1 = 1.4;
% tiempo_final1 = 15;
% vector_senial_mono = recorte_tiempo(vector_senial_mono,...
%     tiempo_inicial1 ,tiempo_final1,frec_muestreo);


num_muestras = length(vector_senial_mono);

vector_tiempo = 0:1/frec_muestreo:(num_muestras-1)/frec_muestreo;
%%%% Podemos usar tambien: linspace(0,1/frec_muestreo,0)

%%%%% Extraemos el valor medio de la senial %%%%%
vector_senial_mono = vector_senial_mono - mean(vector_senial_mono);

%......................... CALCULO DE FFT AUDIO ..........................

FFT  = fft(vector_senial_mono, num_muestras) / num_muestras;
% Módulo de FFT
Modulo = 2*abs(FFT);

%%%%Nos quedamos con las frecuencias positivas
Modulo = Modulo(1:floor(num_muestras/2));
freq = frec_muestreo/2*linspace(0,1,floor(num_muestras/2));% vector frecuencias [Hz]

%%%%%CALCULO DE FFT RECORTADA

num_muestras1 = length(vector_recortada1);
FFT1  = fft(vector_recortada1,num_muestras1) / num_muestras1;
% Módulo de FFT
Modulo1 = 2*abs(FFT1);

%%%%Nos quedamos con las frecuencias positivas
Modulo1 = Modulo1(1:floor(num_muestras1/2));
freq1 = frec_muestreo/2*linspace(0,1,floor(num_muestras1/2));% vector frecuencias [Hz]

%................... CALCULO FRECUENCIA FUNDAMENTAL .....................

[M, orden_max] = max(Modulo); 
% orden_max es el indice donde encontro el maximo
frec_fund = freq(orden_max);                         


[M, orden_max] = max(Modulo1); 
% orden_max es el indice donde encontro el maximo
frec_fund1 = freq1(orden_max);                         


% %................ CALCULO DE RELACION SENIAL RUIDO........................
% 
% Relacion_senial_ruido = sum((vector_senial_mono).^2)/sum((seno7K).^2);
% 
% Relacion_senial_ruido_matlab = snr(vector_senial_mono,seno7K);
% Relacion_senial_ruido_matlab = 10^(Relacion_senial_ruido_matlab/20);
% 
% %.............................. FILTRADO...................................
% 
% load('Filtro_PB.mat')
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
plot(vector_tiempo, vector_senial_mono,'LineWidth',1);grid on;    

title('Sinusoidal','FontSize',11,'FontName','Arial')
xlabel('Tiempo [seg]','FontSize',11,'FontName','Arial')
ylabel('Amplitud','FontSize',11,'FontName','Arial')

%................. GRAFICACION FFT senial sin recortar .......................
figure2 = figure('Color',[1 1 1],'Name','Track Audio','NumberTitle','off');
stem(freq, Modulo, 'b','LineWidth',1);grid on;

title('Espectro')
xlabel('Frecuencia [Hz]','FontSize',11,'FontName','Arial')
ylabel('Modulo','FontSize',11,'FontName','Arial')

%................. GRAFICACION senial recortada.......................

figure3 = figure ('Color',[1 1 1],'Name','Track Audio recortado','NumberTitle','off');
plot(vector_recortada1,'LineWidth',1);grid on;    

title('Sinusoidal','FontSize',11,'FontName','Arial')
xlabel('Tiempo [seg]','FontSize',11,'FontName','Arial')
ylabel('Amplitud','FontSize',11,'FontName','Arial')

%................. GRAFICACION FFT senial recortada.......................
figure4 = figure('Color',[1 1 1],'Name','FFT Audio recortado','NumberTitle','off');
stem(freq1, Modulo1, 'b','LineWidth',1);grid on;

title('Espectro')
xlabel('Frecuencia [Hz]','FontSize',11,'FontName','Arial')
ylabel('Modulo','FontSize',11,'FontName','Arial')


%sound(vector_senial_mono,frec_muesteo);          

% %................. GRAFICACION senial con ruido filtrada .......................
% 
% figure5 = figure('Color',[1 1 1],'Name','Track Audio filtrada','NumberTitle','off');
% plot(vector_tiempo, (vector_senial_sucia_filtrada), 'r','LineWidth',1);grid on;
% 
% title('Sinusoidal','FontSize',11,'FontName','Arial')
% xlabel('Tiempo [seg]','FontSize',11,'FontName','Arial')
% ylabel('Amplitud','FontSize',11,'FontName','Arial')

%%
%.............................. DETECCION ...............................

vector_filtrado=filter(Num,1,vector_senial_mono);

vector_filtrado= vector_filtrado.^2;











