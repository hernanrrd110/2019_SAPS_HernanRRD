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
[vector_senial, frec_muestreo] = audioread(file_senial);

fprintf('.........Track AUDIO Seleccionado......... \r\n %s\r\n',filename);

load('HanningSilbido.mat');
load('FiltroPasaBajo_6Hz.mat');


%%
%..................... ACONDICIONAMIENTO DE LA SENIAL .....................

num_muestras = length(vector_senial);

vector_tiempo = 0:1/frec_muestreo:(num_muestras-1)/frec_muestreo;
%%%% Podemos usar tambien: linspace(0,1/frec_muestreo,0)

%%%%% Extraemos el valor medio de la senial %%%%%
vector_senial = vector_senial - mean(vector_senial);

%......................... CALCULO DE FFT AUDIO ..........................

FFT  = fft(vector_senial, num_muestras) / num_muestras;
% Módulo de FFT
Modulo = 2*abs(FFT);

%%%%Nos quedamos con las frecuencias positivas
Modulo = Modulo(1:floor(num_muestras/2));
freq = frec_muestreo/2*linspace(0,1,floor(num_muestras/2));% vector frecuencias [Hz]

%................... CALCULO FRECUENCIA FUNDAMENTAL .....................

[M, orden_max] = max(Modulo); 
% orden_max es el indice donde encontro el maximo
frec_fund = freq(orden_max);                                               

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

%................. GRAFICACION senial ....................

figure1 = figure ('Color',[1 1 1],'Name','Track Audio','NumberTitle','off');
plot(vector_tiempo, vector_senial,'LineWidth',1);grid on;    

title('Señial','FontSize',11,'FontName','Arial')
xlabel('Tiempo [seg]','FontSize',11,'FontName','Arial')
ylabel('Amplitud','FontSize',11,'FontName','Arial')

%................. GRAFICACION FFT senial ....................
figure2 = figure('Color',[1 1 1],'Name','Track Audio','NumberTitle','off');
stem(freq, Modulo, 'b','LineWidth',1);grid on;

title('Espectro')
xlabel('Frecuencia [Hz]','FontSize',11,'FontName','Arial')
ylabel('Modulo','FontSize',11,'FontName','Arial')


%%
%.............................. DETECCION ...............................

close all;

load('FiltroPasaBajo_6Hz.mat');

%%%% Filtrado inicial Pasa Banda
vector_filtrado = filter(Num,1,vector_senial);

%%%% Rectificación
vector_filtrado = vector_filtrado.^2;

%%%%Demodulacion
vector_filtrado = filter(FiltroPasaBajo_6Hz,1,vector_filtrado);

vector_filtrado = movmean(vector_filtrado,2000);

%........................ CALCULO DE FFT FILTRADO .........................

Modulo_filtrado = 2*abs(fft(vector_filtrado, num_muestras) / num_muestras);

%%%%Nos quedamos con las frecuencias positivas
Modulo_filtrado = Modulo_filtrado(1:floor(num_muestras/2));
freq_filtrado = frec_muestreo/2*linspace(0,1,floor(num_muestras/2));% vector frecuencias [Hz]

%................. GRAFICACION senial filtrada ....................
figure3 = figure ('Color',[1 1 1],'Name','Track Audio','NumberTitle','off');
plot(vector_tiempo, vector_filtrado,'LineWidth',1);grid on;    

title('Señial','FontSize',11,'FontName','Arial')
xlabel('Tiempo [seg]','FontSize',11,'FontName','Arial')
ylabel('Amplitud','FontSize',11,'FontName','Arial')

%................. GRAFICACION FFT senial filtrada  ....................

figure4 = figure('Color',[1 1 1],'Name','Track Audio','NumberTitle','off');
stem(freq_filtrado, Modulo_filtrado, 'b','LineWidth',1);grid on;

title('Espectro')
xlabel('Frecuencia [Hz]','FontSize',11,'FontName','Arial')
ylabel('Modulo filtrado','FontSize',11,'FontName','Arial')














