function Flag = Test_edit(Pas, Longueur_limite, Profondeur_2, Profondeur_3)
% *************************************************************************
%   Name : Test_edit
%   Date : 17/11/2021
% *************************************************************************

Flag = 0;

if Profondeur_2 <= 1
    warndlg(['La valeur de profondeur 2 ne peut être inf',char(233),'rieure ',char(224),' 1']);
    Flag = 1;
    return
end

if  Profondeur_3 <= Profondeur_2
    warndlg(['La profondeur 3 doit toujours ',char(234),'tre sup',char(233),'rieure ',char(224),' la profondeur 2']);
    Flag = 1;
    return
end

if Pas <= 0 || Longueur_limite <= 0
    warndlg(['Le pas et la longueur limite ne peuvent ',char(234),'tre inf',char(233),'rieure ',char(224),' 0']);
    Flag = 1;
    return
end

end