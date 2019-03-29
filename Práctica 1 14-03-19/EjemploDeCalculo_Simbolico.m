%%% Sistemas de Adquisición y Procesamiento de Señales %%%%
%%%
% Ejemplos de aplicación:
%   Guía de Problemas N°1: Análisis en frecuencia de Señales
%   Trabajo Práctico N°1: Introducción al análisis y procesamiento de Señales

close all;
clear all;
clc;
%%%%%%%%% Ejemplo de cálculo simbólico %%%%%%%%%

% 1KWh = 3.600.000 joules
% período de 50Hz = 20ms
% 1 joule = 1 watt.segundo


syms t positive; % Variable tiempo definida como simbólica
frecuencia=50 % frecuencia en Hertz
seno=311.17*sin(2*pi*frecuencia*t) % tensión de red.(220VAC@50Hz)

%%% Energía de la señal en un período.
Energia= int(seno^2,0,1/frecuencia) % Calculo de la energía de la señal en un período de la misma, integrando la señal elevada al cuadrado (área bajo la curva).
eval(Energia) %Energía expresada en Joules
%%% Potencia media de la señal.
Potencia_media=frecuencia*int(seno^2,0,1/frecuencia) % Potencia media de la señal, como la energía sobre el tiempo de un período.
eval(Potencia_media)% Potencia en Watts
%%% Valor eficaz de la señal.
Valor_eficaz=sqrt(frecuencia*int(seno^2,0,1/frecuencia)) % Valor eficaz de al señal, como la raíz de la potencia.
eval(Valor_eficaz) % valor eficaz en volts

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


