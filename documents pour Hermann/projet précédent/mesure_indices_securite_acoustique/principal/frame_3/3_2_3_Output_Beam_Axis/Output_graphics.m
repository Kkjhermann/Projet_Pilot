function Output_graphics(STRUCT_PRT_Data, Graphics_Acoustic, Graphics_Middle_Pos, f)
% *************************************************************************
%   Name : Output_graphics
%   Date : 07/03/2022
% *************************************************************************

%% Beam_height (y)
PPI_y = cell2mat(STRUCT_PRT_Data.Output_beam_area.Beam_height.PPI_dB);
Ly = cell2mat(STRUCT_PRT_Data.Output_beam_area.Beam_height.Distance);

%% Beam_length (x)
PPI_x = cell2mat(STRUCT_PRT_Data.Output_beam_area.Beam_length.PPI_dB);
Lx = cell2mat(STRUCT_PRT_Data.Output_beam_area.Beam_length.Distance);
waitbar(0.9, f, 'Displaying the graphics');

%% Plotting on the second part of the frame 2
Color_blue = [51 153 255]/255;
plot(Graphics_Acoustic, Ly, PPI_y, 'Color', Color_blue, 'LineWidth',1.5, 'Tag', 'PPI(y)');
% Labels for axis
ylabel(Graphics_Acoustic, 'PPI [dB]');
xlabel(Graphics_Acoustic, 'Longueur limite en Y [mm]');
xlim([0 max(Ly)+5]);
waitbar(0.95, f, 'Displaying the graphics');

Color_red = [76 153 0]/255;
plot(Graphics_Middle_Pos, Lx, PPI_x, 'Color', Color_red, 'LineWidth',1.5, 'Tag', 'PPI(x)');
% Labels for axis
ylabel(Graphics_Middle_Pos, 'PPI [dB]');
xlabel(Graphics_Middle_Pos, 'Longueur limite en X [mm]');
xlim([0 max(Lx)+5]);

waitbar(1, f, 'End of process');
close(f);
end