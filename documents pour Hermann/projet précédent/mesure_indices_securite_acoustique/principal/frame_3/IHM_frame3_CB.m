function IHM_frame3_CB(srcObj, ~, ~, Button)
% *************************************************************************
%   Name :   IHM_frame3_CB
%   Date : 07/03/2022
% *************************************************************************

figObj = ancestor(srcObj, 'figure');
STRUCT_PRT = getappdata(figObj,'STRUCT_PRT');
STRUCT_PRT_Data = getappdata(figObj,'STRUCT_PRT_Data');
guiPRT = getappdata(figObj,'gui_frame3');

switch Button
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
        
        %% Reset
    case 'Reset'
        % Reset des valeurs des edit box à la valeur 0
        guiPRT.Longueur_limite.String = 0;
        
        %% Retour en arriere
    case 'Retour'
        
        % Ouverture de la nouvelle fenêtre IHM
        gui_frame2 = getappdata(figObj,'gui_frame2');
        gui_frame2.framePanel_up.Visible = 'on';
        gui_frame2.framePanel_down.Visible = 'on';
        
        guiPRT.framePanel_up.Visible = 'off';
        guiPRT.framePanel_down.Visible = 'off';
        setappdata(figObj,'gui_frame2',gui_frame2);
        
        %% Execute
    case 'Execute'
        gui_frame2 = getappdata(figObj,'gui_frame2');
        Longueur_limite_Y = str2double(gui_frame2.Longueur_limite.String);
        Longueur_limite_X = str2double(guiPRT.Longueur_limite.String);
        
        gui_frame1 = getappdata(figObj,'gui_frame1');
        nChannel = str2double(gui_frame1.Oscillo.String);
        Sensibility = str2double(gui_frame1.Sensibility_hydro.String);
        
        if Longueur_limite_X == 0
            warndlg(['La longueur limite ne peut ',char(234),'tre inf',char(233),'rieure ',char(224),' 0']);
            return
        end
        
        Switch_on = 'off';
        guiPRT.Output_area.Visible = Switch_on;
        guiPRT.Aperture_diameter.Visible = Switch_on;
        guiPRT.Bkpt_depth.Visible = Switch_on;
        guiPRT.Output_area_edit.Visible = Switch_on;
        guiPRT.Aperture_diameter_edit.Visible = Switch_on;
        guiPRT.Bkpt_depth_edit.Visible = Switch_on;
        guiPRT.Export.Visible = Switch_on;
        
        f = waitbar(0,'Please wait...');
        Graphics_Acoustic = guiPRT.Graphics_Acoustic;
        Graphics_Middle_Pos = guiPRT.Graphics_Middle_Pos;
        % Clear graphic's area
        if ~isempty(Graphics_Acoustic.Children)
            cla(Graphics_Middle_Pos);
            cla(Graphics_Acoustic);
        end
        
        % Recovering the initial position
        PosY = STRUCT_PRT_Data.Output_beam.Initial_pos.PosY;
        % Current position of the hydrophone
        [~, CurrPosY, ~] = bras_position;
        % Making the difference
        bras_deplacer(0, -(CurrPosY-PosY), 0);
        
        % Launching the dedicated script for the processing
        waitbar(0.1,f,'Scanning along Y');
        [STRUCT_PRT_Data, f] = Output_beam_axis(STRUCT_PRT_Data, Longueur_limite_Y, Longueur_limite_X, nChannel, Sensibility, f);
        
        % Displaying the following graphics (PPIx = f(L) and PPIy = f(L))
        waitbar(0.85, f, 'Displaying the graphics');
        Output_graphics(STRUCT_PRT_Data, Graphics_Acoustic, Graphics_Middle_Pos, f);
        
        % Displaying the edit boxes for visual information
        Switch_on = 'on';
        guiPRT.Output_area.Visible = Switch_on;
        guiPRT.Aperture_diameter.Visible = Switch_on;
        guiPRT.Bkpt_depth.Visible = Switch_on;
        guiPRT.Output_area_edit.Visible = Switch_on;
        guiPRT.Aperture_diameter_edit.Visible = Switch_on;
        guiPRT.Bkpt_depth_edit.Visible = Switch_on;
        guiPRT.Export.Visible = Switch_on;
        guiPRT.Suivant.Visible = Switch_on;
        
        guiPRT.Output_area_edit.String = STRUCT_PRT_Data.Output_beam_area.Output_area;
        guiPRT.Aperture_diameter_edit.String = STRUCT_PRT_Data.Output_beam_area.Aperture_diameter;
        guiPRT.Bkpt_depth_edit.String = STRUCT_PRT_Data.Output_beam_area.Breakpoint_depth;
        
        %% Suivant
    case 'Suivant'
        % Ouverture de la nouvelle fenêtre IHM
        gui_frame4 = getappdata(figObj,'gui_frame4');
        gui_frame4.framePanel_up.Visible = 'on';
        gui_frame4.framePanel_down.Visible = 'on';
        guiPRT.framePanel_up.Visible = 'off';
        guiPRT.framePanel_down.Visible = 'off';
        setappdata(figObj,'gui_frame4',gui_frame4);
end

%% Save the structure
setappdata(figObj,'STRUCT_PRT',STRUCT_PRT);
setappdata(figObj,'STRUCT_PRT_Data',STRUCT_PRT_Data);
setappdata(figObj,'guiPRT', guiPRT);
end