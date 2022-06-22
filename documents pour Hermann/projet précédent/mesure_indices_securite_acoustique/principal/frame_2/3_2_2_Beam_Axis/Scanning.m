function [STRUCT_PRT_Data, f] = Scanning(STRUCT_PRT_Data, Pas, Longueur_limite, Profondeur_2, Profondeur_3, nChannel, f)
% *************************************************************************
%   Name : Scanning
%   Date : 18/11/2021
% *************************************************************************
%%%%%%% Lancement des scans %%%%%%%
%% 1er scan à 1 mm (balayage sur l'axe des y avec le pas indiqué)
NbIdx = floor(Longueur_limite/Pas);
waitbar(0.16,f,'Scanning');

for ii = 1:NbIdx
    bras_deplacer( 0, Pas, 0);
    % Récupération du signal de l'oscilloscope
    [Y, T, ~, ~, ~] = osc_getWaveform(nChannel);
    % Stockage des informations dans la structure
    STRUCT_PRT_Data.Definition_Beam.Profondeur_1.Y_data{ii} = Y(1:end-1);
    STRUCT_PRT_Data.Definition_Beam.Profondeur_1.Time{ii} = T(1:end-1);
    STRUCT_PRT_Data.Definition_Beam.Profondeur_1.Pos{ii} = bras_position + (ii*Pas);
    waitbar(0.16 + 0.14*ii/(NbIdx+1),f,'Scanning');
end

%% 2e scan à la profondeur 2 (descente en z puis balayage en sens inverse)
bras_deplacer( 0, 0, -Profondeur_2);
res = bras_estEnMouvement;
% Pause needed if the mechanism goes in two direcitons at the same time
if any(res)
    pause(5);
end

for ii = 1:NbIdx
    bras_deplacer( 0, -Pas, 0);
    % Récupération du signal de l'oscilloscope
    [Y, T, ~, ~, ~] = osc_getWaveform(nChannel);
    % Stockage des informations dans la structure
    STRUCT_PRT_Data.Definition_Beam.Profondeur_2.Y_data{ii} = Y(1:end-1);
    STRUCT_PRT_Data.Definition_Beam.Profondeur_2.Time{ii} = T(1:end-1);
    STRUCT_PRT_Data.Definition_Beam.Profondeur_2.Pos{ii} = bras_position - (ii*Pas);
    waitbar(0.2+0.1*ii/(NbIdx+1),f,'Scanning');
end

%% 3e scan à la profondeur 3 (descente en z puis balayage sur l'axe des y avec le pas indiqué)
bras_deplacer( 0, 0, -Profondeur_3+Profondeur_2);
waitbar(0.31,f,'Scanning');

res = bras_estEnMouvement;
% Pause needed if the mechanism goes in two direcitons at the same time
if any(res)
    pause(5);
end

for ii = 1:NbIdx
    bras_deplacer( 0, Pas, 0);
    % Récupération du signal de l'oscilloscope
    [Y, T, ~, ~, ~] = osc_getWaveform(nChannel);
    % Stockage des informations dans la structure
    STRUCT_PRT_Data.Definition_Beam.Profondeur_3.Y_data{ii} = Y(1:end-1);
    STRUCT_PRT_Data.Definition_Beam.Profondeur_3.Time{ii} = T(1:end-1);
    STRUCT_PRT_Data.Definition_Beam.Profondeur_3.Pos{ii} = bras_position + (ii*Pas);
    waitbar(0.3+0.1*ii/(NbIdx+1),f,'Scanning');
end
end