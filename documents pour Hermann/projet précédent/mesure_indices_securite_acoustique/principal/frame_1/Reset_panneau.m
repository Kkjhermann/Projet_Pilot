function guiPRT = Reset_panneau(guiPRT)

% Rectangle in red
guiPRT.Rectangle.BackgroundColor = 'red';

% Enable the down panel
guiPRT.Axe_X.Enable = 'off';
guiPRT.Axe_Y.Enable = 'off';
guiPRT.Axe_Z.Enable = 'off';
guiPRT.Reset_button.Enable = 'off';
guiPRT.Move_button.Enable = 'off';
guiPRT.Lancement.Enable = 'off';

end