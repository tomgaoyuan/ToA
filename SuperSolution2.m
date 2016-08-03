%The algorithm is not able to distinguish path delayed shouter than sample time 
%cleaning
clear all;
close all;
%Setting
K_s = 20;
pha_0 = 0;
f_1 = 0.30;
f_2 = 0.33;
alp = 2*pi*f_1;
bet = pi*(f_2-f_1)/K_s;
Os = 10;
n = 0:K_s-1;
s = sin( (alp+bet*n).*n +pha_0);
K_s_Os = K_s * Os;
n_Os=( 0:K_s_Os-1)/Os;
s_Os = sin( (alp+bet*n_Os).*n_Os +pha_0);
tau=[5 5.5];
K_r = K_s + ceil(max(tau));
K_A = K_r + K_s - 1;
ts = [ s zeros(1,K_A - K_s)];
%sigma = sqrt(1/2/10^1.5);
sigma = 0;
DROPTIMES = 500;
%Monte Calro Drop
R_x_A = zeros(K_A,K_A);
for drop = 1: DROPTIMES
  %lambda = (rand(1,length(tau))-0.5)*2;
  lambda = [1 1];
  r_Os = zeros(1,length(s_Os) + max(tau*Os));
  for i = 2:length(tau)
    r_Os(tau(i)*Os+[1:K_s_Os])=r_Os(tau(i)*Os+[1:K_s_Os]) + lambda(i) * s_Os;
  end
  r = r_Os(1:10:end);
  R_A = zeros(1,K_A);
  tr = [ r zeros(1,K_A - K_r)];
  w = sigma * randn(1,K_A);
  tr = tr + w;
  for i = 1:K_A 
 %   R_A(i) = sum(ts(1:K_A-i+1).*tr(i:K_A)) + sum(ts(K_A-i+2:K_A).*tr(1:i-1));
    R_A(i)=sum(ts(mod([0:K_A-1]-(i-1),K_A)+1).*tr);
  end
  x_A = K_A * ifft(R_A);
  R_x_A = R_x_A +  (x_A.') * (x_A.')';
end
R_x_A = R_x_A / DROPTIMES;
%
[V LAMBDA] = eig(R_x_A);
tmp = diag(LAMBDA);
[Y I] = max(tmp);
tmp(I) = NaN;
[Y I] = max(tmp);
tmp(I) = NaN;
G_A = V(:,find(~isnan(tmp)));
S = abs(fft(ts)).^2;

TAU = linspace(0,K_A-1,5000);
%TAU = 0:K_A-1;
P = zeros(1,length(TAU));
for i = 1:length(TAU)
  LAMBDA_A = diag(exp( 1i * [0:K_A-1]/K_A *2 * pi * TAU(i) ));
  P(i) = 1/real( S * (LAMBDA_A') * ( G_A * G_A') * LAMBDA_A * (S.')); 
end
%stem(TAU,P);
plot(TAU,P);
hold on;
ax = axis;
line([tau(1) tau(1)], [ax(3) ax(4)],'color','black');
line([tau(2) tau(2)], [ax(3) ax(4)],'color','black');
hold off;
