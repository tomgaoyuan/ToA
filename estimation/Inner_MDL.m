function [DL DLIdx] = Inner_MDL (LAMBDA, NSamples)
%Perform the MDL algorithm  without any search window
%  LAMBDA is in descending order > 
%  NSamples is the number of samples

N_c = length(LAMBDA);
DL = NaN * ones(1, N_c);
DLIdx = 0 : N_c-1;
l = LAMBDA;

for k = 0: N_c-1
  likelihood = prod( l(k+1 : N_c).^(1/(N_c-k)) ) / ...
                  ( sum(l(k+1 : N_c)) / (N_c -k) );
  if likelihood > 0
    DL(k+1) = -(N_c -k) * NSamples *log2(likelihood) + ...
               1/2 * k * (2*N_c - k) * log2(NSamples); 
  end 

end  %end for k

end
