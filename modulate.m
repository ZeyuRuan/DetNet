function [DataModulated] = modulate(DataRawI,Modulation)
LengthData = length(DataRawI);

  % BPSK modulation
if strcmp(Modulation,'BPSK')
   table=exp(1j*[0 -pi]);  % generates BPSK symbols ���Ϊ��1 0��
   table=table([1 0]+1); % Gray code mapping pattern for BPSK symbols����ӳ��[1 0]+1=2 1,ȡtable�ĵڶ�λ���һλ��table���Ϊ��0 1��
   inp=DataRawI;
   DataModulated=table(inp+1);% maps transmitted bits into BPSK symbols ����Ϊ0�����ƺ�ȡtable�ĵ�1λΪ0�� ����Ϊ1�����ƺ�ȡtable�ĵڶ�λΪ1
   
   % QPSK modulation
elseif strcmp(Modulation,'QPSK')
   table=exp(1j*[-3/4*pi 3/4*pi 1/4*pi -1/4*pi]);  % generates QPSK symbols�����������˳��Ϊ������˳ʱ�����%---zhy---��-sqrt(2)/2-j*sqrt(2)/2  -sqrt(2)/2+j*sqrt(2)/2  sqrt(2)/2+j*sqrt(2)/2  sqrt(2)/2-j*sqrt(2)/2��
   table=table([1 0 2 3]+1); % Gray code mapping pattern for QPSK symbols---zhy---[-,-  -,+  +,-  +,+]
   inp=reshape(DataRawI,2,LengthData/2);        %---zhy---һ��bitsдΪ2*1�ľ���ÿһ�д���һ��symbol
   DataModulated=table([2 1]*inp+1);  % maps transmitted bits into QPSK symbols 
                                 %---zhy---����Ϊ00,outΪtable��1λ��-��-����inΪ01��outΪtable��2λ��-��+����inΪ10��outΪtable��3λ��+��-����inΪ11��outΪtable��4λ��+��+��
   
   % 16-QAM modulation
elseif strcmp(Modulation,'16QAM')
   % generates 16QAM symbols
   m=1;%������ʼΪ1����16ֹ
   for k=-3:2:3%ȡ-3 -1 1 3
      for l=-3:2:3%ȡ-3 -1 1 3
         table(m) = (k+1j*l)/sqrt(10); % power normalization ��һ������׼������ ����Ƥ��P66 
         %��ѭ���õ�����������
         m=m+1;
      end;
   end;
   table=table([3 2 1 0 7 6 5 4 11 10 9 8 15 14 13 12]+1); % Gray code mapping pattern for 16QAM symbols �����������˳��Ϊ�������ϣ��������ҡ�����Ƥ��68ҳ��ߺ������˸���ӳ��table��
   % [0 1 3 2 6 7 5 4 12 13 15 14 10 11 9 8]��Ϊ���������ң��������������µ�ͷ���ζ���˳��
   %---zhy---�����Ӧ������[0000 0001 0011 0010 0110 0111 0101 0100 1100 1101 1111 1110 1010 1011 1001 1000]
   inp=reshape(DataRawI,4,LengthData/4);
   DataModulated=table([8 4 2 1]*inp+1);  % maps transmitted bits into 16QAM symbols
   
   % 64-QAM modulation
elseif strcmp(Modulation,'64QAM')%---zhy---64QAM�������16QAM
   % generates 64QAM symbols
   m=1;
   for k=-7:2:7 %---zhy---ȡ-7 -5 -3 -1 1 3 5 7
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
         56+[ 7  6  5  4  3  2  1  0]]+1);%---zhy---�����������ߣ������������ٹջ����£������䣩�������ҹջ�������
   inp=reshape(DataRawI,6,LengthData/6);
   DataModulated=table([32 16 8 4 2 1]*inp+1);  % maps transmitted bits into 64QAM symbol
end
end