% Autores: Drag�n Valeria, Hamnstrom Luis, RRD Hern�n
% SAPS: 1er Cuatrimestre 2019
% 14-3-19

% Funci�n que calcula el factor de atenuaci�n a aplicar sobre los arm�nicos
%    para obtener el TDH deseado
% Recibe el m�dulo de la Transformada de Fourier, el vector de frecuencias
%   y la frecuencia fundamental de la se�al; el n�mero de arm�nicos con el
%   que se desea trabajar y el valor de TDH al que se desea llegar
% Devuelve el valor del factor de atenuaci�n

function factor_atenuador= atenuarTHD(absFFT,freq,frec_fund,num_arm,THD_Objetivo)

arm_ind = zeros(1,num_arm);
arm_sumat = 0;

for i=1:num_arm
    arm_ind(i) = find(freq==frec_fund*(i+1));         % almacena �ndices de los arm�nicos
    arm_sumat = arm_sumat+(absFFT(arm_ind(i)))^2;     % suma los modulos al cuadrado de los arm�nicos
    
end

% Este factor se multiplica por los arm�nicos de nuestra se�al para atenuar su distorsi�n
% Se obtiene despej�ndolo de la f�rmula de THD AC�AA DUDAAAAA AAAHHHH el
% factor atenuador va al cuadrado (????
factor_atenuador = (THD_Objetivo * absFFT(find(freq==frec_fund)))^2 /(arm_sumat*(100)^2);        

end