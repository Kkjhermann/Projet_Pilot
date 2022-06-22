function STRUCT_PRT = IHM_MENU(num_figure, STRUCT_PRT)
% *************************************************************************
%   Name :   IHM_MENU
%   Date de création : 03/11/2021
%   Description : Menu avec options (réinitialiser et quitter)
% *************************************************************************
%MENU Reset
STRUCT_PRT.figure.uimenu.menu_reset=uimenu(num_figure,'Label',['R',char(233),'initialiser']);

%Sub category
STRUCT_PRT.figure.uimenu.Reset=uimenu(STRUCT_PRT.figure.uimenu.menu_reset,...
    'Label',['R',char(233),'initialiser'],...
    'Callback',{@IHM_START_CB,num_figure,'Reset'});

%MENU Quitter
STRUCT_PRT.figure.uimenu.menu_exit=uimenu(num_figure,'Label','Quitter');

%Sub category
STRUCT_PRT.figure.uimenu.menu_exit=uimenu(STRUCT_PRT.figure.uimenu.menu_exit,...
    'Label','Quitter',...
    'Callback',{@IHM_START_CB,num_figure,'Exit'});
end