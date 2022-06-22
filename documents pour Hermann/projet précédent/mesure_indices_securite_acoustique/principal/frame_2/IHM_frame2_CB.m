function IHM_frame2_CB(srcObj, ~, ~, Button)
% *************************************************************************
%   Name :   IHM_frame2_CB
%   Date : 04/11/2021
% *************************************************************************

figObj = ancestor(srcObj, 'figure');
STRUCT_PRT = getappdata(figObj,'STRUCT_PRT');
STRUCT_PRT_Data = getappdata(figObj,'STRUCT_PRT_Data');
guiPRT = getappdata(figObj,'gui_frame2');

switch Button
    %% Profondeur 2
    case 'Profondeur_2'
        Profondeur_2 = str2double(guiPRT.Profondeur_2.String);
        
        if ~isnan(Profondeur_2)
        else
            warndlg(['La valeur n''est pas num',char(233),'rique ou correcte !']);
            guiPRT.Profondeur_2.String = 0;
        end
        
        if Profondeur_2 <= 1
            warndlg(['La valeur de profondeur 2 ne peut être inf',char(233),'rieure ',char(224),' 1']);
        end
        
        % Rectangle in white
        guiPRT.Rectangle.BackgroundColor = 'white';
        
        %% Profondeur 3
    case 'Profondeur_3'
        Profondeur_3 = str2double(guiPRT.Profondeur_3.String);
        
        if ~isnan(Profondeur_3)
        else
            warndlg(['La valeur n''est pas num',char(233),'rique ou correcte !']);
            guiPRT.Profondeur_3.String = 0;
        end
        
        if Profondeur_3 <= 1
            warndlg(['La valeur de profondeur 2 ne peut être inf',char(233),'rieure ',char(224),' 1']);
        end
        
        % Rectangle in white
        guiPRT.Rectangle.BackgroundColor = 'white';
        
        %% Pas
    case 'Pas'
        Pas = str2double(guiPRT.Pas.String);
        
        if ~isnan(Pas)
        else
            warndlg(['La valeur n''est pas num',char(233),'rique ou correcte !']);
            guiPRT.Pas.String = 0;
        end
        
        if Pas <= 0
            warndlg(['Le pas ne peut ',char(234),'tre inf',char(233),'rieure ',char(224),' 0']);
        end
        
        % Rectangle in white
        guiPRT.Rectangle.BackgroundColor = 'white';
        
        %% Longueur_limite
    case 'Longueur_limite'
        Longueur_limite = str2double(guiPRT.Longueur_limite.String);
        
        if ~isnan(Longueur_limite)
        else
            warndlg(['La valeur n''est pas num',char(233),'rique ou correcte !']);
            guiPRT.Longueur_limite.String = 0;
        end
        
        if Longueur_limite <= 0
            warndlg(['La longueur limite ne peut ',char(234),'tre inf',char(233),'rieure ',char(224),' 0']);
        end
        
        % Rectangle in white
        guiPRT.Rectangle.BackgroundColor = 'white';
        
        %% Reset
    case 'Reset'
        % Reset des valeurs des edit box à la valeur 0
        guiPRT.Pas.String = 0;
        guiPRT.Profondeur_2.String = 0;
        guiPRT.Profondeur_3.String = 0;
        guiPRT.Longueur_limite.String = 0;
        guiPRT.Rectangle.BackgroundColor = 'white';
        
        %% Retour en arriere
    case 'Retour'
        
        % Ouverture de la nouvelle fenêtre IHM
        gui_frame1 = getappdata(figObj,'gui_frame1');
        gui_frame1.framePanel_up.Visible = 'on';
        gui_frame1.framePanel_down.Visible = 'on';
        
        guiPRT.framePanel_up.Visible = 'off';
        guiPRT.framePanel_down.Visible = 'off';
        setappdata(figObj,'gui_frame1',gui_frame1);
        
        %% Execute
    case 'Execute'
        
        Pas = str2double(guiPRT.Pas.String);
        Longueur_limite = str2double(guiPRT.Longueur_limite.String);
        Profondeur_2 = str2double(guiPRT.Profondeur_2.String);
        Profondeur_3 = str2double(guiPRT.Profondeur_3.String);
        
        if Longueur_limite/Pas < 7
            warndlg(['Attention ! Il n''y a pas assez de valeurs pour ',char(233),'tablir les bonnes courbes. Veuillez modifier la longueur limite et/ou le pas.']);
            return
        end
        
        % Test sur toutes les edit boxes
        Flag = Test_edit(Pas, Longueur_limite, Profondeur_2, Profondeur_3);
        if Flag == 1
            return
        end
        
        %         f = waitbar(0,'Please wait...','windowstyle', 'modal', 'CreateCancelBtn', @pushbutton1_Callback);
        %         setappdata(f, 'cancel_callback', 0);
        f = waitbar(0,'Please wait...');
        
        gui_frame1 = getappdata(figObj,'gui_frame1');
        nChannel = str2double(gui_frame1.Oscillo.String);
        Graphics_Acoustic = guiPRT.Graphics_Acoustic;
        Graphics_Middle_Pos = guiPRT.Graphics_Middle_Pos;
        Sensibility = str2double(gui_frame1.Sensibility_hydro.String);
        guiPRT.Rectangle.BackgroundColor = 'white';
        
        % Clear graphic's area
        if ~isempty(Graphics_Acoustic.Children)
            cla(Graphics_Middle_Pos);
            cla(Graphics_Acoustic);
        end
        
        % We get the initial position of the hydrophone
        [pos1, pos2, pos3] = bras_position;
        STRUCT_PRT_Data.Output_beam.Initial_pos.PosX = pos1;
        STRUCT_PRT_Data.Output_beam.Initial_pos.PosY = pos2;
        STRUCT_PRT_Data.Output_beam.Initial_pos.PosZ = pos3;
        
        % We also reset the stored data in order to avoid any overnumber of columns
        STRUCT_PRT_Data.Definition_Beam.Profondeur_1 = [];
        STRUCT_PRT_Data.Definition_Beam.Profondeur_2 = [];
        STRUCT_PRT_Data.Definition_Beam.Profondeur_3 = [];
        
        guiPRT.ISPTA_text.Visible = 'off';
        guiPRT.ISPTA.Visible = 'off';
        guiPRT.ISPTA.String = '';
        guiPRT.MI_text.Visible = 'off';
        guiPRT.MI.Visible = 'off';
        guiPRT.MI.String = '';
        guiPRT.Suivant.Enable = 'off';
        
        %% Definition of beam axis (3.2.2)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Scans et récupération des données
        waitbar(0.1,f,'Scanning');
        [STRUCT_PRT_Data, f] = Scanning(STRUCT_PRT_Data, Pas, Longueur_limite, Profondeur_2, Profondeur_3, nChannel, f);
        % Niveaux de pression acoustique et tracés
        waitbar(0.42,f,'Definition beam axis');
        [STRUCT_PRT_Data, f, stop_process] = Definition_beam_axis(STRUCT_PRT_Data, guiPRT, Graphics_Acoustic, Graphics_Middle_Pos, Sensibility, Profondeur_2, Profondeur_3, Pas, Longueur_limite, f);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        if strcmp(stop_process, 'on')
            close(f);
            return
        end
        
        %% Derated time_averaged intensity integral and depth of the maximum derated intensity z3 (3.2.4)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Calcul de l'intégrale de l'intensité dérivée du temps
        waitbar(0.58,f,'Depth of the maximum derated intensity z3');
        [STRUCT_PRT_Data, ISPTA_max, f] = Intensity_integral(STRUCT_PRT_Data, Profondeur_3, Sensibility, nChannel, Longueur_limite, f);
        % Displaying the ISPTA value on the HMI
        guiPRT.ISPTA_text.Visible = 'on';
        guiPRT.ISPTA.Visible = 'on';
        guiPRT.ISPTA.String = round(ISPTA_max,3);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %% Mechanical index MI (3.2.5)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        waitbar(0.97,f,'Mechanical index');
        [STRUCT_PRT_Data, MI, f] = Mechanical_index(STRUCT_PRT_Data, Sensibility, Profondeur_3, Pas, f);
        waitbar(1,f,'End of all processings');
        close(f);
        % Displaying the MI value on the HMI
        guiPRT.MI_text.Visible = 'on';
        guiPRT.MI.Visible = 'on';
        guiPRT.MI.String = round(MI,3);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Enabling on the "Next" pushbutton
        guiPRT.Suivant.Enable = 'on';
        
        %% Suivant ("Next")
    case 'Suivant'
        % Ouverture de la nouvelle fenêtre IHM
        gui_frame3 = getappdata(figObj,'gui_frame3');
        gui_frame3.framePanel_up.Visible = 'on';
        gui_frame3.framePanel_down.Visible = 'on';
        gui_frame3.Execute.Enable = 'on';
        guiPRT.framePanel_up.Visible = 'off';
        guiPRT.framePanel_down.Visible = 'off';
        setappdata(figObj,'gui_frame3',gui_frame3);
end

%% Save the structure
setappdata(figObj,'STRUCT_PRT',STRUCT_PRT);
setappdata(figObj,'STRUCT_PRT_Data',STRUCT_PRT_Data);
setappdata(figObj,'guiPRT', guiPRT);
end