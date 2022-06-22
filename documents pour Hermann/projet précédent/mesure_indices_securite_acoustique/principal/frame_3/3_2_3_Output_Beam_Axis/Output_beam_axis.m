function [STRUCT_PRT_Data, f] = Output_beam_axis(STRUCT_PRT_Data, Longueur_limite_Y, Longueur_limite_X, nChannel, Sensibility, f)
% *************************************************************************
%   Name : Output_beam_axis
%   Date : 07/03/2022
% *************************************************************************

% Temperature's table in order to get the sound speed in the medium
Temp_table = STRUCT_PRT_Data.Temperature_calculation;
% Sound speed
SoundSpeed = Temp_table.Extrapolated_sound_speed;
% Pulse duration
Pulse_duration = STRUCT_PRT_Data.Pulse_duration;
% Translation of the sensibility's value [V/MPa ==> V/Pa]
Sensibility = Sensibility*1E-06;
% Limit -12 dB
Limit_dB = 12;

%% Proceeding to a new scan along Y-axis
step = 0.5; % 0.5 mm
Ntotal = floor(Longueur_limite_Y/step);
[~, PosY, ~] = bras_position;
PosZ = 1; % 1mm
waitbar(0.2,f,'Scanning along Y');

%% FOR loop
for ii = 1:Ntotal
    
    bras_deplacer(0, step, 0);
    res = bras_estEnMouvement;
    % Pause needed when the mechanism goes in two directions at the same time
    if any(res)
        pause(2);
    end
    
    %% Recovering
    [Y, T, ~, ~, ~] = osc_getWaveform(nChannel);
    % We remove the last dot of the data since this is a weird peak
    Y_new = Y(1:end-1);
    T_new = T(1:end-1);
    % Storage
    STRUCT_PRT_Data.Output_beam_area.Beam_height.Y_data{ii} = Y_new;
    STRUCT_PRT_Data.Output_beam_area.Beam_height.Time{ii} = T_new;
    STRUCT_PRT_Data.Output_beam_area.Beam_height.Distance{ii} = PosY;
    
    %% Pulse pressure squared integral PPI
    T_period = 2*(PosZ*1E-03/SoundSpeed) + Pulse_duration;
    % We take the voltage and translate it into pressure
    Pac_squared = (Y(find(T>=0,1):end-1)/Sensibility).^2;
    interv = linspace(0,T_period, length(Pac_squared));
    PPI = trapz(interv,Pac_squared);
    STRUCT_PRT_Data.Output_beam_area.Beam_height.PPI{ii} = PPI;
    
    %% Updating index and position
    % The position in Y moves upward for each 0.5 mm step
    PosY = PosY + step;
    waitbar(0.2+0.2*ii/Ntotal, f, 'Scanning along Y');
end

%% PPI in expressed in dB
All_PPI = cell2mat(STRUCT_PRT_Data.Output_beam_area.Beam_height.PPI);
PPI_dB = 10*log10(All_PPI/max(All_PPI));
STRUCT_PRT_Data.Output_beam_area.Beam_height.PPI_dB = num2cell(PPI_dB);

%% Finding the two limits where PPI_dB values are below -12 dB
All_distance = cell2mat(STRUCT_PRT_Data.Output_beam_area.Beam_height.Distance);
Selec_indices = find(PPI_dB >= max(PPI_dB)-Limit_dB);

if isempty(Selec_indices)
    Selec_indices = [1 length(PPI_dB)];
end

% We are able to establish the beam limit such as
Ly = All_distance(Selec_indices(end))-All_distance(Selec_indices(1));

%% Proceeding to a new scan along X-axis
step = 0.1; % 0.1 mm
Ntotal = floor(Longueur_limite_X/step);
% Moving the good positions
bras_deplacer(-Longueur_limite_X/2, -Longueur_limite_Y/2, 0);
[PosX, ~, ~] = bras_position;
waitbar(0.5, f, 'Scanning along X');

%% FOR loop
for ii = 1:Ntotal
    
    bras_deplacer(step, 0, 0);
    res = bras_estEnMouvement;
    % Pause needed when the mechanism goes in two directions at the same time
    if any(res)
        pause(2);
    end
    
    %% Recovering
    [Y, T, ~, ~, ~] = osc_getWaveform(nChannel);
    % We remove the last dot of the data since this is a weird peak
    Y_new = Y(1:end-1);
    T_new = T(1:end-1);
    % Storage
    STRUCT_PRT_Data.Output_beam_area.Beam_length.Y_data{ii} = Y_new;
    STRUCT_PRT_Data.Output_beam_area.Beam_length.Time{ii} = T_new;
    STRUCT_PRT_Data.Output_beam_area.Beam_length.Distance{ii} = PosX;
    
    %% Pulse pressure squared integral PPI
    T_period = 2*(PosZ*1E-03/SoundSpeed) + Pulse_duration;
    % We take the voltage and translate it into pressure
    Pac_squared = (Y(find(T>=0,1):end-1)/Sensibility).^2;
    interv = linspace(0,T_period, length(Pac_squared));
    PPI = trapz(interv,Pac_squared);
    STRUCT_PRT_Data.Output_beam_area.Beam_length.PPI{ii} = PPI;
    
    %% Updating index and position
    % The position in Y moves upward for each 0.5 mm step
    PosX = PosX + step;
    waitbar(0.5+0.2*ii/Ntotal, f, 'Scanning along X');
end

%% PPI in expressed in dB
All_PPI = cell2mat(STRUCT_PRT_Data.Output_beam_area.Beam_length.PPI);
PPI_dB = 10*log10(All_PPI/max(All_PPI));
STRUCT_PRT_Data.Output_beam_area.Beam_length.PPI_dB = num2cell(PPI_dB);

%% Finding the two limits where PPI_dB values are below -12 dB
All_distance = cell2mat(STRUCT_PRT_Data.Output_beam_area.Beam_length.Distance);
Selec_indices = find(PPI_dB >= max(PPI_dB)-Limit_dB);

if isempty(Selec_indices)
    Selec_indices = [1 length(PPI_dB)];
end

% We are able to establish the beam limit such as
Lx = All_distance(Selec_indices(end))-All_distance(Selec_indices(1));

%% -12dB output area is calculated as
Area = Lx*1E-03*Ly*1E-03; % [m²]

%% Equivalent aperture diameter
Diam_equ = max(sqrt(4*Area/pi), 1E-03); % [m]

%% Breakpoint depth is finally:
Zbkp = 1.5*Diam_equ; % [m]
waitbar(0.8, f, 'Scanning along X');

%% Saving in the structure
STRUCT_PRT_Data.Output_beam_area.Output_area = Area;
STRUCT_PRT_Data.Output_beam_area.Aperture_diameter = Diam_equ;
STRUCT_PRT_Data.Output_beam_area.Breakpoint_depth = Zbkp;
end