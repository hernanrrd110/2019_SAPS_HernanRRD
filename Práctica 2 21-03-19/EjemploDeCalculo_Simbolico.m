%%% Sistemas de Adquisici�n y Procesamiento de Se�ales %%%%
%%%
% Ejemplos de aplicaci�n:
%   Gu�a de Problemas N�1: An�lisis en frecuencia de Se�ales
%   Trabajo Pr�ctico N�1: Introducci�n al an�lisis y procesamiento de Se�ales

close all;
clear all;
clc;
%%%%%%%%% Ejemplo de c�lculo simb�lico %%%%%%%%%

% 1KWh = 3.600.000 joules
% per�odo de 50Hz = 20ms
% 1 joule = 1 watt.segundo


syms t positive; % Variable tiempo definida como simb�lica
frecuencia=50 % frecuencia en Hertz
seno=311.17*sin(2*pi*frecuencia*t) % tensi�n de red.(220VAC@50Hz)

%%% Energ�a de la se�al en un per�odo.
Energia= int(seno^2,0,1/frecuencia) % Calculo de la energ�a de la se�al en un per�odo de la misma, integrando la se�al elevada al cuadrado (�rea bajo la curva).
eval(Energia) %Energ�a expresada en Joules
%%% Potencia media de la se�al.
Potencia_media=frecuencia*int(seno^2,0,1/frecuencia) % Potencia media de la se�al, como la energ�a sobre el tiempo de un per�odo.
eval(Potencia_media)% Potencia en Watts
%%% Valor eficaz de la se�al.
Valor_eficaz=sqrt(frecuencia*int(seno^2,0,1/frecuencia)) % Valor eficaz de al se�al, como la ra�z de la potencia.
eval(Valor_eficaz) % valor eficaz en volts

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


