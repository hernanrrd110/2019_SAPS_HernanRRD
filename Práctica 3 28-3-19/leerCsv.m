% Función que lee un archivo .csv y devuelve los datos de la señal leída
% Recibe el nombre del archivo

function [vector_tiempo, vector_senial, num_muestras, frec_muestreo, esc_vertical] = leerCsv(archivo_senial)

% Numero de muestras
num_muestras = csvread(archivo_senial, 0, 1, [0 1 0 1]);
% Tiempo muestreo
tiempo_muestreo = csvread(archivo_senial, 1, 1, [1 1 1 1]);
% Escala vertical - Volts por division
esc_vertical = csvread(archivo_senial, 8, 1, [8 1 8 1]);
% Muestras
vector_senial = csvread(archivo_senial, 0, 4, [0 4 num_muestras-1 4]);

vector_tiempo = (0 : num_muestras - 1) * tiempo_muestreo;

frec_muestreo = 1 / tiempo_muestreo;

end