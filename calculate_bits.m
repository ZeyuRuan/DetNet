function [NumBits] = calculate_bits(Modulation,NumSubcarriers,NumDataSymb)
switch(Modulation)
    case 'BPSK'
        Nbpscs=1;%---zhy----二进制序列长度，2^1=2
    case 'QPSK'
        Nbpscs=2;
    case '16QAM'
        Nbpscs=4;
    case '64QAM'
        Nbpscs=6;
end
NumBits = NumDataSymb*NumSubcarriers*Nbpscs;
end