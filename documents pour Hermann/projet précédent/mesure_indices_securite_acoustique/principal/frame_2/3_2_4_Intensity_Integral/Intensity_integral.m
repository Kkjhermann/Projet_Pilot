function [STRUCT_PRT_Data, ISPTA_max, f] = Intensity_integral(STRUCT_PRT_Data, Profondeur_3, Sensibility, nChannel, Longueur_limite, f)
% *************************************************************************
%   Name : Intensity_integral
%   Information: Derated time_averaged intensity integral and depth of the maximum derated intensity z3
%   Date : 11/01/2022
% *************************************************************************
%% Recovering useful information
waitbar(0.60,f,'Depth of the maximum derated intensity z3');
% Beam axis' equation
coefficients = STRUCT_PRT_Data.Definition_Beam.coefficients;
% Temperature's table in order to get the sound speed in the medium
Temp_table = STRUCT_PRT_Data.Temperature_calculation;
% Sound speed
SoundSpeed = Temp_table.Extrapolated_sound_speed;
% Acoustic impedance
AcImp = Temp_table.Acoustic_Imp;
% Pulse duration
Pulse_duration = STRUCT_PRT_Data.Pulse_duration;
% PRF
PRF = STRUCT_PRT_Data.PRF;
% Translation of the sensibility's value [V/MPa ==> V/Pa]
Sensibility = Sensibility*1E-06;

%%
step = 0.5;
posZ = Profondeur_3;
a = coefficients(1);
b = coefficients(2);
% In order to get all positions, we use this index starting from zero
Indice = 0;
PosY_First = a*(Profondeur_3-Indice*step)+b;
waitbar(0.75,f,'Depth of the maximum derated intensity z3');
Ntotal = floor(Profondeur_3/step);

%% FOR loop in order to follow the equation's coefficients from the last position to the first (Z = 1mm)
for ii = 1:Ntotal
    %% Transition time
    if Indice~=0
        % Moving step by step
        bras_deplacer(0, PosY_Next-PosY_Prev, step);
        res = bras_estEnMouvement;
        % Pause needed when the mechanism goes in two directions at the same time
        if any(res)
            pause(4);
        end
    else
        % For index = 0, the systeme moves to the last position of Y
        bras_deplacer(0, -(Longueur_limite-PosY_First), 0);
        res = bras_estEnMouvement;
        % Pause needed when the mechanism goes in two directions at the same time
        if any(res)
            pause(5);
        end
    end
    
    %% Recovering
    [Y, T, ~, ~, ~] = osc_getWaveform(nChannel);
    % We remove the last dot of the data since this is a weird peak
    Y_new = Y(1:end-1);
    T_new = T(1:end-1);
    % Storage
    STRUCT_PRT_Data.Maximum_derated_intensity.Y_data{Indice+1} = Y_new;
    STRUCT_PRT_Data.Maximum_derated_intensity.Time{Indice+1} = T_new;
    STRUCT_PRT_Data.Maximum_derated_intensity.Pos{Indice+1} = bras_position - (Indice*step);
    
    %% Pulse pressure squared integral PPI
    T_period = 2*(posZ*1E-03/SoundSpeed + Pulse_duration);
    % We take the voltage and translate it into pressure
    Pac_squared = (Y(find(T>=0,1):end-1)/Sensibility).^2;
    interv = linspace(0,T_period, length(Pac_squared));
    PPI = trapz(interv,Pac_squared);
    STRUCT_PRT_Data.Maximum_derated_intensity.PPI{Indice+1} = PPI;
    
    %% Derated pulse intensity
    % Finding the acoustic working frequency
    frequac = Acoustic_frequency_calculation(Y_new, T_new);
    PII = (PPI/AcImp)*10^(-3*1.0e-5*posZ*1.0e-3*frequac/10);
    STRUCT_PRT_Data.Maximum_derated_intensity.PII{Indice+1} = PII;
    % Saving the the value of the acoustic working frequency "freqac"
    STRUCT_PRT_Data.Maximum_derated_intensity.frequac{Indice+1} = frequac;
    
    %% Derated time-averaged intensity integral
    Ispta = PRF*PII;
    STRUCT_PRT_Data.Maximum_derated_intensity.Ispta{Indice+1} = Ispta;
    
    %% Updating index and position
    PosY_Prev = a*(Profondeur_3-Indice*step)+b;
    Indice = Indice + 1;
    % The position in Z moves upward for each 0.5 mm step
    posZ = posZ - step;
    % We update the current position using the coefficients of the beam axis equation
    PosY_Next = a*(Profondeur_3-Indice*step)+b;
    waitbar(0.75+0.2*ii/Ntotal,f,'Depth of the maximum derated intensity z3');
end

waitbar(0.96,f,'Depth of the maximum derated intensity z3');
%% First safety index: ISPTA_max
All_Ispta = cell2mat(STRUCT_PRT_Data.Maximum_derated_intensity.Ispta);
[ISPTA_max, idz3] = max(All_Ispta);
STRUCT_PRT_Data.Maximum_derated_intensity.ISPTA_Max = ISPTA_max;
STRUCT_PRT_Data.Maximum_derated_intensity.Index_IPSTA_Max = idz3;
end