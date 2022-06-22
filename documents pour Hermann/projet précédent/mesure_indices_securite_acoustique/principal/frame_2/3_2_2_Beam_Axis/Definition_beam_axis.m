function [STRUCT_PRT_Data, f, stop_process] = Definition_beam_axis(STRUCT_PRT_Data, guiPRT, Graphics_Acoustic, Graphics_Middle_Pos, Sensibility, Profondeur_2, Profondeur_3, Pas, Longueur_limite, f)
% *************************************************************************
%   Name : Definition_beam_axis
%   Date : 18/11/2021
% *************************************************************************

% Translation of the sensibility's value [V/MPa ==> V/Pa]
Sensibility = Sensibility*1E-06;

% Initialization of all useful variables
Limit = 12; % Limit of -12dB
Not_good = zeros(1, 3);
Vector_Pos = Pas:Pas:Longueur_limite;

% Creating arrays
Y1_max = zeros(1,size(STRUCT_PRT_Data.Definition_Beam.Profondeur_1.Y_data,2));
Y2_max = Y1_max;
Y3_max = Y1_max;
waitbar(0.43,f,'Definition beam axis');

% Loop over all columns of the stored values (all Y positions)
for ii = 1:size(STRUCT_PRT_Data.Definition_Beam.Profondeur_1.Y_data,2)
    
    %% Profondeur 1 ==> 1 mm
    Y1 = STRUCT_PRT_Data.Definition_Beam.Profondeur_1.Y_data{:,ii};
    % Getting the maximum of the maximum
    Y1_max(1,ii) = max(Y1);
    
    %% Profondeur 2
    Y2 = STRUCT_PRT_Data.Definition_Beam.Profondeur_2.Y_data{:,ii};
    Y2_max(1,ii) = max(Y2);
    
    %% Profondeur 3
    Y3 = STRUCT_PRT_Data.Definition_Beam.Profondeur_3.Y_data{:,ii};
    Y3_max(1,ii) = max(Y3);
    waitbar(0.43+0.09*ii/size(STRUCT_PRT_Data.Definition_Beam.Profondeur_1.Y_data,2),f,'Definition beam axis');
end

% Dealing with the maximum and the dB values
%% Profondeur 1
% We take the voltage for each point and translate it into pressure
Pac_1 = Y1_max./Sensibility;
% We also calculate the reference pressure for calculation of dB
Pref = max(Y1_max)/Sensibility;
% Calculation of the acoustic levels
Lb_1 = 10*log10((Pac_1.^2)/(Pref.^2));
% Maxmimum value in dB
Max1 = max(Lb_1);

% We get the limit's area from the maximum value
LimitArea = find(Lb_1 >= Max1-Limit);
% CheckOnes = [true diff(LimitArea)==1];
Results = LimitArea(strfind(diff(LimitArea),[1 1 1 1 1 1]));

% If the condition is not set, we record the concerned curve
if isempty(Results)
    Not_good(1,1) = 1;
    % We get the coordinates of the middle point of the limit area
    First_y = Vector_Pos(LimitArea(1));
    Last_y = Vector_Pos(LimitArea(end));
else
    First_y = Vector_Pos(Results(1));
    Last_y = Vector_Pos(Results(end)+6);
end

% Middle position
Values_1 = (First_y+Last_y)/2;

%% Profondeur 2
% We take the voltage for each point and translate it into pressure
Pac_2 = Y2_max./Sensibility;
% We also calculate the reference pressure for calculation of dB
Pref = max(Y2_max)/Sensibility;
% Calculation of the acoustic levels
Lb_2 = 10*log10((Pac_2.^2)/(Pref.^2));
% Maxmimum value in dB
Max2 = max(Lb_2);

% We get the limit's area from the maximum value
LimitArea = find(Lb_2 >= Max2-Limit);
Results = LimitArea(strfind(diff(LimitArea),[1 1 1 1 1 1]));

% If the condition is not set, we record the concerned curve
if isempty(Results)
    Not_good(1,2) = 1;
    % We get the coordinates of the middle point of the limit area
    First_y = Vector_Pos(LimitArea(1));
    Last_y = Vector_Pos(LimitArea(end));
else
    First_y = Vector_Pos(Results(1));
    Last_y = Vector_Pos(Results(end)+6);
end

Values_2 = (First_y+Last_y)/2;

% Inversion of Lb_2 values
Lb_2 = flip(Lb_2);

%% Profondeur 3
% We take the voltage for each point and translate it into pressure
Pac_3 = Y3_max./Sensibility;
% We also calculate the reference pressure for calculation of dB
Pref = max(Y3_max)/Sensibility;
% Calculation of the acoustic levels
Lb_3 = 10*log10((Pac_3.^2)/(Pref.^2));
% Maxmimum value in dB
Max3 = max(Lb_3);

% We get the limit's area from the maximum value
LimitArea = find(Lb_3 >= Max3-Limit);
Results = LimitArea(strfind(diff(LimitArea),[1 1 1 1 1 1]));

% If the condition is not set, we record the concerned curve
if isempty(Results)
    Not_good(1,3) = 1;
    % We get the coordinates of the middle point of the limit area
    First_y = Vector_Pos(LimitArea(1));
    Last_y = Vector_Pos(LimitArea(end));
else
    First_y = Vector_Pos(Results(1));
    Last_y = Vector_Pos(Results(end)+6);
end

Values_3 = (First_y+Last_y)/2;
waitbar(0.55,f,'Definition beam axis');

%% Plotting on the second part of the frame 2
Color_blue = [51 153 255]/255;
Color_red = [76 153 0]/255;
Color_purple = [51 0 102]/255;

hold (Graphics_Acoustic, 'on');
plot(Graphics_Acoustic, Vector_Pos, Lb_1, 'Color', Color_blue, 'LineWidth',1.5, 'Tag', 'Depth 1 mm');
plot(Graphics_Acoustic,Vector_Pos, Lb_2, 'Color', Color_red, 'LineWidth',1.5, 'Tag', ['Depth ', num2str(Profondeur_2),' mm']);
plot(Graphics_Acoustic, Vector_Pos, Lb_3, 'Color', Color_purple, 'LineWidth',1.5, 'Tag', ['Depth ', num2str(Profondeur_3),' mm']);
hold (Graphics_Acoustic, 'off');

% Labels for axis
ylabel(Graphics_Acoustic, 'Niveau de pression acoustique [dB]');
xlabel(Graphics_Acoustic, 'Longueur limite [mm]');
xlim([0 max(Vector_Pos)+5]);

% Legend
legend(Graphics_Acoustic, 'Profondeur 1 mm', ['Profondeur ',num2str(Profondeur_2),' mm'], ['Profondeur ',num2str(Profondeur_3),' mm']);

if any(Not_good)
    % Displaying a warning message
    %     Index = find(Not_good == 1);
    warndlg(['La condition des sept points cons',char(233),'cutifs n',char(39),'est pas respect',char(233),'e pour au moins une des trois courbes.' ...
        'Veuillez modifier les valeurs entr',char(233),'es dans l',char(39),'interface.']);
    guiPRT.Rectangle.BackgroundColor = 'red';
    stop_process = 'on';
else
    % Everything is OK
    guiPRT.Rectangle.BackgroundColor = 'green';
    stop_process = 'off';
end

%% Finding the linear curve equation from all curves
waitbar(0.58,f,'Definition beam axis');
% Concatenation of all positions for all depths
Middle_pos = [Values_1; Values_2; Values_3];
Depth = [1; Profondeur_2; Profondeur_3];

% Square fitting of the center of each raster scan
coefficients = polyfit(Depth, Middle_pos, 1);
% Beam axis equation
yFitted = polyval(coefficients, Depth);

% We plot the fitted curve and the limit length on the right side graphic's area
plot(Graphics_Middle_Pos, Depth, yFitted, 'Color', Color_blue, 'LineWidth',1.5);
plot(Graphics_Middle_Pos, Depth, Middle_pos, 's', 'MarkerSize',10,...
    'MarkerEdgeColor','red',...
    'MarkerFaceColor',[1 .6 .6])

% Labels for axis
xlabel(Graphics_Middle_Pos, 'Profondeur [mm]');
ylabel(Graphics_Middle_Pos, 'Longueur limite [mm]');

% Saving the equation in the structure
% STRUCT_PRT_Data.Definition_Beam.Middle_pos = Middle_pos;
STRUCT_PRT_Data.Definition_Beam.coefficients = coefficients;
% STRUCT_PRT_Data.Definition_Beam.yFitted = yFitted;
end