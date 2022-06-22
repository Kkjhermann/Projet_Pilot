function IHM_frame1_CB(srcObj, ~, ~, Button)
% *************************************************************************
%   Name :   IHM_frame1_CB
%   Date : 21/10/2021
% *************************************************************************

figObj = ancestor(srcObj, 'figure');
STRUCT_PRT = getappdata(figObj,'STRUCT_PRT');
STRUCT_Data = getappdata(figObj,'STRUCT_PRT_Data');
gui_frame1 = getappdata(figObj,'gui_frame1');

switch Button
    %% Oscilloscope ID
    case 'Oscillo_port'
        Oscillo_val = str2double(gui_frame1.Oscillo_port.String);
        
        % Fermeture du port
        osc_fermerPort;
        
        if ~isnan(Oscillo_val)
        else
            warndlg('Le port n''est pas correct !');
            gui_frame1.Oscillo_port.String = '128.0.254.2';
        end
        gui_frame1 = Reset_panneau(gui_frame1);
        
        %% Bras initial
    case 'Bras_ini'
        Bras_val = str2double(gui_frame1.Bras.String);
        if ~isnan(Bras_val)
        else
            warndlg(['La valeur n''est pas num',char(233),'rique ou correcte !']);
            gui_frame1.Bras.String = 15;
        end
        gui_frame1 = Reset_panneau(gui_frame1);
        
        %% Number_oscillo
    case 'Number_oscillo'
        Oscillo_val = str2double(gui_frame1.Oscillo.String);
        if ~isnan(Oscillo_val)
            if Oscillo_val < 1 || Oscillo_val > 4
                warndlg('Cette valeur est comprise entre 1 et 4.');
                gui_frame1.Oscillo.String = 1;
            else
                gui_frame1.Oscillo.String = round(Oscillo_val);
            end
        else
            warndlg(['La valeur n''est pas num',char(233),'rique ou correcte !']);
            gui_frame1.Oscillo.String = 1;
        end
        gui_frame1 = Reset_panneau(gui_frame1);
        
        %% Sensibility_hydro
    case 'Sensibility_hydro'
        
        Hydro_val = str2double(gui_frame1.Sensibility_hydro.String);
        if ~isnan(Hydro_val)
            if Hydro_val < 0
                warndlg(['La valeur doit ',char(234),'tre positive.']);
                gui_frame1.Sensibility_hydro.String = 0.1954;
            end
        else
            warndlg(['La valeur n''est pas num',char(233),'rique ou correcte !']);
            gui_frame1.Sensibility_hydro.String = 0.1954;
        end
        gui_frame1 = Reset_panneau(gui_frame1);
        
        %% Pulse_duration
    case 'Pulse_duration'
        
        Pulse = str2double(gui_frame1.Pulse_duration.String);
        if ~isnan(Pulse)
            if Pulse < 0
                warndlg(['La valeur doit ',char(234),'tre positive.']);
                gui_frame1.Pulse_duration.String = 1;
            end
            STRUCT_Data.Pulse_duration = Pulse;
        else
            warndlg(['La valeur n''est pas num',char(233),'rique ou correcte !']);
            gui_frame1.Pulse_duration.String = 1;
        end
        gui_frame1 = Reset_panneau(gui_frame1);
        
        %% Temperature
    case 'Temperature'
        
        Temp = str2double(gui_frame1.Temperature.String);
        if ~isnan(Temp)
            if Temp < 0
                warndlg(['La valeur doit ',char(234),'tre positive.']);
                gui_frame1.Temperature.String = 16;
                
            elseif Temp < 14 || Temp > 28
                warndlg(['La valeur doit ',char(234),'tre comprise entre 14 et 28°C.']);
                gui_frame1.Temperature.String = 16;
            end
            
            % Calling the temperature's table script
            [Extrap_Rho, Extrap_speed, Rho_speed] = Temperature_calculation(STRUCT_Data, Temp);
            
            % Creating a table
            Input_temperature = Temp;
            Extrapolated_water_density = Extrap_Rho;
            Extrapolated_sound_speed = Extrap_speed;
            Acoustic_Imp = Rho_speed;
            Temp_table = table(Input_temperature, Extrapolated_water_density, Extrapolated_sound_speed, Acoustic_Imp);
            % Saving all values in the structure
            STRUCT_Data.Temperature_calculation = Temp_table;
        else
            warndlg(['La valeur n''est pas num',char(233),'rique ou correcte !']);
            gui_frame1.Temperature.String = 16;
        end
        gui_frame1 = Reset_panneau(gui_frame1);
        
        %% PRF
    case 'PRF'
        
        PRF_Val = str2double(gui_frame1.PRF.String);
        if ~isnan(PRF_Val)
            if PRF_Val < 0
                warndlg(['La valeur doit ',char(234),'tre positive.']);
                gui_frame1.PRF.String = 0;
            end
            STRUCT_Data.PRF = PRF_Val;
        else
            warndlg(['La valeur n''est pas num',char(233),'rique ou correcte !']);
            gui_frame1.PRF.String = 0;
        end
        gui_frame1 = Reset_panneau(gui_frame1);
        
        %% Validation
    case 'Validation'
        
        if ~isempty(gui_frame1.Oscillo_port.String) && ~isempty(gui_frame1.Bras.String)
            f = waitbar(0,'Please wait...','windowstyle', 'modal');
            % Connexion avec l'oscilloscope
            osc_ouvrirPort(gui_frame1.Oscillo_port.String); % osc_ouvrirPort(ipAddress)
            waitbar(0.33,f,'Connecting to the oscilloscope');
            % Connexion avec le bras
            bras_ouvrirPort(str2double(gui_frame1.Bras.String)); % Port 15
            waitbar(0.50,f,'Connecting to the system');
            gui_frame1.Rectangle.BackgroundColor = 'green';
            
            % Activation
            waitbar(0.98,f,'Done');
            gui_frame1.Axe_X.Enable = 'on';
            gui_frame1.Axe_Y.Enable = 'on';
            gui_frame1.Axe_Z.Enable = 'on';
            gui_frame1.Move_button.Enable = 'on';
            gui_frame1.Lancement.Enable = 'on';
            gui_frame1.Reset_button.Enable = 'on';
            waitbar(1,f,'Done');
            close(f);
        else
            gui_frame1 = Reset_panneau(gui_frame1);
        end
        
        %% Axe X
    case 'Axe_X'
        Value = str2double(gui_frame1.Axe_X.String);
        if ~isempty(gui_frame1.Axe_X.String)
            if isnan(Value)
                gui_frame1.Axe_X.String = STRUCT_Data.Alignement.Position_relative(1,1);
                warndlg(['Valeur non num',char(233),'rique !']);
            else
                % Saving the new value
                STRUCT_Data.Alignement.Position_relative(1,1)= Value;
            end
        else
            gui_frame1.Axe_X.String = STRUCT_Data.Alignement.Position_relative(1,1);
        end
        
        %% Axe Y
    case 'Axe_Y'
        Value = str2double(gui_frame1.Axe_Y.String);
        if ~isempty(gui_frame1.Axe_Y.String)
            if isnan(Value)
                gui_frame1.Axe_Y.String = STRUCT_Data.Alignement.Position_relative(1,2);
                warndlg(['Valeur non num',char(233),'rique !']);
            else
                % Saving the new value
                STRUCT_Data.Alignement.Position_relative(1,2) = Value;
            end
        else
            gui_frame1.Axe_Y.String = STRUCT_Data.Alignement.Position_relative(1,2);
        end
        
        %% Axe Z
    case 'Axe_Z'
        Value = str2double(gui_frame1.Axe_Z.String);
        if ~isempty(gui_frame1.Axe_Y.String)
            if isnan(Value)
                gui_frame1.Axe_Z.String = STRUCT_Data.Alignement.Position_relative(1,3);
                warndlg(['Valeur non num',char(233),'rique !']);
            else
                % Saving the new value
                STRUCT_Data.Alignement.Position_relative(1,3) = Value;
            end
        else
            gui_frame1.Axe_Z.String = STRUCT_Data.Alignement.Position_relative(1,3);
        end
        
        %% Reset des valeurs des edits
    case 'Reset'
        % Réinitialisation des valeurs à zéro
        gui_frame1.Axe_X.String = 0;
        gui_frame1.Axe_Y.String = 0;
        gui_frame1.Axe_Z.String = 0;
        STRUCT_Data.Alignement.Position_relative(1,1) = 0;
        STRUCT_Data.Alignement.Position_relative(1,2) = 0;
        STRUCT_Data.Alignement.Position_relative(1,3) = 0;
        
        %% Deplacement du bras
    case ['D',char(233),'placement']
        % Alignement du bras
        x = STRUCT_Data.Alignement.Position_relative(1,1);
        y = STRUCT_Data.Alignement.Position_relative(1,2);
        z = STRUCT_Data.Alignement.Position_relative(1,3);
        bras_deplacer(x, y, z);
        [pos1,pos2,pos3] = bras_position;
        STRUCT_Data.Alignement.Position_absolue = [pos1,pos2,pos3];
        
        %% Lancement des calculs
    case 'Lancement'
        % Ouverture de la nouvelle fenêtre IHM
        gui_frame2 = getappdata(figObj,'gui_frame2');
        gui_frame1.framePanel_up.Visible = 'off';
        gui_frame1.framePanel_down.Visible = 'off';
        gui_frame2.framePanel_up.Visible = 'on';
        gui_frame2.framePanel_down.Visible = 'on';
        gui_frame2.Suivant.Enable = 'off';
        setappdata(figObj,'gui_frame2',gui_frame2);
end

%% Save the structure
setappdata(figObj,'STRUCT_PRT',STRUCT_PRT);
setappdata(figObj,'STRUCT_PRT_Data',STRUCT_Data);
setappdata(figObj,'gui_frame1',gui_frame1);
end