function [ CRS, SC, OFDMnumber ] = GenerateCRS(cellID, subframeID, TXnum, DLRBnum )
%Generate the CRS (cell-specific Reference ID) according to 36.211 R14
N = 110;
N_DL_RB = DLRBnum;
N_cp = 1;       %only for normal CP
N_DL_symb = 7;
assert(TXnum<=2 || TXnum ==4);
if TXnum == 1
     OFDMpattern = {[0,4,7,11]};
elseif TXnum ==2
    OFDMpattern = {[0,4,7,11],[0,4,7,11]};
elseif TXnum ==4
    OFDMpattern = {[0,4,7,11],[0,4,7,11],[1,8],[1,8]};
end
OFDMnumber = OFDMpattern;
CRS = cell(1,TXnum);
SC = cell(1,TXnum);
N_cell_ID = cellID;
for p = 0 : TXnum-1
    crs = zeros(2*N_DL_RB, length(OFDMpattern{p+1}));
    sc = zeros(2*N_DL_RB, length(OFDMpattern{p+1}));
    for ofdmIdx = OFDMpattern{p+1}
        n_s = 2 *subframeID + floor(ofdmIdx/N_DL_symb);
        n_s_m = n_s;
        l = mod(ofdmIdx, N_DL_symb);
        %random sequence
        c_init = 2^10 * (7 * (n_s_m+1) + l + 1) * (2*N_cell_ID+1)+...
            2*N_cell_ID + N_cp;
        c = GenerateRandom(4*N, c_init);
        %sequence generation
        r = 1/sqrt(2) * ( (1-2 * c(1:2:end)) + 1j * ( 1 - 2*c(2:2:end) ));
        a = r(N-N_DL_RB+1 : N+N_DL_RB);
        crs(:,ofdmIdx == OFDMpattern{p+1}) = a.';
        %resource mapping
        v_shift = mod(N_cell_ID,6);
        if p==0 && l==0
            v = 0;
        elseif p==0 && l~=0
            v = 3;
        elseif p==1 && l==0
            v = 3;
        elseif p==1 && l~=0
            v = 0;
        elseif p==2
            v = 3 * mod(n_s,2);
        else
            v = 3 + 3 * mod(n_s,2);
        end
        k = 6 * (0:2*N_DL_RB-1) + mod(v+v_shift,6);
        sc(:,ofdmIdx == OFDMpattern{p+1}) = k.';
    end
    CRS{p+1} = crs;
    SC{p+1} = sc;
end
end
