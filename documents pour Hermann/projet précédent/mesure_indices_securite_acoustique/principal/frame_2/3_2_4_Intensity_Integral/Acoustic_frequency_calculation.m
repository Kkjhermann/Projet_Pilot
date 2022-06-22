function frequac = Acoustic_frequency_calculation(Y, T)
% *************************************************************************
%   Name : Acoustic_frequency_calculation
%   Information: Finding the acoustic working frequency
%   Date : 2021-01-31
% *************************************************************************
% FFT operation
Y_fft = fft(Y);

% Finding the limits
Fech=1/(T(2)-T(1));
freq_list = (0:length(Y_fft)-1)/length(Y_fft)*Fech;

% Frequency area
Idx_intervalle = freq_list >= 1E06 & freq_list <= 20E06;

lim = 6; % -6 dB
% Finding the max
Y_max = max(abs(Y_fft(Idx_intervalle)));
SPL = 10*log10((abs(Y_fft).^2)/(Y_max.^2));
Limite_idx = find(SPL(Idx_intervalle) >= - lim);

% Determining f1 and f2
freq_intervalle = freq_list(Idx_intervalle);
amp_freq_intervalle=SPL(Idx_intervalle);
f2 = freq_intervalle(Limite_idx(end));
f1 = freq_intervalle(Limite_idx(1));
% Acoustic working fequency
frequac = f1+(f2 -f1)/2;
end