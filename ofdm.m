clc ; clear all ;close all ;
% Nombre d'�tats de la QAM.
M = 16;
% Nombre de porteuses dans le symbole OFDM
Nb = 64;
%Nombre de symboles OFDM dans la simulation
NbSym = 10;
% Tirage al�atoire d'entiers allant de 0 � M-1
R = randint(Nb*NbSym,1,M);

% Mise en constellation QAM.
X = qammod(R,M);
I=real(X)
Q=imag(X)
X = I+j*Q; scatterplot(X);

 figure
% Cr�ation signal OFDM
x = zeros(size(X));
for i = 1:NbSym
% calcul i�me symbole OFDM
symbole=ifft(X((i-1)*Nb+1:i*Nb));
% sauvegarde du symbole i dans x
x((i-1)*Nb+1:i*Nb) = symbole;
end
subplot(2,1,1); plot(real(x))
title('partie r�elle de x')
subplot(2,1,2); plot(imag(x))
title('partie imaginaire de x')
%partie2
% ajout de bruit complexe
x = x + 0.01*(randn(size(x)) + j*randn(size(x)));
for i = 1:NbSym
% d�codage du symbole i
y=fft(x((i-1)*Nb+1:i*Nb));
% sauvegarde du i�me symbole d�cod�
Xdec((i-1)*Nb+1:i*Nb) = y;
end
scatterplot(Xdec)
% d�codage des symboles d�cod�s
I1=real(Xdec)
Q1=imag(Xdec)
Rdec=qamdemod(Xdec ,M);
figure(7); hold on;
plot(Rdec,R,'r+');hold off


%partie3

% Cr�ation signal OFDM (suite du Transparent 21). Pour voir le spectre compris
%entre �Fech/2 et +Fech/2,
% on utilise une IFFT 512 pts en mettant 32 valeurs en bas et
% 32 valeurs en haut de la IFFT, les 448 valeurs au centre valant 0.
% Cela permet de r�aliser un sur-�chantillonnage d'un facteur 8.
% On consid�re que Fech = 8.
x = zeros(NbSym*512,1);
for i = 1:NbSym
% calcul i�me symbole OFDM
symbole=ifft([X((i-1)*Nb+1:(i-1)*Nb+Nb/2);
zeros(512 - Nb, 1);
X((i-1)*Nb+Nb/2+1:i*Nb)], 512);
% sauvegarde du symbole i dans x
x((i-1)*512+1:i*512) = symbole;
end
% cr�ation d'un vecteur temps de m�me taille que x
% avec une p�riode d'�chantillonnage 1/Fech.
SS = size(x);
t=(1:SS(1))/8;
% La fr�quence porteuse passe de 0 � 2 Hz
f0 = 2;
% calcul du vecteur contenant la porteuse.
porteuse = exp(j*2*pi*f0*t).';
% changement de fr�quence.
x_mod = real(x.*porteuse);
% Affichage du spectre.
f=linspace(0,8,SS(1));
figure(9)
plot(f,20*log10(abs(fft(x_mod))+0.01))