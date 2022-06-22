function IHM_START_CB(~,~,~,button)

% *************************************************************************
%   Name :   IHM_START_CB
%   Date de création : 03/11/2021
%   Description : Callback des menus
% *************************************************************************

switch button
    
    %% Quitter l'outil
    case 'Exit'
        anw = questdlg('Voulez vous quitter l''outil ?');
        switch anw
            case 'Yes'
                % Fermeture de la fenêtre actuelle
                clc;
                clear;
                close all;
        end
        
        %% Réinitialiser
    case 'Reset'
        anw = questdlg('Voulez vous relancer l''outil ?');
        switch anw
            case 'Yes'
                % Fermeture de la fenêtre actuelle
                clc;
                clear;
                close all;
                % Relance de l'outil
                IHM_START
                return
        end
end