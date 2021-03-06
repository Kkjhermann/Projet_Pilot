function IHM_frame4_CB(srcObj, ~, ~, Button)
% *************************************************************************
%   Name :   IHM_frame4_CB
%   Date : 14/03/2022
% *************************************************************************

figObj = ancestor(srcObj, 'figure');
STRUCT_PRT = getappdata(figObj,'STRUCT_PRT');
STRUCT_PRT_Data = getappdata(figObj,'STRUCT_PRT_Data');
guiPRT = getappdata(figObj,'gui_frame4');

switch Button
    
    %% Retour
    case 'Retour'
        % Ouverture de la nouvelle fen?tre IHM
        gui_frame3 = getappdata(figObj,'gui_frame3');
        gui_frame3.framePanel_up.Visible = 'on';
        gui_frame3.framePanel_down.Visible = 'on';
        
        % We disable the "Execute pushbutton" in order to avoid any problem
        gui_frame3.Suivant.Enable = 'off';
        gui_frame3.Execute.Enable = 'off';
        
        guiPRT.framePanel_up.Visible = 'off';
        guiPRT.framePanel_down.Visible = 'off';
        setappdata(figObj,'gui_frame4',guiPRT);
        
        %% Execute
    case 'Execute'
        %% We launch a new raster scan along Y and X axis
        f = waitbar(0,'Please wait...');
        gui_frame1 = getappdata(figObj,'gui_frame1');
        nChannel = str2double(gui_frame1.Oscillo.String);
        Sensibility = str2double(gui_frame1.Sensibility_hydro.String);
        
        gui_frame2 = getappdata(figObj,'gui_frame2');
        Longueur_limite_Y = str2double(gui_frame2.Longueur_limite.String);
        
        gui_frame3 = getappdata(figObj,'gui_frame3');
        Longueur_limite_X = str2double(gui_frame3.Longueur_limite.String);
        
        Graphics_Left_Side = guiPRT.Graphics_Acoustic;
        Graphics_Right_Side = guiPRT.Graphics_Middle_Pos;
        % Clear graphic's area
        if ~isempty(Graphics_Left_Side.Children)
            cla(Graphics_Left_Side);
            cla(Graphics_Right_Side);
        end
        
        % Recovering the initial position
        PosY = STRUCT_PRT_Data.Output_beam.Initial_pos.PosY;

        % Current position of the hydrophone
        [~, CurrPosY, ~] = bras_position;

        % Setting the new position of Y-axis depending on Limit_length_X
        % and Breakpoint depth in Z
        %New_Pos_Y = CurrPosY - (Longueur_limite_Y/2);
        New_Pos_Y = PosY-CurrPosY;
        New_Pos_Z = STRUCT_PRT_Data.Output_beam_area.Breakpoint_depth;
        %bras_deplacer(0, New_Pos_Y, -New_Pos_Z);
        bras_deplacer(0, -New_Pos_Y, -New_Pos_Z);

        
        % Launching the dedicated script for the processing
        STRUCT_PRT_Data = AP_scanning(STRUCT_PRT_Data, Longueur_limite_Y, Longueur_limite_X, nChannel, Sensibility);
        
        %% Export
    case 'Export'
        % Exporting the main structure in .mat file where the user wants
        matpath = uigetdir;
        if matpath ~= 0
            %             time = datestr(now, '_yyyy_mm_dd');
            %             filename = sprintf('STRUCT_PRT_Data%s.mat',time);
            %             save(matpath,'STRUCT_PRT_Data');
            save('STRUCT_PRT_Data');
        end
end

%% Save the structure
setappdata(figObj,'STRUCT_PRT',STRUCT_PRT);
setappdata(figObj,'STRUCT_PRT_Data',STRUCT_PRT_Data);
setappdata(figObj,'guiPRT', guiPRT);
end