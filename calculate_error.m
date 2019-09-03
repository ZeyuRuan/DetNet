function errorbit_num=CalculateBER(DataRecover,DataRaw,NumDataSymb,Modulation,State)

UE_ID = [0];
xhat=zeros(length(UE_ID),size(DataRecover,2));
if State==0
    for i=1:length(UE_ID)
             xhat(i,:) = DataRecover((UE_ID(i)+1),:);
    end
else
    for i=1:length(UE_ID)
             xhat(i,:) = DataRecover(i,:);
    end
end
    
errorbit_num=zeros(1,1);
          % BPSK modulation
if strcmp(Modulation,'BPSK')
   xhat = qamdemod(xhat,2);
   for nUE=1:length(UE_ID)
   xhat1 = dec2bin(xhat(nUE,:)).';
   xhat1 = reshape(xhat1,1,1*NumDataSymb);
   xhat1 = bin2dec(xhat1.').';
   errorbit_num((UE_ID(nUE)+1)) = length(find(DataRaw(nUE,:)~=xhat1));
   %BER((UE_ID(nUE)+1)) = length(find(DataRaw(nUE,:)~=xhat1))/(1*1200*NumDataSymb);
   end
   % QPSK modulation
elseif strcmp(Modulation,'QPSK')
   xhat = qamdemod(xhat*sqrt(2),4);
   for nUE=1:length(UE_ID)
   xhat1 = dec2bin(xhat(nUE,:)).';
   xhat1 = reshape(xhat1,1,2*NumDataSymb);
   xhat1 = bin2dec(xhat1.').';
   errorbit_num((UE_ID(nUE)+1)) = length(find(DataRaw(nUE,:)~=xhat1));
   %errorbit_num((UE_ID(nUE)+1)) = length(find(DataRaw(nUE,:)~=xhat1))/(2*1200*NumDataSymb);
   end
elseif strcmp(Modulation,'16QAM')
   xhat = qamdemod(xhat*sqrt(10),16);
   for nUE=1:length(UE_ID)
   xhat1 = dec2bin(xhat(nUE,:)).';
   xhat1 = reshape(xhat1,1,4*NumDataSymb);
   xhat1 = bin2dec(xhat1.').';
   errorbit_num((UE_ID(nUE)+1)) = length(find(DataRaw(nUE,:)~=xhat1));
   %errorbit_num((UE_ID(nUE)+1)) = length(find(DataRaw(nUE,:)~=xhat1))/(4*1200*NumDataSymb);
   end
   % 64-QAM modulation
elseif strcmp(Modulation,'64QAM')%---zhy---64QAM¿ÌΩ‚¿‡À∆16QAM
  xhat = qamdemod(xhat*sqrt(42),64); 
  for nUE=1:length(UE_ID)
   xhat1 = dec2bin(xhat(nUE,:)).';
   xhat1 = reshape(xhat1,1,6*NumDataSymb);
   xhat1 = bin2dec(xhat1.').';
   errorbit_num((UE_ID(nUE)+1)) = length(find(DataRaw(nUE,:)~=xhat1));
   %errorbit_num((UE_ID(nUE)+1)) = length(find(DataRaw(nUE,:)~=xhat1))/(6*1200*NumDataSymb);
   end
end

end