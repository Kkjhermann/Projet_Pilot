function Temp_table = Temperature_table
% *************************************************************************
%   Name : Temperature_table
%   Date : 11/12/2021
% *************************************************************************
% Structure where all temperature, rho, sound_speed and rho*sound_speed values are stored
% For water

Temperature = (16:2:28)';
Water_density = [0.9989; 0.9986; 0.9982; 0.9978; 0.9973; 0.9968; 0.9962]*1E3;
Sound_speed = [1469.4; 1476.0; 1482.3; 1488.3; 1494.0; 1499.3; 1504.4];
Acoustic_Imp = Water_density.*Sound_speed;

% Table
Temp_table = table(Temperature, Water_density, Sound_speed, Acoustic_Imp);
end