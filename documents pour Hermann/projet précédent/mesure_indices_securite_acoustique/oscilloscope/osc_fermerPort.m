function osc_fermerPort
%osc_fermerPort
%   Cette fonciton permet de couper la communication entre l'osciloscope et
%   matlab. Elle ne prend pas de paramètre et doit être appelé en toute fin
%   de programme, après avoir fait les acquisitions souhaitées.
%   Exemple d'appel de la fonction :  osc_fermerPort

global deviceObj interfaceObj

% Disconnect device object from hardware.
disconnect(deviceObj);

% The following code has been automatically generated to ensure that any
% object manipulated in TMTOOL has been properly disposed when executed
% as part of a function or script.

% Clean up all objects.
delete([deviceObj interfaceObj]);
clear groupObj;
clear deviceObj;
clear interfaceObj;

end