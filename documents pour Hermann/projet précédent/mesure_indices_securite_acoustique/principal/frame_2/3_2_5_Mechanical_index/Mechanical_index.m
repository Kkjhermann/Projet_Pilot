function [STRUCT_PRT_Data, MI, f] = Mechanical_index(STRUCT_PRT_Data, Sensibility, Profondeur_3, Pas, f)
% *************************************************************************
%   Name : Mechanical_index
%   Information: Getting the mechanical index
%   Date : 15/02/2022
% *************************************************************************
%%
% Translation of the sensibility's value [V/MPa ==> V/Pa]
Sensibility = Sensibility*1E-06;
idz3 = STRUCT_PRT_Data.Maximum_derated_intensity.Index_IPSTA_Max;
Y_dataz3 = STRUCT_PRT_Data.Maximum_derated_intensity.Y_data{idz3};
T = STRUCT_PRT_Data.Maximum_derated_intensity.Time{idz3};

%% Instantaneous acoustic pressure
Pac = Y_dataz3./Sensibility;

%% Acoustic working frequency
frequac = STRUCT_PRT_Data.Maximum_derated_intensity.frequac{idz3} 
    
%% Derated peak-rarefactional pressure [Pa]
z3 = Profondeur_3 - idz3*Pas;
Pr3 = abs(min(Pac*10^(-3*1.0e-5*z3*1.0e-3*frequac/20)));

%% Mechanical index
if frequac < 4e6
    MI = (Pr3*1.0e-6)/sqrt(frequac*1.0e-6);
elseif frequac >= 4e6
    MI = (Pr3*1.0e-6)/2;
end
STRUCT_PRT_Data.Maximum_derated_intensity.MI=MI;
end