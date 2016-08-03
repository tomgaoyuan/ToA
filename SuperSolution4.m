%sin wave with hamming window
%cleaning
close all;
clear all;
%%
%s_a(t) = sin(2*pi*t) + sin(2*pi*4*t) T=1 F=1
%Original s
T_s=1/20;
%s_2 10 times overSample
T_s_2 = T_s / 10;
n_2 = [0:2/(T_s_2)-1];
s_2 = sin(2*pi*T_s_2*n_2);
s_2 = s_2 .* hamming(length(s_2)).';
s = s_2(1:10:end);
tau = [ 9 9.5];
sigma = sqrt(1/2/10^6);
%sigma = 0;
DROPTIMES = 1000;
K_A = 1024;
s_ext = [ s zeros(1,K_A - length(s))];
S = fft(s_ext);
R_x_A = zeros(K_A,K_A);
for drop =1:DROPTIMES 
  lambda = (rand(1,length(tau))-0.5)*2;
  r_tmp = zeros(1,ceil(max(tau*10))+length(s_2));
  for i = 1:2
    r_tmp(tau(i)*10+[1:length(s_2)])=r_tmp(tau(i)*10+[1:length(s_2)]) + lambda(i) * s_2;
  end
  r_tmp = r_tmp(1:10:end);
  r_ext = [ r_tmp zeros(1,K_A - length(r_tmp))];
  %add noise
  w = sigma * randn(1,K_A);
  r_ext = r_ext + w;
  R_A = zeros(1,K_A);
  for i = 1:K_A 
    R_A(i)=sum(s_ext(mod([0:K_A-1]-(i-1),K_A)+1).*r_ext);
  end
  x_A = K_A * ifft(R_A);
  R_x_A = R_x_A +  (x_A.') * (x_A.')';
end
R_x_A = R_x_A / DROPTIMES;
SS = abs(S).^2;
RANGE0 = find(SS(1:K_A/2)>10);
RANGE = RANGE0;
R_x_A_prt = R_x_A(RANGE,RANGE);
[V LAMBDA] = eig(R_x_A_prt);
tmp = diag(LAMBDA);
[Y I] = max(tmp);
tmp(I) = NaN;
[Y I] = max(tmp);
tmp(I) = NaN;
G_A = V(:,find(~isnan(tmp)));
SS = abs(S(RANGE)).^2;
%%
TAU = linspace(0,15,5000);
P = zeros(1,length(TAU));
for i = 1:length(TAU)
  %tmp = [ exp( 1i * (RANGE0-1)/K_A *2 * pi * TAU(i)) exp(1i * (RANGE1-1-K_A)/K_A * 2 * pi* TAU(i))];
  tmp = exp( 1i * (RANGE0-1)/K_A *2 * pi * TAU(i));
  LAMBDA_A = diag(tmp);
  P(i) = 1/sqrt( sum(abs( SS * (LAMBDA_A') *G_A ).^2)); 
  %P(i) = 1/real( SS * (LAMBDA_A') * ( G_A * G_A') * LAMBDA_A * (SS.'))
end
plot(TAU,P);
figure;
plot(TAU,10*log10(P))
