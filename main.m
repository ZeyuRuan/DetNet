clear all;
clc;
clf;
close all;

% h_response_dict=[];
% for test_ix = 1:10
%     str_temp = ['H_dataset\',int2str(test_ix),'.txt'];
%     h_temp=load(str_temp);
%     h_response_dict=[h_response_dict;h_temp(:,1:16)+sqrt(-1)*h_temp(:,17:32)];
% end

%% parameters
NumSubcarriers = 1;
Modulation = 'BPSK';
NumDataSymb = 1;
NumCP = 16;
FFTSize = 64;
NumTrain = 2000;
NR = 30;
NT = 20;

DataModulated = zeros(1, NumSubcarriers);
pilotFFT = zeros(1, NumSubcarriers);
dataFFT = zeros(1, NumSubcarriers);

for iSNR = 1:5
    SNR=iSNR*5;
%     disp(SNR);
    errorbit_num_LS = 0;
    errorbit_num_MMSE = 0;
    for m = 1:NumTrain
%         disp(m);
        for t=1:NT
            %% data symbol generate
            NumBits = calculate_bits(Modulation,NumSubcarriers,NumDataSymb);
            DataRaw(t,:) = randi(2,1,NumBits)-1; %产生0，1的比特流
            DataModulated(t,:) = modulate(DataRaw(t,:),Modulation);       
%             %% IFFT, add CP
%             dataIFFT = ifft(DataModulated, FFTSize);
%             dataCP(t,:) = [dataIFFT(FFTSize-NumCP+1:FFTSize) dataIFFT];
        end
        
        
        
       %% MIMO CHANNEL
       H = randn(NR,NT);
       datah = H*DataModulated;
        
%        %% WINNER 2 channel, AWGN
%        datah = zeros(NR,size(dataCP,2)+size(h_response_dict,2)-1);
%        for r=1:NR
%            for t=1:NT
%                 
%                 h_response = h_response_dict(randi(size(h_response_dict,1)),:);
%                 H_true(r,t,:) = (fft(h_response,FFTSize)).';
%                 %% received signal
%                 datah(r,:) = datah(r,:)+conv(dataCP(t,:),h_response);
%            end
%        end
        
        for r=1:NR
            %data
            DatasigPow = mean(abs(datah(r,:)).^2);
            Datanoise_mag = sqrt((10.^(-SNR/10)*DatasigPow)/2);
            Datanoise=Datanoise_mag*(randn(size(datah(r,:)))+sqrt(-1)*randn(size(datah(r,:))));
            dataReceived(r,:)=datah(r,:)+Datanoise;
                       
%             %% -CP, FFT
%             dataRemoveCP(r,:) = dataReceived(r,NumCP+1:NumCP+FFTSize);
%             dataFFT(r,:) = fft(dataRemoveCP(r,:),FFTSize);
        end
        
        
        %% detection
        
        % MMSE detection
        W_MMSE = inv(H.'*H+eye(NT)*(1/(10^(SNR/10))))*H';
        X_MMSE= W_MMSE*dataReceived;
        
        %         %% detection
        %         for k = 1: FFTSize
        %             % MMSE detection
        %             W_MMSE = inv(H_true(:,:,k)'*H_true(:,:,k)+eye(NT)*(1/(10^(SNR/10))))*H_true(:,:,k)';
        %             X_MMSE(:,k) = W_MMSE*dataReceived(:,k);
        %         end
        
        %% evaluate BER
        for t=1:NT
            errorbit_num_MMSE = errorbit_num_MMSE + calculate_error(X_MMSE(t,:),DataRaw(t,:),NumDataSymb,Modulation,0);
        end
    end
    BER_MMSE(iSNR) = errorbit_num_MMSE/(NT*NumBits*NumTrain);
end
figure()
semilogy([5:5:25],BER_MMSE,'-x');grid on;
legend('MMSE-BPSK-64PILOTS');

