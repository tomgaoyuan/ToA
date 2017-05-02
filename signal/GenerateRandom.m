function [ vec ] = GenerateRandom( N, c_init )
%Generate Pseuduo-random sequence
    N_c= 1600;
    M_pn= N_c + N;
    x1 = zeros(1,M_pn);
    x1(1)= 1;
    for c = 32:M_pn
        x1(c) = mod(x1(c-28)+x1(c-31),2);
    end
    x2 = zeros(1,M_pn);
    x2(1:31) = bitget(uint32(c_init),1:31);
    for c = 32:M_pn
       x2(c) = mod(x2(c-28)+x2(c-29)+x2(c-30)+x2(c-31),2); 
    end
    vec = mod( x1(N_c+(1:N)) + x2(N_c+(1:N)), 2 );
end

