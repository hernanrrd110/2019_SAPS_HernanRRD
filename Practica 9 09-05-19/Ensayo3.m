clear all; close all; clc;
 % Hacemo chevy;
numero_bits  = 10;


RD = 6.02*numero_bits + 1,76 ; % en DB


Rp = 3; % en Decibeles

% te da ceros, polos y ganancia;
n = 4;
[z,p,k] = cheb1ap(n,Rp);

w1 = 1000;
w2 = 3000;
B = w2-w1;

w0 = sqrt(w1*w2);
[Num,Den] = zp2tf(z,p,k);

s = tf('s');
s = (s^2+w0^2)/(B*s);

D_desn=0;
N_desn=0;


for i=1:length(Den)
 D_desn=D_desn+Den(i)*(s^(n+1-i));
end


for i=1:length(Num)
 N_desn=N_desn+Num(i)*(s^(n+1-i));
end

Hs_desn=minreal(N_desn/D_desn)


figure;

bode(Num,Den);

[P_desn,Z_desn]= pzmap(Hs_desn);
pzmap(Hs_desn)
P1=poly(P_desn(3:4))
P2=poly(P_desn(5:6))
P_total = poly(P_desn(3:6));

L_Pass1=tf(P1(3),P1)
L_Pass2=tf(P2(3),P2)
L_Passtotal=tf(P_total(5),P_total);


figure;
bode(L_Pass1)
hold on;

bode(Hs_desn.Numerator{1},Hs_desn.Denominator{1});
hold on;

bode(L_Pass2)
hold on;

bode(L_Passtotal)
