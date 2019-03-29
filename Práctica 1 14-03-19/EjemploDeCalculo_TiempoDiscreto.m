%%% Sistemas de Adquisici�n y Procesamiento de Se�ales %%%%
%
% Ejemplos de aplicaci�n:
%   Gu�a de Problemas N�1: An�lisis en frecuencia de Se�ales
%   Trabajo Pr�ctico N�1: Introducci�n al an�lisis y procesamiento de Se�ales



%%%%%%%%%%%%%%%%% Ejemplo en tiempo discreto %%%%%%%%%%%%%%%%%
close all;
clear all;
clc;
%%%%%%%Vectores de ejes Tiempo y Frecuencia
L = 4000; %Cantidad de muestras de la se�al   %length(data)
NFFT = 2^(nextpow2(L));% potencia de 2 mas cercana superior al tama�o del vector 
Fs =1000;%Frecuencia de muestreo
freq= Fs/2*linspace(0,1,NFFT/2+1);% vector de frecuencia en Hz
Tadq=L/Fs;%tiempo en segundo de la se�al adquirida
t=0:1/Fs:Tadq-1/Fs;% vector de tiempo en segundo

seno = 311.17*sin(2*pi*50*t);%Simulamos tensi�n de red electrica domiciliaria (220VAC@50Hz) 
 
%%%%%%%Calculo de la Energ�a de la Se�al en tiempo discreto%%%%%%%%%%%%%%

TenergiaSimulada= norm(seno)^2/(L/Tadq)%% se aplica lanorma dos, se elva al cuadrado y se multiplica por el periodo de muestreo 

%%%%%%%Calculo de la potencia media de la Se�al en tiempo discreto%%%%%%%%%%%%%%

TPOTMediaSimulada= (norm(seno)^2/(L/Tadq))/Tadq %% se suma cada elemento del vector elevado al cuadrado, se aplica la raiz cuadrada y se lo eleva al cuadrado y  se divide por Fs 

%%%%%%%Calculo de Vrms de la Se�al en tiempo discreto%%%%%%%%%%%%%%

TVrmsSimulada= ((norm(seno)^2/(L/Tadq))/Tadq)^0.5 %% se suma cada elemento del vector elevado al cuadrado, se aplica la raiz cuadrada y se lo eleva al cuadrado y  se divide por Fs 


%%%%%%%Calculo de la Energ�a de la energ�a de la Se�al en frecuencia discreta%%%%%%%%%%%%%%
%%%%%%%%% Identidad de parseval
%
%  Energia= sum(se�al)^2 = 1/L *sum (|S(f)|^2)
%
FFTSimulada = fft(seno,NFFT);
FenergiaSimulada = sum(abs(FFTSimulada).^2)/(Fs*L)

%%%%%%%%%%%% Graficaci�n y Espectro %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FFTseno=fft(seno,NFFT)/L;%FFT del seno (magnitud y fase)
ModuloSeno= 2*abs(FFTseno(1:NFFT/2+1));%Modulo de FFT del seno
subplot(2,1,1);
plot(t,seno);
ylim([-350 350]);
xlim([0 0.25]);
title('se�al simulada seno(t)')
xlabel('tiempo (segundos)')
subplot(2,1,2);
plot(freq, ModuloSeno);
ylim([0 350]);
xlim([30 70]);
title('La mitad del espectro del seno (t)')
xlabel('Frecuencia(Hz)')
ylabel('|S(f)|')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%Resolucion temporal: 1/Fs
%Resolucion Frecuencial: Fs/L 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 


 