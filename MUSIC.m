%a classic MUSIC demo
%cleaning
close all;
clear all;
%starting
M = 6; %receiver number
D = 3; %source  number
OMEGA = [ 0 45 180 ] / 180 *pi;
LOOP = 1000;
for c = 1: D
  A(:,c) = exp(-j* OMEGA(c) * [0:(M-1)]).';
end
SIGMA_S = 10;
SIGMA_E = 1;
Rx = zeros(M,M);
for c = 1:LOOP
  rav = randn(2*D+2*M,1);
  s = SIGMA_S * ( rav(1:D) + j * rav(D+1:2*D) ) / sqrt(2);
  e = SIGMA_E * ( rav(2*D+1:2*D+M) + j * rav(2*D+M+1:2*D+2*M) ) / sqrt(2);
  x = A * s + e;
  Rx = Rx + x*x';
end
Rx = Rx / LOOP; 
%decomposing
[ V LAMBDA ] = eig(Rx);
%sorting 
for c1 = 2:size(LAMBDA,1)
  key = LAMBDA(c1,c1);
  keyV = V(:,c1);
  for c2 = 1: c1-1
    if key > LAMBDA(c2,c2)
        break;
    end
  end
  for c3 = c1:-1:c2+1   
    LAMBDA(c3,c3) = LAMBDA(c3-1,c3-1);
    V(:,c3) = V(:,c3-1);
  end
  LAMBDA(c2,c2) = key;
  V(:,c2) = keyV;
end
%estimating D by var
threshold = 1;
D_E = 0;    %estimation
for c = 1:M
  t = LAMBDA(c:end,c:end);
  t = diag(t);
  if var(t) < threshold 
    D_E = c-1;
    break;
  end 
end
%obtaining noise space G
G = V(:,D_E+1:end );
%searching
omega = linspace(0,2*pi,500);
P = zeros(1,length(omega));
for c = 1:length(omega)
  a = exp(-j* omega(c) * [0:(M-1)]).';
  P(c) = 10*log10(1 / real( (a'*G*G'*a) ) );
end
plot(omega/2/pi*360,P);
xlabel('Degree');
ylabel('P(\omega)');
grid on;
