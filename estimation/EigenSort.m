function [V LAMBDA] = EigenSort (R_N)
% Eigen decomposition and sorting by descend order 
  [V, LAMBDA] = eig(R_N);
  LAMBDA = real(LAMBDA);
  
  for c1 = 2: size(LAMBDA,1)
    key = LAMBDA(c1,c1);
    keyV = V(:, c1 );   
    for c2 = 1: c1-1
      if key > LAMBDA(c2, c2)
        break;
      end   %end if
    end   %end for c2
    for c3 = c1: -1: c2+1
       LAMBDA(c3, c3) = LAMBDA(c3-1, c3-1);
       V(:, c3) = V(:, c3-1);
    end   %end for c3
    LAMBDA(c2, c2) = key;
    V(:, c2) = keyV;
  end  % end for c1
  
  LAMBDA = diag(LAMBDA);
end
