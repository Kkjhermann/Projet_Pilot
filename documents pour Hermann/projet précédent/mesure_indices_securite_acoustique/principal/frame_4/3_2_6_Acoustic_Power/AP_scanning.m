function STRUCT_PRT_Data = AP_scanning(STRUCT_PRT_Data, Longueur_limite_Y, Longueur_limite_X, nChannel, Sensibility)
% *************************************************************************
%   Name : AP_scanning
%   Date : 23/03/2022
% *************************************************************************

% Temperature's table in order to get the sound speed in the medium
Temp_table = STRUCT_PRT_Data.Temperature_calculation;
% Sound speed
SoundSpeed = Temp_table.Extrapolated_sound_speed;
% Acoustic impedance
AcImp = Temp_table.Acoustic_Imp;
% Pulse duration
Pulse_duration = STRUCT_PRT_Data.Pulse_duration;
% Translation of the sensibility's value [V/MPa ==> V/Pa]
Sensibility = Sensibility*1E-06;
% PRF
PRF = STRUCT_PRT_Data.PRF;
% Limit -12 dB
Limit_dB = 12;
% Step
Pas = 0.5;

%% Scanning along Y-axis
NbIdx = floor(Longueur_limite_Y/Pas);

for ii = 1:NbIdx
    bras_deplacer(0, Pas, 0);
    % Récupération du signal de l'oscilloscope
    [Y, T, ~, ~, ~] = osc_getWaveform(nChannel);
    % Stockage des informations dans la structure
    STRUCT_PRT_Data.Acoustic_Power.Y_data{ii} = Y(1:end-1);
    STRUCT_PRT_Data.Acoustic_Power.Y_Time{ii} = T(1:end-1);
end

%% Moving on the next scanning step
% Moving to -Y-limit length/2 and -X-limit length/2
bras_deplacer(-Longueur_limite_X/2, -Longueur_limite_Y/2, 0);

%% Scanning along X-axis
NbIdx = floor(Longueur_limite_X/Pas);

for ii = 1:NbIdx
    bras_deplacer(Pas, 0, 0);
    % Récupération du signal de l'oscilloscope
    [Y, T, ~, ~, ~] = osc_getWaveform(nChannel);
    % Stockage des informations dans la structure
    STRUCT_PRT_Data.Acoustic_Power.X_data{ii} = Y(1:end-1);
    STRUCT_PRT_Data.Acoustic_Power.X_Time{ii} = T(1:end-1);
end

end