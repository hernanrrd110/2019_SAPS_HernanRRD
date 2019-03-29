% Autor: Hern�n RRD
% SAPS: 1er Cuatrimestre 2019
% 11-3-19
% Actividad aliasing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;
clear all;
close all;


%%%%%%%%% Generaci�n de Se�ales %%%%%%%%%%
S1 = 1000;      % Frecuencia de la se�al 1
S2 = 2000;      % Frecuencia de la se�al 2

L = 50000;      % Cantidad de muestras de la se�al 50000
Fs = 10000;     % Frecuencia de muestreo

freq = Fs*linspace (0,1,L);  % Vector de frecuencia en Hz
Tadq = L/Fs;                 % tiempo en segundos de la ventana de adquisici�n

t = 0:1/Fs:Tadq-1/Fs;        % Vector de tiempo en segundos

seno1k = 10*sin(2*pi*S1*t); 
seno2k = 1*sin(2*pi*S2*t);

%%%% Graficamos temporalmente%%%%

figure1 = figure ('Color',[1 1 1]);
subplot (2,1,1);
stem(t, seno1k, 'MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[0 0 0],...
    'Marker','o','LineWidth',1);grid;    % Para que grafique como palitos
                                         % Marca con colorcitos las muestras


xlim([0 0.01]);             % Define el intervalo de graficaci�n para el eje x
                            % para que grafique entre 0 y 0.01
axes1 = axes('Parent',figure1,'LineWidth',2,'FontSize',12,...
    'FontName','Arial'); %Formato para las leyendas de los ejes

title('Sinusoidal 1.000 Hz - fm = 10.000 Hz','FontSize',11,'FontName','Arial')
xlabel('Tiempo [seg]','FontSize',11,'FontName','Arial')
ylabel('Amplitud','FontSize',11,'FontName','Arial')


subplot (2,1,2);
plot(t, seno2k, 'MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[0 0 0],...
    'Marker','o','LineWidth',1);grid;    % Para que grafique como palitos
                                         % Marca con colorcitos las muestras

xlim([0 0.01]);             % Define el intervalo de graficaci�n para el eje x
                            % para que grafique entre 0 y 0.01
axes2 = axes('Parent',figure1,'LineWidth',2,'FontSize',12,'FontName','Arial'); %Formato para las leyendas de los ejes

title('Sinusoidal 2.000 Hz - fm = 10.000 Hz','FontSize',11,'FontName','Arial')
xlabel('Tiempo [seg]','FontSize',11,'FontName','Arial')
ylabel('Amplitud','FontSize',11,'FontName','Arial')

%%%%%%%%%%% C�lculo de FFT %%%%%%%%%%%%%%%%%%%%%%

FFTseno1k  = fft(seno1k,L)/L;  %FFT del seno (complejo)
ModuloSeno1k = 2*abs(FFTseno1k); %M�dulo de FFT

FFTseno2k  = fft(seno2k,L)/L;  %FFT del seno (complejo)
ModuloSeno2k = 2*abs(FFTseno2k); %M�dulo de FFT

%%%%%% Graficaci�n de M�dulo de FFT%%%%%%%%%%%%%%
figure2 = figure('Color',[1 1 1]);
subplot(2,1,1);
plot(freq,ModuloSeno1k, 'r','LineWidth',3);grid;
ylim([0,20]);
xlim([0,Fs]);
title('Esprectro de Sinusoidal 1.000 - fm = 10.000 Hz')
xlabel('Frecuencia [Hz]','FontSize',11,'FontName','Arial')
ylabel('ModuloSeno1k','FontSize',11,'FontName','Arial')

subplot(2,1,2);
plot(freq,ModuloSeno2k, 'r','LineWidth',3);grid;
ylim([0,5]);
xlim([0,Fs]);
title('Esprectro de Sinusoidal 2.000 - fm = 10.000 Hz')
xlabel('Frecuencia [Hz]','FontSize',11,'FontName','Arial')
ylabel('ModuloSeno2k','FontSize',11,'FontName','Arial')

                            
