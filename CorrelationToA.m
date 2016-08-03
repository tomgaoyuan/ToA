%cleaning
clear all;
close all;
%starting
K_s = 20;
s = zeros(1,K_s); %This is the new series
s(1) = 1;
tau=[5 8];
K_r = K_s + max(tau);
K_A = K_r + K_s - 1;
ts = [ s zeros(1,K_A - K_s)];
sigma = sqrt(1/20/10^1.5);
DROPTIMES = 5000;
R_A = zeros(1,K_A);
for drop = 1: DROPTIMES
  lambda = (rand(1,length(tau))-0.5)*2;
  r = zeros(1,K_r);
  for i = 1:length(tau)
    r(tau(i)+[1:K_s])=r(tau(i)+[1:K_s]) + lambda(i) * s;
  end
  tr = [ r zeros(1,K_A - K_r)];
  w = sigma * randn(1,K_A);
  tr = tr + w;
  for i = 1:K_A 
 %   R_A(i) = sum(ts(1:K_A-i+1).*tr(i:K_A)) + sum(ts(K_A-i+2:K_A).*tr(1:i-1));
    R_A(i)= R_A(i) +sum(ts(mod([0:K_A-1]-(i-1),K_A)+1).*tr);
  end
end
R_A = R_A/ DROPTIMES;
figure;
stem([0:K_A-1],abs(R_A).^2);
