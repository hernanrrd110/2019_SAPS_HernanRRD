% Función que lee un archivo .csv y devuelve los datos de la señal leída
% Recibe el nombre del archivo

function [resfrec_osc] = leerfftCsv(archivo_fft)
% Tiempo muestreo
resfrec_osc = csvread(archivo_fft, 1, 1, [1 1 1 1]);

end