% Autores: Dragán Valeria, Hamnstrom Luis, RRD Hernán
% SAPS: 1er Cuatrimestre 2019
% 14-3-19

% Función que calcula la distorsión armónica total de una señal
% Recibe el módulo de la Transformada de Fourier, el vector de frecuencias
%   y la frecuencia fundamental de la señal, y el número de armónicos con el
%   que se desea trabajar
% Devuelve la distorsión armónica total en %

function thd_amano= THD_amano(absFFT,freq,frec_fund,num_arm)

arm_ind = zeros(1,num_arm);                                      % genera un vector con los índices de los armónicos
arm_sumat = 0;

for i=1:num_arm
    arm_ind(i) = find(freq==frec_fund*(i+1));                    % almacena los índices de los armónicos, calculados
                                                      
    arm_sumat = arm_sumat+(absFFT(arm_ind(i)))^2;                % suma los modulos al cuadrado de los armónicos
    
end


thd_amano = sqrt(arm_sumat)/ absFFT(find(freq==frec_fund))*100;  % aplica la fórmula de THD

end