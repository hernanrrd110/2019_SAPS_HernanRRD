% Autores: Dragan Valeria, Hamnstrom Luis, RRD Hernan
% SAPS: 1er Cuatrimestre 2019
% 11-04-19
% ENSAYO 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
clc;
clear all;
close all;

fprintf('.....Informaci�n.....\r\n');
fprintf('.....Autores: Dragan Valeria, Hamnstrom Luis, RRD Hernan.....\r\n');
fprintf('.....Procesamiento de seniales de audio.....\r\n');

%...................... LECTURA DE LA SE�AL DE AUDIO ......................
% Cuadro de di�logo para abrir archivos, guarda nombre de archivo y direcci�n
[filename,pathname,~] = uigetfile('*.wav','Archivo de audio');
 
% Concatena direcci�n y nombre de archivo
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
% M�dulo de FFT
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
% %.............................. GRAFICAS ...............................
% close all;
% 
% %................. GRAFICACION senial ....................
% 
% figure1 = figure ('Color',[1 1 1],'Name','Track Audio','NumberTitle','off');
% plot(vector_tiempo, vector_senial,'LineWidth',1);grid on;    
% 
% title('Se�ial','FontSize',11,'FontName','Arial')
% xlabel('Tiempo [seg]','FontSize',11,'FontName','Arial')
% ylabel('Amplitud','FontSize',11,'FontName','Arial')
% 
% %................. GRAFICACION FFT senial ....................
% figure2 = figure('Color',[1 1 1],'Name','Track Audio','NumberTitle','off');
% stem(freq, Modulo, 'b','LineWidth',1);grid on;
% 
% title('Espectro')
% xlabel('Frecuencia [Hz]','FontSize',11,'FontName','Arial')
% ylabel('Modulo','FontSize',11,'FontName','Arial')
% 

%%
%.............................. DETECCION ...............................

close all;

load('FiltroPasaBajo_6Hz.mat');
load('Coef_Butter_Silbidos.mat');

%%%% Filtrado inicial Pasa Banda
vector_filtrado = filter(Num,1,vector_senial);


%%%% Rectificaci�n
vector_filtrado = vector_filtrado.^2;

%%%% Demodulacion
% vector_filtrado = filter(FiltroPasaBajo_6Hz,1,vector_filtrado);

vector_filtrado = filter(Numerador_Butter,Denominador_Butter,vector_filtrado);

% vector_filtrado = movmean(vector_filtrado,2000);

%............... CALCULO DE FFT FILTRADO

Modulo_filtrado = 2*abs(fft(vector_filtrado, num_muestras) / num_muestras);

%%%%Nos quedamos con las frecuencias positivas
Modulo_filtrado = Modulo_filtrado(1:floor(num_muestras/2));
freq_filtrado = frec_muestreo/2*linspace(0,1,floor(num_muestras/2));% vector frecuencias [Hz]

%%% Comparacion

duracion_temporal_minima = 0.100;
duracion_temporal_maxima = 0.800;
intervalo_silbido_tiempo = 1;
limite_duracion=round(intervalo_silbido_tiempo*frec_muestreo);
frames_duracion_minima = round(duracion_temporal_minima*frec_muestreo)+1;
frames_duracion_maxima = round(duracion_temporal_maxima*frec_muestreo)+1;

vector_comparado = vector_filtrado;
umbral_alto = 0.006;
umbral_bajo = 0.002;
detectado = false;
contador = 0;
frame_detectado = 0;

for i=1:length(vector_filtrado)
    if (detectado == false)
        if (vector_filtrado(i)>umbral_alto)
            vector_comparado(i) = 0.1;
            detectado = true;
        else
            vector_comparado(i) = 0;
        end
    else
            if (vector_filtrado(i)<umbral_bajo)
            vector_comparado(i) = 0;
            detectado = false;
            else
            vector_comparado(i) = 0.1;
            end
    end
end

vector_silbidos = zeros(length(vector_comparado),1);
detectado = false;

cuenta_alarmas = 0;
cuenta_apagados = 0;

for j=1:length(vector_silbidos)
    if(detectado == false)
        if(vector_comparado(j) > 0)
            detectado = true;
            frame_detectado = j;
        end
    else
        if(vector_comparado(j) == 0)
            detectado = false;
            if((contador >= frames_duracion_minima) && ...
                    (contador < frames_duracion_maxima))
                vector_silbidos(frame_detectado) = 1;
            end
                contador = 0;  
            
        else
            contador = contador + 1;
        end
    end
end
                
            
            
        

 
modo_alarma = false;
contador = 0;
frame_detectado = 0;
contador_frames=0;


for i=1:length(vector_silbidos)
    
    if(modo_alarma == false)
        if(vector_silbidos(i) > 0)
            modo_alarma = true;
            cuenta_alarmas=cuenta_alarmas+1;
        end
    else
        contador_frames=contador_frames+1;
        
        if(contador_frames > limite_duracion)
            contador=0;
        end
   
        if(contador == 3)
            modo_alarma = false;
            contador_frames=0;
            contador = 0;
            cuenta_apagados = cuenta_apagados +1 ;
        else
            if(vector_silbidos(i) > 0 )
            contador = contador + 1;
            contador_frames=0;
            end
        end
    end
end

%................. GRAFICACION senial filtrada ....................
figure3 = figure ('Color',[1 1 1],'Name','Track Audio','NumberTitle','off');
plot(vector_tiempo, vector_filtrado,'LineWidth',1);grid on;    

title('Senial','FontSize',11,'FontName','Arial')
xlabel('Tiempo [seg]','FontSize',11,'FontName','Arial')
ylabel('Amplitud','FontSize',11,'FontName','Arial')

%................. GRAFICACION senial comparada ....................
hold on;
plot(vector_tiempo, vector_comparado,'LineWidth',1);grid on;    

title('Senial','FontSize',11,'FontName','Arial')
xlabel('Tiempo [seg]','FontSize',11,'FontName','Arial')
ylabel('Amplitud','FontSize',11,'FontName','Arial')

%................. GRAFICACION senial silbidos ....................
hold on;
plot(vector_tiempo, vector_silbidos,'LineWidth',1);grid on;    

title('Senial','FontSize',11,'FontName','Arial')
xlabel('Tiempo [seg]','FontSize',11,'FontName','Arial')
ylabel('Amplitud','FontSize',11,'FontName','Arial')



% %................. GRAFICACION FFT senial filtrada  ....................
% 
% figure5 = figure('Color',[1 1 1],'Name','Track Audio','NumberTitle','off');
% stem(freq_filtrado, Modulo_filtrado, 'b','LineWidth',1);grid on;
% 
% title('Espectro')
% xlabel('Frecuencia [Hz]','FontSize',11,'FontName','Arial')
% ylabel('Modulo filtrado','FontSize',11,'FontName','Arial')














