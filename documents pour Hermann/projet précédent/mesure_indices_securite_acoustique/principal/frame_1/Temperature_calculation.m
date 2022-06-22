function [Extrap_Rho, Extrap_speed, Rho_speed] = Temperature_calculation(STRUCT_Data, Temp)
% *************************************************************************
%   Name : Temperature_calculation
%   Date : 11/12/2021
% *************************************************************************

% Depending on the input value calculating rho and the sound speed
Temp_table = STRUCT_Data.Temperature_table;

% Taking the temperature column
AllTemp = Temp_table.Temperature;
AllRho = Temp_table.Water_density;
AllSpeed = Temp_table.Sound_speed;

% Extrapolation
Extrap_Rho = interp1(AllTemp, AllRho, Temp, 'linear', 'extrap');
Extrap_speed = interp1(AllTemp, AllSpeed, Temp, 'linear', 'extrap');
Rho_speed = Extrap_Rho*Extrap_speed;
end