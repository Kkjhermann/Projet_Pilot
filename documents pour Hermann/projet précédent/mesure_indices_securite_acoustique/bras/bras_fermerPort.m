function bras_fermerPort
%bras_fermerPort arreter la communication avec le bras
%   TODO

calllib('ps35','PS35_Disconnect',1);
unloadlibrary ps35
end