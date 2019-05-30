%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sistemas de Adquisici�n y Procesamiento de Se�ales
% Sistemas de Procesamiento Anal�gico
% 
% Ejemplo de Dise�o de Filtro Pasa-Bajos:
% - Aproximaci�n: Chebyshev
% - Ripple: 2dB
% - Frecuencia de fin de banda de Ripple: 5kHz
% - Atenuaci�n: 50dB en 20kHz
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

% frecuencia donde tenemos nuestro requisito de atenuaci�n
wat1 = 2*pi*20000; 

% atenuaci�n en dB
At1 = -50; 

%% Normalizaci�n
% Aplicamos la transformaci�n Pasa Bajos -> Pasa Bajos (w -> w/wo) sobre
% las frecuencias en las cuales tenemos nuestros requisitos de atenuaci�n
% para poder evaluarlas sobre el filtro pasabajos Normalizado.

% frecuencia normalizada
wat1_n = wat1/wo; 

%% C�lculo del Orden 
% Sobre la respuesta en magnitud del filtro Chebyshev normalizado de 1dB de
% ripple y orden n, evaluamos la atenuaci�n obtenida a la frecuencia wat1_n 
% para determinar el orden m�nimo que cumple con este requisito.

% inicializo una variable donde se almacenar� la atenuaci�n evaluada en 
% distintos ordenes
At = 0; 

% orden del filtro, inicializado en 0 (de esta manera dentro de ciclo 
% while se comienza evaluando desde orden 1)
n= 0; 

% genero un vector de frecuencias para la graficaci�n
w = linspace(0.1,10,1000); 

figure(1)

% repito el ciclo aumentando el orden hasta que se cumpla con el requisito 
% de atenuaci�n 

while (At > At1) 
    % pruebo con el orden siguiente
    n = n+1; 
    
    % obtengo polos, ceros y ganancia del filtro pasa bajos normalizado de 
    % orden n
    [z_n,p_n,k_n]=cheb1ap(n,Rp); 
    
    % obtengo numerador y denominador de la funcion de transferencia del 
    % filtro normalizado de orden n
    [num_n,den_n]=zp2tf(z_n,p_n,k_n); 
    
    % calculamos la atenuaci�n del filtro normalizado de orden n en wat1_n 
    % (calculamos tb en 0 porque para que funcione correcamente freqs 
    % requiere dos frecuencias)
    %(esto tambi�n se podr�a hacer utilizando la ecuaci�n de la respuesta 
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
% graficamos tb el requisito de atenuaci�n a cumplir
semilogx(wat1_n,At1,'*');
title('Filtro Pasabajo Chebyshev Normalizado');
ylabel('|H(w)|^2 [dB]');
xlabel('Frecuencia (rad/s)');
legend('Chebyshev Orden 1','Chebyshev Orden 2','Chebyshev Orden 3','Chebyshev Orden 4','Requisito de Atenuaci�n','Location','southwest');
grid on
hold off

%% Desnormalizaci�n
% En num_n y den_n tenemos los coeficientes de la funi�n de transferencia
% normalizada del orden seleccionado. Ahora debemos aplicar la
% transformaci�n Pasa Bajos -> Pasa Bajos (s -> s/wo) para desnormalizarla.

% Funci�n de transferencia del filtro de orden 4 NORMALIZADO
s = tf('s');
H_n = num_n / (den_n(1)*s^4 + den_n(2)*s^3 + den_n(3)*s^2 + den_n(4)*s + den_n(5));

% Realizamos cambio de variable (s -> s/wo)
s_dn = s/wo;

% Funci�n de transferencia del filtro de orden 4 DENORMALIZADO
H_dn = num_n(5) / (den_n(1)*s_dn^4 + den_n(2)*s_dn^3 + den_n(3)*s_dn^2 + den_n(4)*s_dn + den_n(5));
H_dn = minreal(H_dn);
disp('La funci�n de transferencia del filtro dise�ado es:');
H_dn
disp('******************************************************************');

% Obtenemos ceros y ganancia de la funci�n de transferencia
[z_dn, k_dn] = zero(H_dn);

% Obtenemos polos de la funci�n de transferencia
p_dn = pole(H_dn);

% Obtenemos numerador y denominador
[num_dn,den_dn] = zp2tf(z_dn,p_dn,k_dn);

% Graficamos la respuesta en magnitud del filtro dise�ado
w2 = linspace(1,1e6,1e4); 
figure(2)
mag_dn = 20 * log10 (abs(freqs(num_dn,den_dn,w2))); 
semilogx(w2,mag_dn);
title('Filtro Dise�ado');
ylabel('|H(w)|^2 [dB]');
xlabel('Frecuencia (rad/s)');
xlim([10 1e6]);
grid on
hold on
semilogx(wat1,At1,'*');
legend('Chebyshev Orden 4','Requisito de Atenuaci�n','Location','southwest');
hold off

% Calculamos anal�ticamente la atenuaci�n de nuestro filtro en 20kHz para
% verificar el cumplimiento de los requisitos
atenuacion = 20 * log10 (abs(freqs(num_dn,den_dn, [0 wat1])));
disp(['La atenuaci�n del filtro dise�ado en 20kHz es de ', num2str(atenuacion(2)), 'dB']);
disp('******************************************************************');

%% Factorizaci�n en secciones de orden 2
% Con el objetivo de poder implementarlo usando celdas de Sallen Key 
% separamos la funci�n de transferencia en dos funciones de orden 2

% Separamos los polos en pares 
p_pb1 = [p_dn(1) p_dn(2)];
p_pb2 = [p_dn(3) p_dn(4)];

% Separamos los ceros (como es un pasabajos la variable z_dn est� vac�a)
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
legend('Chebyshev Orden 4','Secci�n 1','Secci�n 2','Location','southwest');
title('Secciones del Filtro Dise�ado');
ylabel('|H(w)|^2 [dB]');
xlabel('Frecuencia (rad/s)');
xlim([10 1e6]);
grid on

%% C�lculo de compnentes Pasa Bajos 1
% Siguiendo el "Mini Tutorial Sallen-Key"

%Proponemos C1 y R3

C1_1 = 0.1e-6; % 1uF

w0_1 = sqrt(den_pb1(3)); % El termino independiente es w0^2
alpha_1 = den_pb1(2)/w0_1; % El termino que acompa�a a s es alpha*w0
H_1 = num_pb1(3)/den_pb1(3); % Numerador = H * w0^2

k_1 = w0_1*C1_1; 
m_1 = alpha_1^2/4 + (H_1-1);

% Con Sallen-Key no se pueden implementar filtros con ganancia menor que 1,
% por lo tanto si H es menor o igual a uno implementamos un seguidor de
% tensi�n (R3 = cable, R4 = no se coloca)
if (H_1 <= 1) 
    R3_1 = 0;
    R4_1 = 1e9; 
else
    % Proponemos R3
    R3_1 = 1e3; % 1K
    R4_1 = R3_1/(H_1-1);
end
C2_1 = m_1*C1_1;
R1_1 = 2/(alpha_1*k_1);
R2_1 = alpha_1/(2*m_1*k_1);

disp('Los componentes calculados para la secci�n 1 son:');
disp(['R1: ', num2str(R1_1), ' ohm']);
disp(['R2: ', num2str(R2_1), ' ohm']);
disp(['R3: ', num2str(R3_1), ' ohm']);
disp(['R4: ', num2str(R4_1), ' ohm']);
disp(['C1: ', num2str(C1_1), ' F']);
disp(['C2: ', num2str(C2_1), ' F']);
disp('******************************************************************');

% Aproximamos a valores comerciales
C1_1a = 100e-9;
C2_1a = 1e-9;
R1_1a = 3300;
R2_1a = 3300;

% Recalculamos funci�n de transferencia y respuesta en magnitud
H_pb1a = (H_1/(R1_1a*R2_1a*C1_1a*C2_1a))/(s^2+s*((1/R1_1a+1/R2_1a)/C1_1a+(1-H_1)/(R2_1a*C2_1a))+1/(R1_1a*R2_1a*C1_1a*C2_1a));
[z_pb1a, k_pb1a] = zero(H_pb1a);
p_pb1a = pole(H_pb1a);
[num_pb1a,den_pb1a] = zp2tf(z_pb1a, p_pb1a, k_pb1a);
mag_pb1a = 20 * log10 (abs(freqs(num_pb1a,den_pb1a,w2))); 

%% C�lculo de compnentes Pasa Bajos 2
% Siguiendo el "Mini Tutorial Sallen-Key"

%Proponemos C1
C1_2 = 0.1e-6; % 1uF

w0_2 = sqrt(den_pb2(3)); % El termino independiente es w0^2
alpha_2 = den_pb2(2)/w0_2; % El termino que acompa�a a s es alpha*w0
H_2 = num_pb2(3)/den_pb2(3); % Numerador = H * w0^2

k_2 = w0_2*C1_2; 
m_2 = alpha_2^2/4 + (H_2-1);

% Con Sallen-Key no se pueden implementar filtros con ganancia menor que 1,
% por lo tanto si H es menor o igual a uno implementamos un seguidor de
% tensi�n (R3 = cable, R4 = no se coloca)
if (H_2 <= 1) 
    R3_2 = 0;
    R4_2 = 1e9; 
    H_2 = 1;
else
    % Proponemos R3
    R3_2 = 1e3; % 1K
    R4_2 = R3_2/(H_2-1);
end
C2_2 = m_2*C1_2;
R1_2 = 2/(alpha_2*k_2);
R2_2 = alpha_2/(2*m_2*k_2);

disp('Los componentes calculados para la secci�n 2 son:');
disp(['R1: ', num2str(R1_2), ' ohm']);
disp(['R2: ', num2str(R2_2), ' ohm']);
disp(['R3: ', num2str(R3_2), ' ohm']);
disp(['R4: ', num2str(R4_2), ' ohm']);
disp(['C1: ', num2str(C1_2), ' F']);
disp(['C2: ', num2str(C2_2), ' F']);
disp('******************************************************************');

% Aproximamos a valores comerciales
C1_2a = 100e-9;
C2_2a = 10e-9;
R1_2a = 1200;
R2_2a = 4700;

% Recalculamos funci�n de transferencia y respuesta en magnitud
H_pb2a = (H_2/(R1_2a*R2_2a*C1_2a*C2_2a))/(s^2+s*((1/R1_2a+1/R2_2a)/C1_2a+(1-H_2)/(R2_2a*C2_2a))+1/(R1_2a*R2_2a*C1_2a*C2_2a));
[z_pb2a, k_pb2a] = zero(H_pb2a);
p_pb2a = pole(H_pb2a);
[num_pb2a,den_pb2a] = zp2tf(z_pb2a, p_pb2a, k_pb2a);
mag_pb2a = 20 * log10 (abs(freqs(num_pb2a, den_pb2a, w2)));

%% Simulaci�n
% El comportamiento de los filtros se simulan utilizando el software 
% LTSpice.
% Los resultados de la simulaci�n pueden ser importados a MATLAB utilizando
% las funciones "import_ac_LTSpice.m" e "import_tran_LTSpice.m" que se 
% encuentran en el campus.

[freq_pb1,dB_pb1,deg_pb1] = import_ac_LTSpice('seccion_1.txt');
[freq_pb2,dB_pb2,deg_pb2] = import_ac_LTSpice('seccion_2.txt');
[freq_cheby,dB_cheby,deg_cheby] = import_ac_LTSpice('cheby_orden4.txt');

figure(4)
semilogx(w2,mag_pb1,w2,mag_pb1a,2*pi*freq_pb1,dB_pb1);
legend('Ideal','Componentes Comerciales','Simulado','Location','southwest');
title('Seccion 1 Ideal vs Comp Comerciales vs Simulado');
ylabel('|H(w)|^2 [dB]');
xlabel('Frecuencia (rad/s)');
xlim([10 1e6]);
grid on

figure(5)
semilogx(w2,mag_pb2,w2,mag_pb2a,2*pi*freq_pb2,dB_pb2);
legend('Ideal','Componentes Comerciales','Simulado','Location','southwest');
title('Seccion 2 Ideal vs Simulado');
ylabel('|H(w)|^2 [dB]');
xlabel('Frecuencia (rad/s)');
xlim([10 1e6]);
grid on

figure(6)
semilogx(w2,mag_dn,2*pi*freq_cheby,dB_cheby);
legend('Ideal','Simulado','Location','southwest');
title('Filtro Chebyshev Ideal vs Simulado');
ylabel('|H(w)|^2 [dB]');
xlabel('Frecuencia (rad/s)');
xlim([10 1e6]);
grid on

%% Digitalizaci�n
% Suponiendo que ahora se pretende evaluar la posibilidad de implementar
% este filtro de manera digital, se comparan los resultados de la
% digitalizaci�n utilizando las transformaciones "invariante al impulso" y
% "bilineal"

% Se propone frecuencia de muestreo de 50kHz
fs = 50e3; 

% Realizamos la digitalizaci�n usando ambas transformaciones
[numd_bil, dend_bil] = bilinear(num_dn, den_dn, fs);
[numd_inv, dend_inv] = impinvar(num_dn, den_dn, fs);

% Observamos las funciones de tranferencias obtenidas
Hz_bil = tf(numd_bil, dend_bil, 1/fs);
Hz_inv = tf(numd_inv, dend_inv, 1/fs);
disp('La funci�n de transferencia del filtro digitalizado mediante Bilineal es:');
Hz_bil
disp('******************************************************************');
disp('La funci�n de transferencia del filtro digitalizado mediante Invariante al Impulso es:');
Hz_inv
disp('******************************************************************');

% Calculamos la atenuaci�n en los puntos de inter�s (n�tese que para el 
% caso de filtros digitales utilizamos freqz en lugar de freqs)
atenuacion_bil = 20*log10(abs(freqz(numd_bil, dend_bil, [5e3 20e3], fs)));
atenuacion_inv = 20*log10(abs(freqz(numd_inv, dend_inv, [5e3 20e3], fs)));

disp(['La atenuaci�n del filtro digitalizado por bilineal en 5kHz es de ',...
    num2str(atenuacion_bil(1)), 'dB']);
disp(['La atenuaci�n del filtro digitalizado por bilineal en 20kHz es de ',...
    num2str(atenuacion_bil(2)), 'dB']);
disp(['La atenuaci�n del filtro digitalizado por invariante al impulso en 5kHz es de ',...
    num2str(atenuacion_inv(1)), 'dB']);
disp(['La atenuaci�n del filtro digitalizado por invariante al impulso en 20kHz es de ',...
    num2str(atenuacion_inv(2)), 'dB']);
disp('******************************************************************');

% Calculamos la respuesta en magnitud 
f = linspace(1, fs/2, 1e4);
mag_bil = 20*log10(abs(freqz(numd_bil, dend_bil, f, fs)));
mag_inv = 20*log10(abs(freqz(numd_inv, dend_inv, f, fs)));

figure(7)
semilogx(2*pi*f, mag_bil, 2*pi*f, mag_inv);
hold on
semilogx(w2, mag_dn);
hold off
legend('Bilineal','Invariante al Impulso','Anal�gica','Location','southwest');
title('Anal�gica vs Bilineal vs Invariante al Impulso');
ylabel('|H(w)|^2 [dB]');
xlabel('Frecuencia (rad/s)');
xlim([1e3 2*pi*fs/2]);
ylim([-200 10]);
grid on
