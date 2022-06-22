function [guiPRT] = IHM_frame3(STRUCT_PRT)
% *************************************************************************
%   Name :   IHM_frame3
%   Date of creation : 07/03/2022
%   Description : Creation of the menus in the main window
% *************************************************************************

Parent = STRUCT_PRT.figure.START.panel_ihm;
num_figure = STRUCT_PRT.figure.num_figure;
PanelColor = [0.815686274509804	0.878431372549020 0.921568627450980];
Off_sight = 'on';

%% Principal Panel
guiPRT.framePanel_up = uipanel(Parent,...
    'visible', 'off',...
    'BackgroundColor',PanelColor,...
    'Title', ('Output beam area'),...
    'FontSize',11,...
    'position',[0 0.6 1.*1/0.86 1-0.6]);

guiPRT.framePanel_down = uipanel(Parent,...
    'visible', 'off',...
    'BackgroundColor',PanelColor,...
    'Title', ('Graphics'),...
    'FontSize',11,...
    'position',[0 0 1.*1/0.86 0.7]);

%% Elements graphiques
PosX_edit = 0.25;
PosY = 0.65;

% Reset
guiPRT.Reset = uicontrol(guiPRT.framePanel_up,...
    'style', 'pushbutton',...
    'Units','normalized',...
    'FontSize',11,...
    'position',[PosX_edit PosY 0.15 0.25],...
    'Callback',{@IHM_frame3_CB,num_figure,'Reset'},...
    'Value',0,...
    'String','Reset');

% Retour en arri�re
guiPRT.Retour = uicontrol(guiPRT.framePanel_up,...
    'style', 'pushbutton',...
    'Units','normalized',...
    'FontSize',11,...
    'position',[PosX_edit+0.2 PosY 0.15 0.25],...
    'Callback',{@IHM_frame3_CB,num_figure,'Retour'},...
    'Value',0,...
    'String',['Retour en arri',char(232),'re']);

% Ex�cuter
guiPRT.Execute = uicontrol(guiPRT.framePanel_up,...
    'style', 'pushbutton',...
    'Units','normalized',...
    'FontSize',11,...
    'position',[PosX_edit+0.4 PosY 0.15 0.25],...
    'Callback',{@IHM_frame3_CB,num_figure,'Execute'},...
    'Value',0,...
    'String',['Ex',char(233),'cuter']);

% Suivant (Next)
guiPRT.Suivant = uicontrol(guiPRT.framePanel_up,...
    'style', 'pushbutton',...
    'Units','normalized',...
    'FontSize',11,...
    'Visible', Off_sight,...
    'position',[PosX_edit+0.4 PosY-0.35 0.15 0.25],...
    'Callback',{@IHM_frame3_CB,num_figure,'Suivant'},...
    'Value',0,...
    'String','Suivant');

%%
PosY = 0.93;
PosX_edit = 0.035;
Length_edit = 0.12;

% Longueur de scan limite
uicontrol(guiPRT.framePanel_up,...
    'style', 'text',...
    'Units','normalized',...
    'Visible','on',...
    'FontSize',11,...
    'HorizontalAlignment','Center',...
    'position',[PosX_edit-0.01 PosY-0.12 0.2 0.12],...
    'BackgroundColor', PanelColor,...
    'String','Longueur limite en x [mm]');

% Longueur de scan limite edit box
guiPRT.Longueur_limite = uicontrol(guiPRT.framePanel_up,...
    'style','edit',...
    'units','normalized',...
    'FontSize',11,...
    'BackgroundColor','w',...
    'Callback',{@IHM_frame3_CB,num_figure,'Longueur_limite'},...
    'String', '0',...
    'Position',[PosX_edit+0.03 PosY-0.15-0.12 Length_edit 0.14]);

%%
PosY = 0.43;
% Output area
guiPRT.Output_area = uicontrol(guiPRT.framePanel_up,...
    'style', 'text',...
    'Units','normalized',...
    'Visible','on',...
    'FontSize',11,...
    'HorizontalAlignment','Center',...
    'position',[PosX_edit-0.01 PosY 0.2 0.12],...
    'BackgroundColor', PanelColor,...
    'Visible', Off_sight,...
    'String','Surface ouverture [m�]');

% Output area edit box
guiPRT.Output_area_edit = uicontrol(guiPRT.framePanel_up,...
    'style','edit',...
    'units','normalized',...
    'FontSize',11,...
    'Enable', 'inactive',...
    'BackgroundColor','w',...
    'String', '0',...
    'Visible', Off_sight,...
    'Position',[PosX_edit+0.03 PosY-0.03-0.12 Length_edit 0.14]);

PosX_edit = 0.23;
% Aperture diameter
guiPRT.Aperture_diameter = uicontrol(guiPRT.framePanel_up,...
    'style', 'text',...
    'Units','normalized',...
    'Visible','on',...
    'FontSize',11,...
    'HorizontalAlignment','Center',...
    'position',[PosX_edit-0.01 PosY 0.2 0.12],...
    'BackgroundColor', PanelColor,...
    'Visible', Off_sight,...
    'String',['Diam',char(232),'tre ouverture [m]']);

% Aperture diameter edit box
guiPRT.Aperture_diameter_edit = uicontrol(guiPRT.framePanel_up,...
    'style','edit',...
    'units','normalized',...
    'FontSize',11,...
    'Enable', 'inactive',...
    'BackgroundColor','w',...
    'String', '0',...
    'Visible', Off_sight,...
    'Position',[PosX_edit+0.03 PosY-0.03-0.12 Length_edit 0.14]);

PosX_edit = PosX_edit+0.2050;
% Breakpoint depth
guiPRT.Bkpt_depth = uicontrol(guiPRT.framePanel_up,...
    'style', 'text',...
    'Units','normalized',...
    'Visible','on',...
    'FontSize',11,...
    'HorizontalAlignment','Center',...
    'position',[PosX_edit-0.01 PosY 0.2 0.12],...
    'BackgroundColor', PanelColor,...
    'Visible', Off_sight,...
    'String','Profondeur breakpoint [m]');

% Breakpoint depth edit box
guiPRT.Bkpt_depth_edit = uicontrol(guiPRT.framePanel_up,...
    'style','edit',...
    'units','normalized',...
    'FontSize',11,...
    'Enable', 'inactive',...
    'BackgroundColor','w',...
    'String', '0',...
    'Visible', Off_sight,...
    'Position',[PosX_edit+0.03 PosY-0.03-0.12 Length_edit 0.14]);

%% Graphics part
guiPRT.Graphics_Acoustic = axes(guiPRT.framePanel_down,...
    'units','normalized',...
    'Visible','on',...
    'OuterPosition',[0 0 1-0.55 1]);

guiPRT.Graphics_Middle_Pos = axes(guiPRT.framePanel_down,...
    'units','normalized',...
    'Visible','on',...
    'OuterPosition',[1-0.6 0 1-0.55 1]);

STRUCT_PRT.figure.frame3_up = guiPRT.framePanel_up;
STRUCT_PRT.figure.frame3_down = guiPRT.framePanel_down;
end