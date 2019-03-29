% Autor: Javier Ruiz

% SAPS: 1er Cuatrimestre 2019
%16/03/19
% aliasing clase teorica 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; %limpia el comand line 
clear all;% limpia la memoria 
close all;% cierra todas las ventanas


%%%%%%%%%%%%%%%%%%%%%% Generación de Señales %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
S1 = 1000;      % Frecuencia de la señal 1
S2 = 2000;      % Frecuencia de la señal 2

L = 50000;      % Cantidad de muestras de la señal 50000
Fs = 10000;     % Frecuencia de muestreo

% linspace devuelve L= 50000 numeros equiespaciados entre 0 y 1 
%que multiplicados por Fs da el vector de frecuencias 
freq = Fs*linspace (0,1,L);  % Vector de frecuencia en Hz
                             % y = linspace(x1,x2,n) generates n points.
                             %The spacing between the points is (x2-x1)/(n-1).
                             %linspace is similar to the colon operator, ":",
                             %but gives direct control over the number of
                             %points and always includes the endpoints.
                             %"lin" in the name "linspace" refers to 
                             %generating linearly spaced values as opposed 
                             %to the sibling function logspace, which
                             %generates logarithmically spaced values..

                             
Tadq = L/Fs;                 % tiempo total en segundos de adquisición
salto_temporal=1 /Fs;                            
% se crea un vector con ":" 
t = 0:salto_temporal:Tadq-salto_temporal;        % Vector de tiempo en segundos
% prueba de ":"
% para que te des cuenta si lo pones asi tira 101 valores es decir de 0 a 100
prueba=0:1:100;
prueba2=0:1:100-1; % tira 100 valores de 0 a 99 es decir perdes un valor
% pero tenes la cantidad de valores que necesitas esto es importante por que
%necesitas que los vectores tengan un largo definido 

%%%%%%%%%%%%%%%%%%%%%%%% Declaracio de las funciones %%%%%%%%%%%%%%%%%%%

seno1k = 10*sin(2*pi*S1*t); 
seno2k = 1*sin(2*pi*S2*t);

%%%%%%%%%%Graficamos las señales ocn SUBPLOT siempre va asi  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% https://www.youtube.com/watch?v=ccHyAraGopE&t=30s
% https://www.youtube.com/watch?v=EYcprACdKfc
% https://www.youtube.com/watch?v=qcBLe4EG1J8
%"leyend" para especificar   graficas en el grafico 
%"text" para marcar algo en un punto de interes
%"annotation" para hacer uun cajita en la grafia
figure1 = figure ('Color',[1 1 1]); %%define la vntana 1 y el clor de la ventana e la que se hace el subplot
 subplot (2,1,1);                   %  subplot(m,n,p) divides the current figure into 
                                    %  an m-by-n grid and creates an axes for a subplot in the position 
                                    %  specified by p. MATLAB® numbers its subplots by row, such that the
                                    %  first subplot is the first column of the first row, the second subplot 
                                    %  is the second column of the first row, and so on. If the axes already
                                    %  exists, then the command subplot(m,n,p) makes the subplot in position p
                                    %  the current axes. 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%titulo de la grafica %%%%%%%%%%%%%%%%%%%%%%%%%
 title('Sinusoidal 1.000 Hz - fm = 10.000 Hz',...   %titulo
     'FontSize',11,...                              %tamaño de feunte
     'FontName','Arial')                            %tipo de fuente                                   
                                    
%%%%%%%%%%%%%%%%%%%grafica con baritas seno1k %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
stem(t, seno1k,...                 %grafica con barritas  seno1k vs t
'MarkerFaceColor',[0 0 0],...       %el color del relleno del marker 
'MarkerEdgeColor',[0 0 0],...       %el color de los bordes del marker 
'Marker','o',...                    %tipo de marker 
'LineWidth',1);grid;                %grosor de la barrita

%%% definicion de lo que vamos a mostrar %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 xlim([0 0.01]);                % Define el intervalo de graficación para el eje X
                                % para que grafique entre 0 y 0.01 sino te
                                % queda todo muy junto y no se ve nada
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%unica config para todos los ejes en%%%%
% <---------TIRA PROBLEMAS CO LA CONFIG De LOS EJES NO SE COMO SOLUCIONARLO
% %Formato para las leyendas de los ejes
% axes1 = axes('Parent',figure1,...       % donde 
%     'LineWidth',2,'FontSize',12,...     % tamaño de linea y tamaño de fuente
%  'FontName','Arial');                   % nombre de la fuente
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%leyenda de los ejes%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xlabel('Tiempo [seg]'...  %titulo eje x
    ,'FontSize',11,...    % fuente tamaño
    'FontName','Arial')   %tipo de fuente

ylabel('Amplitud',... %titulo eje y 
    'FontSize',11,... % tamaño de fuente
    'FontName','Arial')% tipo de fuente 

%%%%%%%%%%%%%%%%%%%%%  ANDA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%% grafica seno2k   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot (2,1,2);                 % subplot de la segunda grafica temporal 

%%%%%%%%%%%%%%%%%%%%%%%%TITULO%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
title('Sinusoidal 2.000 Hz - fm = 10.000 Hz'... % leyenda de la grafica 2
     ,'FontSize',11,...          %tamaño de la fuente del titulo  
 'FontName','Arial');            %tipo de fuente del titulo 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%TIPO DE GRAFICA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
stem(t, seno2k, ...              % grafica seno2k vs t
    'MarkerFaceColor',[0 0 0],...%color de relleno del marker 
    'MarkerEdgeColor',[0 0 0],...% color del borde del marker 
    'Marker','o'...              % tipo de marker 
    ,'LineWidth',1);grid;        % grosor de la linea no se que hace grid

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%PARTE QUE MOSTRAS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 xlim([0 0.01]);                 % define una ventana que se grafica de toda la señal 
                                 % para que grafique entre 0 y 0.01

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %%%%%%%%%%%%%%%%%%configuracion unica de los ejes esta mierda no anda %%%%%%%%%%%%%%%%%%%%%%
%     axes2 = axes('Parent',figure1...
%       ,'LineWidth',2,...    %grosor de la linea 
%       'FontSize',12,...     % tamaño de la fuente 
%       'FontName','Arial');  %fuente de de los ejes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CONFIGURACION DE LOS EJES%%%%%%%%%%%%%%%%%%%

xlabel('Tiempo [seg]',...        %leyenda del eje X
    'FontSize',11,...            %tamaño de la fuente
    'FontName','Arial')          %tipo de fuente

ylabel('Amplitud',...            %leyenda del eje Y 
     'FontSize',11,...           %tamaño de fuente 
     'FontName','Arial')         %tipo de fuente 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% Cálculo de FFT %%%%%%%%%%%%%%%%%%%%%%
 
FFTseno1k  = fft(seno1k,L)/L;  %FFT del seno (complejo) pero normalizada en 0 a 1
ModuloSeno1k = 2*abs(FFTseno1k); %Módulo de FFT preguntar por que el 2 

 FFTseno2k  = fft(seno2k,L)/L;  %FFT del seno (complejo)
ModuloSeno2k = 2*abs(FFTseno2k); %Módulo de FFT

%%%%%% Graficación de Módulo de FFT%%%%%%%%%%%%%%
 figure2 = figure('Color',[1 1 1]); %defino la ventana 2 y su color 
subplot(2,1,1);                     % subplot de 2 rengloes y una columna
plot(freq,ModuloSeno1k,...  % dibuja con lineas no stem modulo vs freq
    'r'...                  % define el color de la linea
    ,'LineWidth',3);grid;   % grosor de la linea y le deja el grid que es el rayado de la grafica
 ylim([0,20]);% define lo que se va a mostrar en el plot en el eje Y
 xlim([0,Fs]);% define lo que se va a mostrar en el plot en el eje X
 title('Esprectro de Sinusoidal 1.000 - fm = 10.000 Hz')% titulo del primer subplot 1,1
 xlabel('Frecuencia [Hz]','FontSize',11,'FontName','Arial')% titulo del eje X
 ylabel('ModuloSeno1k','FontSize',11,'FontName','Arial')% titulo del eje Y

subplot(2,1,2);% subplot 2 , 1
plot(freq,ModuloSeno2k,... % modulo vs freq de la TF de la señal 2 
    'c',...% color del trazo , esto es una propiedad que esta en la ayuda
    'LineWidth',3);grid;% ancho de la linea y muestra el grid
 ylim([0,5]);% limita el eje Y 
 xlim([0,Fs]);%limita el eje X
 title('Esprectro de Sinusoidal 2.000 - fm = 10.000 Hz')% titulo del plot 2 1
 xlabel('Frecuencia [Hz]','FontSize',11,'FontName','Arial')% etiqueta del eje X 
 ylabel('ModuloSeno2k','FontSize',11,'FontName','Arial')% etiqueta del eje Y

%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%notas%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  fft devuelve los valores de la transformada de fourier todos positivos 
%  pero lo que hace es mostrar los valores negativos espejados en Fm/2 e adelante hasta Fm
%  por eso tenes que tener cuidado cuando trabajes con la TdeF
