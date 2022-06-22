function osc_ouvrirPort(ipAddress)
%osc_ouvrirPort commencer la comm avec l'osc
%   Cette fonction doit être appelée avant d epouvoir utiliser les outils
%   de la bibliothèque 'oscilloscope'. Elle permet d'initialiser la
%   communication entre matlab et l'oscilloscope. Elle prend en paramètre
%   l'adresse IP de l'oscilloscope qui peut etre récupérer dans l'onglet
%   "Utilities" -> "Utilities Setup" -> "Remote". Ce parametre s'écrit de
%   la forme " '128.0.254.2' ".
%   Exemple d'appel de la fonction :  osc_ouvrirPort('128.0.254.2')

global deviceObj interfaceObj

% Create a TCPIP object.
interfaceObj = instrfind('Type', 'tcpip', 'RemoteHost', ipAddress, 'RemotePort', 1861, 'Tag', '');

% Create the TCPIP object if it does not exist
% otherwise use the object that was found.
if isempty(interfaceObj)
    interfaceObj = tcpip(ipAddress, 1861);
else
    fclose(interfaceObj);
    interfaceObj = interfaceObj(1);
end

% Create a device object.
deviceObj = icdevice('lecroy_basic_driver.mdd', interfaceObj);

end