function [vector_alarma] = Alarma(vector_activos,frec_muestreo)

%%%% Moduladora
FM = 2;      % Frecuencia de la señal modulante
N = length(vector_activos);
% Vector de tiempo en segundos
t = 0:1/frec_muestreo:((N-1)/frec_muestreo); 

A = 0.5;
%Seniales moduladoras
Moduladora = cos(2*pi*FM*t); 
Moduladora = A*(1 + Moduladora);

%%%% Portadora
FP = 3465;
FP2 = 500;
Portadora1 = A*cos(2*pi*FP*t);

Portadora = Portadora1;

vector_alarma = zeros(length(vector_activos),1);

%%%% Senial en conjunto
Senial = Portadora.*Moduladora;
Senial = Senial';
modo_alarma = false;
frame_retardo = 0.080*frec_muestreo; %Histeresis de la alarma

for i = 1:N
    if(modo_alarma == false)
        if(vector_activos(i) > 0)
            vector_alarma(i+frame_retardo) = 1;
            modo_alarma = true;
        end
    else
        vector_alarma(i) = 1;
        if(vector_activos(i) < 0)
            vector_alarma(i:i+frame_retardo-1) = 1;
            vector_alarma(i+frame_retardo) = 0;
            modo_alarma = false;
        end
    end
end
vector_alarma = vector_alarma .* Senial;

        

