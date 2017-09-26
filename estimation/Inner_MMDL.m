function [ DL, DLIdx ] = Inner_MMDL( U, LAMBDA, R, a1 )
%INNER_MMDL MMDL part of MusicLSMdl algorithm
  %Only stands when E[a1] = 0, namely raleigh channel 

N = size(R, 2);
N_c = size(R, 1);
%get tranining information
sigaSquare = 0;
rxd = zeros(size(R,1), 1);
for c = 1 : N
  sigaSquare = sigaSquare + a1(c) * a1(c)';
  rxd = rxd + R(:, c) *  a1(c)';
end     %end for
sigaSquare = sigaSquare / N;
rxd = rxd / N;
%get description length DL
xi = zeros(1, N_c);     %xi is used as log(xi)
for k = 1: N_c
  xi(k) = sigaSquare;
  for c = 1: k
    xi(k) = xi(k) - abs(rxd' * U(:,c)).^2/ LAMBDA(c);
  end %enf for c
end     %end for k
xi(xi<=0) = NaN;
DL = N * log2(xi) + 1/2 * ([1:N_c].^2 + [1: N_c]) * log2(N);
DLIdx = 1:N_c;

end

