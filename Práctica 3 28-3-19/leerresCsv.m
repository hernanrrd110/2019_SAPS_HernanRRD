% Funci�n que lee un archivo .csv y devuelve los datos de la se�al le�da
% Recibe el nombre del archivo

function [resfrec_osc] = leerresCsv(archivo_fft)
% Tiempo muestreo
resfrec_osc = csvread(archivo_senial, 1, 1, [1 1 1 1]);

end