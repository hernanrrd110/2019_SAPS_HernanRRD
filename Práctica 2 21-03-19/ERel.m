% Autores: Dragán Valeria, Hamnstrom Luis, RRD Hernán
% SAPS: 1er Cuatrimestre 2019
% 14-3-19

% Función que calcula el error relativo porcentual 
% Recibe un valor de referencia y el valor de interés 
% Devuelve el error relativo porcentual

function error_relativo_porc = ERel(val_exact,val_med)

%Error Relativo Porcentual

error_relativo_porc = (abs(val_exact - val_med)/ (val_exact))*100;

end