% Autores: Drag�n Valeria, Hamnstrom Luis, RRD Hern�n
% SAPS: 1er Cuatrimestre 2019
% 14-3-19

% Funci�n que calcula el error relativo porcentual 
% Recibe un valor de referencia y el valor de inter�s 
% Devuelve el error relativo porcentual

function error_relativo_porc = ERel(val_exact,val_med)

%Error Relativo Porcentual

error_relativo_porc = (abs(val_exact - val_med)/ (val_exact))*100;

end