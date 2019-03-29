% Autores: Dragán Valeria, Hamnstrom Luis, RRD Hernán
% SAPS: 1er Cuatrimestre 2019
% 14-3-19

% Función que calcula el factor de atenuación a aplicar sobre los armónicos
%    para obtener el TDH deseado
% Recibe el módulo de la Transformada de Fourier, el vector de frecuencias
%   y la frecuencia fundamental de la señal; el número de armónicos con el
%   que se desea trabajar y el valor de TDH al que se desea llegar
% Devuelve el valor del factor de atenuación

function factor_atenuador= atenuarTHD(absFFT,freq,frec_fund,num_arm,THD_Objetivo)

arm_ind = zeros(1,num_arm);
arm_sumat = 0;

for i=1:num_arm
    arm_ind(i) = find(freq==frec_fund*(i+1));         % almacena índices de los armónicos
    arm_sumat = arm_sumat+(absFFT(arm_ind(i)))^2;     % suma los modulos al cuadrado de los armónicos
    
end

% Este factor se multiplica por los armónicos de nuestra señal para atenuar su distorsión
% Se obtiene despejándolo de la fórmula de THD ACÁAA DUDAAAAA AAAHHHH el
% factor atenuador va al cuadrado (????
factor_atenuador = (THD_Objetivo * absFFT(find(freq==frec_fund)))^2 /(arm_sumat*(100)^2);        

end