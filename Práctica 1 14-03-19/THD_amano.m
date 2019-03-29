% Autores: Drag�n Valeria, Hamnstrom Luis, RRD Hern�n
% SAPS: 1er Cuatrimestre 2019
% 14-3-19

% Funci�n que calcula la distorsi�n arm�nica total de una se�al
% Recibe el m�dulo de la Transformada de Fourier, el vector de frecuencias
%   y la frecuencia fundamental de la se�al, y el n�mero de arm�nicos con el
%   que se desea trabajar
% Devuelve la distorsi�n arm�nica total en %

function thd_amano= THD_amano(absFFT,freq,frec_fund,num_arm)

arm_ind = zeros(1,num_arm);                                      % genera un vector con los �ndices de los arm�nicos
arm_sumat = 0;

for i=1:num_arm
    arm_ind(i) = find(freq==frec_fund*(i+1));                    % almacena los �ndices de los arm�nicos, calculados
                                                      
    arm_sumat = arm_sumat+(absFFT(arm_ind(i)))^2;                % suma los modulos al cuadrado de los arm�nicos
    
end


thd_amano = sqrt(arm_sumat)/ absFFT(find(freq==frec_fund))*100;  % aplica la f�rmula de THD

end