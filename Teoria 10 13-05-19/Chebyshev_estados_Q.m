%C?tedra: Sistemas de Adquisici?n y Procesamiento
%Bioingenier?a - FIUNER
%JM Reta
    
clear all;
close all;
clc;
N=1000;
%WMAX = 2*pi*1;
%W = (2:N-1) * WMAX/N;
W = logspace(-1,1,N);
n = 10;
[z,p,k]=cheb1ap(n,3);
[Num_cheby1,Den_cheby1] = zp2tf(z,p,k);

%%%% W es el vector de frecuencias
H_cheby1 = freqs(Num_cheby1,Den_cheby1,W);

Mag_H_cheby1 = 20*log(abs(H_cheby1).^2);


% Armado de los estados de un filtro de orden par. Se arman secciones de
% orden 2 para analizar su factor de calidad - Q=sqrt(bi)/ai.

for i=1:n/2
    %%% Junta los polos conjugados
    polos = [p(i) p(n+1-i)];
    [num,den] = zp2tf(z,polos,k);
    H_2do = freqs(num,den,W);
    mag = abs(H_2do).^2;
    
    % Se hace la normalizacion
    mag = mag ./ mag(1);
    %Mag_H(:,i) = abs(H_2do).^2;
    
    % Va generando vectores de magnitudes para secciones de orden 2
    Mag_H(:,i) = 20*log(mag);
end

figure; 
%hold on;
%loglog(W,Mag_H,W,Mag_H_cheby1);
semilogx(W,Mag_H,W,Mag_H_cheby1,'LineWidth',2);
legend('Sección 5','Sección 4','Sección 3','Sección 2','Sección 1','Chebyshev');
title('Secciones de un Chebyshev Pasabajos - Orden 10');
ylabel(['|H(w)|^2 [dB]']);
xlabel(['Frecuencia (rad/s)']);
grid on;
axis([ .1 10 -150 150])

%loglog(W,Mag_H_cheby1, 'k');
%hold off;

%figure;
%loglog(W,Mag_H_cheby1);