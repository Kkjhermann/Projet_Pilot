function IHM_START
% *************************************************************************
%   Name :   IHM_START
%   Date de création : 21/10/2021
%   Description : Création de l'IHM principal
% *************************************************************************
% Position
position_figure = [ .14, .23, .7, .6];

% Creation of the window
num_figure = handle(...
    figure('Name','Safety index measurements',...
    'Integerhandle','off',...
    'HandleVisibility','on',...
    'numbertitle','off',...
    'menubar',  'none',...
    'Units','normalized',...
    'position',position_figure,...
    'visible',  'on',...
    'SelectionType', 'open',...
    'WindowStyle',  'Normal',...
    'toolbar','none')...
    );

STRUCT_PRT.figure.num_figure = num_figure;

%If the screen is small, we reduce the police and affect it to the controls
%and axes
screen_size = get(0,'screensize');
if screen_size(4) < 769
    font_size = 7;
else
    font_size = 9;
end

set(num_figure,'defaultuicontrolfontsize',font_size);
set(num_figure,'defaulttextfontsize',font_size);
set(num_figure,'defaultuipanelfontsize',font_size);
set(num_figure,'defaulttextfontsize',font_size);
set(num_figure,'defaultuicontrolunits','normalized');

%% Panel Tabs :
% Main Color
MainColor = [0.9400 0.9400 0.9400];

% Left panel for tabs
widthLeftTab = 0;

% Main panel
STRUCT_PRT.figure.START.panel_ihm = uipanel(num_figure,...
    'FontSize',12,...
    'Visible','on',...
    'BackgroundColor',MainColor,...
    'position',[widthLeftTab 0 1-widthLeftTab 1]);

%% Creation of the menus (Help for example)
STRUCT_PRT = IHM_MENU(num_figure,STRUCT_PRT);

%% Creation of the frame
% Frame 1
[gui_frame1] = IHM_frame1(STRUCT_PRT);
STRUCT_PRT.figure.frame_1_up = gui_frame1.framePanel_up;
STRUCT_PRT.figure.frame_1_down = gui_frame1.framePanel_down;

% Frame 2
[gui_frame2] = IHM_frame2(STRUCT_PRT);
STRUCT_PRT.figure.frame_2_up = gui_frame2.framePanel_up;
STRUCT_PRT.figure.frame_2_down = gui_frame2.framePanel_down;

% Frame 3
[gui_frame3] = IHM_frame3(STRUCT_PRT);
STRUCT_PRT.figure.frame_3_up = gui_frame3.framePanel_up;
STRUCT_PRT.figure.frame_3_down = gui_frame3.framePanel_down;

% Frame 4
[gui_frame4] = IHM_frame4(STRUCT_PRT);
STRUCT_PRT.figure.frame_4_up = gui_frame4.framePanel_up;
STRUCT_PRT.figure.frame_4_down = gui_frame4.framePanel_down;

% Saving
setappdata(num_figure,'gui_frame1',gui_frame1);
setappdata(num_figure,'gui_frame2',gui_frame2);
setappdata(num_figure,'gui_frame3',gui_frame3);
setappdata(num_figure,'gui_frame4',gui_frame4);

%% Creation of the main structure
Main =  struct('Alignement', [], 'Definition_Beam', [], 'Output_beam', [],'Temperature_table', []);
Main.Alignement.Position_relative = zeros(1,3);

% Temperature_table
Temp_table = Temperature_table;
Main.Temperature_table = Temp_table;

% Initial position of the hydrophone
PosX = 0;
PosY = 0;
PosZ = 0;
Initial_Pos = table(PosX, PosY, PosZ);
Main.Output_beam.Initial_pos = Initial_Pos;

% Calling the temperature's table script
Temp = 16;
[Extrap_Rho, Extrap_speed, Rho_speed] = Temperature_calculation(Main, Temp);

% Creating a table
Input_temperature = Temp;
Extrapolated_water_density = Extrap_Rho;
Extrapolated_sound_speed = Extrap_speed;
Acoustic_Imp = Rho_speed;
Temp_table = table(Input_temperature, Extrapolated_water_density, Extrapolated_sound_speed, Acoustic_Imp);
% Saving all values in the structure
Main.Temperature_calculation = Temp_table;

% Pulse duration
Main.Pulse_duration = 3.0e-07;
% PRF by default
Main.PRF = 333;

% We save these inside two different structures
setappdata(num_figure,'STRUCT_PRT_Data',Main);

%% Save the structure
setappdata(num_figure,'STRUCT_PRT', STRUCT_PRT);
end