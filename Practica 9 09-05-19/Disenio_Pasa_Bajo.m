%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sistemas de Adquisición y Procesamiento de Señales
% Sistemas de Procesamiento Analógico
% 
% Ejemplo de Diseño de Filtro Pasa-Bajos:
% - Aproximación: Chebyshev
% - Ripple: 2dB
% - Frecuencia de Corte: 5kHz
% - Atenuación: 50dB en 20kHz
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all
clc

%% Requisitos
% Ripple
Rp = 2;

% frecuencia de corte
wo = 2*pi*5000; 

% frecuencia donde tenemos nuestro requisito de atenuación
wat1 = 2*pi*20000; 

% atenuación en dB
At1 = -50; 

%% Normalización
% Aplicamos la transformación Pasa Bajos -> Pasa Bajos (w -> w/wo) sobre
% las frecuencias en las cuales tenemos nuestros requisitos de atenuación
% para poder evaluarlas sobre el filtro pasabajos Normalizado.

% frecuencia normalizada
wat1_n = wat1/wo; 

%% Cálculo del Orden 
% Sobre la respuesta en magnitud del filtro Chebyshev normalizado de 1dB de
% ripple y orden n, evaluamos la atenuación obtenida a la frecuencia wat1_n 
% para determinar el orden mínimo que cumple con este requisito.

% inicializo una variable donde se almacenará la atenuación evaluada en 
% distintos ordenes
At = 0; 

% orden del filtro, inicializado en 0 (de esta manera dentro de ciclo 
% while se comienza evaluando desde orden 1)
n= 0; 

% genero un vector de frecuencias para la graficación
w = linspace(0.1,10,1000); 

figure(1)

% repito el ciclo aumentando el orden hasta que se cumpla con el requisito 
% de atenuación 
while (At > At1) 
    % pruebo con el orden siguiente
    n = n+1; 
    
    % obtengo polos, ceros y ganancia del filtro pasa bajos normalizado de 
    % orden n
    [z_n,p_n,k_n]=cheb1ap(n,Rp); 
    
    % obtengo numerador y denominador de la funcion de transferencia del 
    % filtro normalizado de orden n
    [num_n,den_n]=zp2tf(z_n,p_n,k_n); 
    
    % calculamos la atenuación del filtro normalizado de orden n en wat1_n 
    % (calculamos tb en 0 porque para que funcione correcamente freqs 
    % requiere dos frecuencias)
    %(esto también se podría hacer utilizando la ecuación de la respuesta 
    % en magnitud de Chebyshev)
    h = 20*log10(abs(freqs(num_n,den_n,[0 wat1_n])));
    At = h(2); 
    
    % Con fines demostrativos, graficamos la respuesta de los filtros de 
    % distinto orden
    
    % respuesta en magnitud del filtro de orden n
    mag_n = 20 * log10 (abs(freqs(num_n,den_n,w))); 
    semilogx(w,mag_n);
    hold on
end
% graficamos tb el requisito de atenuación a cumplir
semilogx(wat1_n,At1,'*');
title('Filtro Pasabajo Chebyshev Normalizado');
ylabel('|H(w)|^2 [dB]');
xlabel('Frecuencia (rad/s)');
legend('Chebyshev Orden 1','Chebyshev Orden 2','Chebyshev Orden 3','Chebyshev Orden 4','Requisito de Atenuación','Location','southwest');
grid on
hold off

%% Desnormalización
% En num_n y den_n tenemos los coeficientes de la funión de transferencia
% normalizada del orden seleccionado. Ahora debemos aplicar la
% transformación Pasa Bajos -> Pasa Bajos (s -> s/wo) para desnormalizarla.

% Función de transferencia del filtro de orden 4 NORMALIZADO
s = tf('s');
H_n = num_n / (den_n(1)*s^4 + den_n(2)*s^3 + den_n(3)*s^2 + den_n(4)*s + den_n(5));

% Realizamos cambio de variable (s -> s/wo)
s_dn = s/wo;

% Función de transferencia del filtro de orden 4 DENORMALIZADO
H_dn = num_n(5) / (den_n(1)*s_dn^4 + den_n(2)*s_dn^3 + den_n(3)*s_dn^2 + den_n(4)*s_dn + den_n(5));
H_dn = minreal(H_dn);
disp('La función de transferencia del filtro diseñado es:');
H_dn

% Obtenemos ceros y ganancia de la función de transferencia
[z_dn, k_dn] = zero(H_dn);

% Obtenemos polos de la función de transferencia
p_dn = pole(H_dn);

% Obtenemos numerador y denominador
[num_dn,den_dn] = zp2tf(z_dn,p_dn,k_dn);

% Graficamos la respuesta en magnitud del filtro diseñado
w2 = linspace(1,1e6,1e4); 
figure(2)
mag_dn = 20 * log10 (abs(freqs(num_dn,den_dn,w2))); 
semilogx(w2,mag_dn);
title('Filtro Diseñado');
ylabel('|H(w)|^2 [dB]');
xlabel('Frecuencia (rad/s)');
grid on
hold on
semilogx(wat1,At1,'*');
legend('Chebyshev Orden 4','Requisito de Atenuación','Location','southwest');
hold off

% Calculamos analíticamente la atenuación de nuestro filtro en 20kHz para
% verificar el cumplimiento de los requisitos
atenuacion = 20 * log10 (abs(freqs(num_dn,den_dn, [0 wat1])));
disp(['La atenuación del filtro diseñado en 20kHz es de ', num2str(atenuacion(2)), 'dB']);

%% Factorización en secciones de orden 2
% Con el objetivo de poder implementarlo usando celdas de Sallen Key 
% separamos la función de transferencia en dos funciones de orden 2

% Separamos los polos en pares 
p_pb1 = [p_dn(1) p_dn(2)];
p_pb2 = [p_dn(3) p_dn(4)];

% Separamos los ceros (como es un pasabajos la variable z_dn está vacía)
z_pb1 = z_dn;
z_pb2 = z_dn;

% Separamos la ganancia con el criterio de que el Pasa Bajos 1 tenga
% ganancia unitaria 
k_pb1 = (abs(p_dn(1)))^2;
k_pb2 = k_dn / k_pb1;

% Obtenemos numerador y denominador de ambos filtros.
[num_pb1,den_pb1] = zp2tf(z_pb1, p_pb1, k_pb1);
[num_pb2,den_pb2] = zp2tf(z_pb2, p_pb2, k_pb2);

% Graficamos la respuesta en magnitud del filtro de orden 4 junto con la de
% ambas secciones de orden 2
w2 = linspace(1,1e6,1e4); 
figure(3)
mag_pb1 = 20 * log10 (abs(freqs(num_pb1,den_pb1,w2))); 
mag_pb2 = 20 * log10 (abs(freqs(num_pb2,den_pb2,w2))); 
semilogx(w2,mag_dn,w2,mag_pb1,w2,mag_pb2);
legend('Chebyshev Orden 4','Sección 1','Sección 2','Location','southwest');
title('Secciones del Filtro Diseñado');
ylabel('|H(w)|^2 [dB]');
xlabel('Frecuencia (rad/s)');
grid on
