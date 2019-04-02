% Autores: RRD Hern�n
% SAPS: 1er Cuatrimestre 2019
% 14-3-19
% Ejercicio Procesamiento Audio
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
clc;
clear all;
close all;

fprintf('.....Informaci�n.....\r\n');
fprintf('.....Autor:Hernan_RRD.....\r\n');
fprintf('.....Procesamiento de seniales de audio.....\r\n');
%%%%% LECTURA DE LA SE�AL DE AUDIO %%%%%
% Cuadro de di�logo para abrir archivos, guarda nombre de archivo y direcci�n
[filename,pathname,~] = uigetfile('*.wav','Archivo de audio');
 
% Concatena direcci�n y nombre de archivo
file_senial = strcat(pathname,filename);
[vector_senial_estereo, frec_muestreo] = audioread(file_senial);

fprintf('.........Track AUDIO Seleccionado......... \r\n %s\r\n',file_senial);

%%%%El audio tiene dos canales, sacamos solo un canal
vector_senial_monoL  = vector_senial_estereo(:,1);


%%
num_muestras = length(vector_senial_monoL);

vector_tiempo = 0:1/frec_muestreo:(num_muestras-1)/frec_muestreo;
%%%% Podemos usar tambien: linspace(0,1/frec_muestreo,0)

%%%%% Extraemos el valor medio de la senial %%%%%
vector_senial_monoL = vector_senial_monoL - mean(vector_senial_monoL);

%%%%% C�LCULO DE FFT Audio %%%%%
FFT1  = fft(vector_senial_monoL, num_muestras) / num_muestras;
Modulo1 = 2*abs(FFT1);                                     % M�dulo de FFT
%%%%Nos quedamos con las frecuencias positivas
Modulo1 = Modulo1(1:floor(num_muestras/2));
freq = frec_muestreo/2*linspace(0,1,floor(num_muestras/2));% vector frecuencias [Hz]


%%%%% C�lculo de Max %%%%%

% M = max(Modulo1);
% M = max(abs(vector_senial_monoL));
M = 1;

%%%%%SENIAL DE TONO PURO
f_7k = 7000;
seno7K = M*sin(2*pi*f_7k*vector_tiempo);

seno7K = seno7K';

%%%%% C�LCULO DE FFT con 7K %%%%%

FFT1_con7K  = fft((vector_senial_monoL + seno7K), num_muestras) / num_muestras;
Modulo_con7K = 2*abs(FFT1_con7K);
Modulo_con7K = Modulo_con7K(1:floor(num_muestras/2)); %%%%floor = truncar




%%
%%%%%%%%%%%%%%%% GRAFICAS %%%%%%%%%%%%%%%%%%
close all;

figure1 = figure ('Color',[1 1 1],'Name','Track Audio','NumberTitle','off');
plot(vector_tiempo, vector_senial_monoL,'LineWidth',1);grid on;    
                            


title('Sinusoidal','FontSize',11,'FontName','Arial')
xlabel('Tiempo [seg]','FontSize',11,'FontName','Arial')
ylabel('Amplitud','FontSize',11,'FontName','Arial')

%%%%% Graficaci�n de M�dulo de FFT %%%%%
figure2 = figure('Color',[1 1 1],'Name','Track Audio','NumberTitle','off');
stem(freq, Modulo1, 'r','LineWidth',3);grid on;

title('Espectro')
xlabel('Frecuencia [Hz]','FontSize',11,'FontName','Arial')
ylabel('Modulo1','FontSize',11,'FontName','Arial')

%sound(vector_senial_monoL,frec_muesteo);
          
%%%%% Graficaci�n de M�dulo de FFT con 7K %%%%%
figure3 = figure('Color',[1 1 1],'Name','Track Audio con Tono 7K','NumberTitle','off');
stem(freq, Modulo_con7K, 'r','LineWidth',3);grid on;

title('Espectro')
xlabel('Frecuencia [Hz]','FontSize',11,'FontName','Arial')
ylabel('Modulo1','FontSize',11,'FontName','Arial')

%%%%% Graficaci�n de la senial de FFT %%%%%
figure4 = figure('Color',[1 1 1],'Name','Track Audio con Tono 7K','NumberTitle','off');
stem(vector_tiempo, (vector_senial_monoL + seno7K), 'r','LineWidth',3);grid on;

title('Sinusoidal','FontSize',11,'FontName','Arial')
xlabel('Tiempo [seg]','FontSize',11,'FontName','Arial')
ylabel('Amplitud','FontSize',11,'FontName','Arial')



