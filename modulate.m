function [DataModulated] = modulate(DataRawI,Modulation)
LengthData = length(DataRawI);

  % BPSK modulation
if strcmp(Modulation,'BPSK')
   table=exp(1j*[0 -pi]);  % generates BPSK symbols 结果为【1 0】
   table=table([1 0]+1); % Gray code mapping pattern for BPSK symbols格雷映射[1 0]+1=2 1,取table的第二位与第一位，table结果为【0 1】
   inp=DataRawI;
   DataModulated=table(inp+1);% maps transmitted bits into BPSK symbols 输入为0，调制后取table的第1位为0； 输入为1，调制后取table的第二位为1
   
   % QPSK modulation
elseif strcmp(Modulation,'QPSK')
   table=exp(1j*[-3/4*pi 3/4*pi 1/4*pi -1/4*pi]);  % generates QPSK symbols按星座点读出顺序为从左下顺时针读。%---zhy---【-sqrt(2)/2-j*sqrt(2)/2  -sqrt(2)/2+j*sqrt(2)/2  sqrt(2)/2+j*sqrt(2)/2  sqrt(2)/2-j*sqrt(2)/2】
   table=table([1 0 2 3]+1); % Gray code mapping pattern for QPSK symbols---zhy---[-,-  -,+  +,-  +,+]
   inp=reshape(DataRawI,2,LengthData/2);        %---zhy---一串bits写为2*1的矩阵，每一列代表一个symbol
   DataModulated=table([2 1]*inp+1);  % maps transmitted bits into QPSK symbols 
                                 %---zhy---输入为00,out为table第1位（-，-）；in为01，out为table第2位（-，+）；in为10，out为table第3位（+，-）；in为11，out为table第4位（+，+）
   
   % 16-QAM modulation
elseif strcmp(Modulation,'16QAM')
   % generates 16QAM symbols
   m=1;%给出初始为1，到16止
   for k=-3:2:3%取-3 -1 1 3
      for l=-3:2:3%取-3 -1 1 3
         table(m) = (k+1j*l)/sqrt(10); % power normalization 归一化、标准化功率 见红皮书P66 
         %本循环得到星座点坐标
         m=m+1;
      end;
   end;
   table=table([3 2 1 0 7 6 5 4 11 10 9 8 15 14 13 12]+1); % Gray code mapping pattern for 16QAM symbols 按星座点读出顺序为从下至上，从左至右。按红皮书68页左边红字理解此格雷映射table。
   % [0 1 3 2 6 7 5 4 12 13 15 14 10 11 9 8]此为按从左至右，从下至上再向下掉头依次读的顺序。
   %---zhy---上面对应格雷码[0000 0001 0011 0010 0110 0111 0101 0100 1100 1101 1111 1110 1010 1011 1001 1000]
   inp=reshape(DataRawI,4,LengthData/4);
   DataModulated=table([8 4 2 1]*inp+1);  % maps transmitted bits into 16QAM symbols
   
   % 64-QAM modulation
elseif strcmp(Modulation,'64QAM')%---zhy---64QAM理解类似16QAM
   % generates 64QAM symbols
   m=1;
   for k=-7:2:7 %---zhy---取-7 -5 -3 -1 1 3 5 7
      for l=-7:2:7
         table(m) = (k+j*l)/sqrt(42); % power normalization
         m=m+1;
      end;
   end;
   table=table([[ 7  6  5  4  3  2  1  0]...
         8+[ 7  6  5  4  3  2  1  0]... 
         16+[ 7  6  5  4  3  2  1  0]...
         24+[ 7  6  5  4  3  2  1  0]...
         32+[ 7  6  5  4  3  2  1  0]...
         40+[ 7  6  5  4  3  2  1  0]...
         48+[ 7  6  5  4  3  2  1  0]...
         56+[ 7  6  5  4  3  2  1  0]]+1);%---zhy---不按格雷码走，按从下往上再拐回往下（各区间）从左往右拐回往左走
   inp=reshape(DataRawI,6,LengthData/6);
   DataModulated=table([32 16 8 4 2 1]*inp+1);  % maps transmitted bits into 64QAM symbol
end
end