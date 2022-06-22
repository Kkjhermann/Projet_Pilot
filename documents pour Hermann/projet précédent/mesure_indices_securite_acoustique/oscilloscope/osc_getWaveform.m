function [Y, T, XUNIT, YUNIT, HEADER] = osc_getWaveform(nChannel)
%osc_getWaveform choper le train d'onde
%   Cette fonction a pour but de récupérer l'intégralité du signal affiché
%   par l'osciloscope. Elle prend en paramètre le numéro de la channel
%   désirée et retourne le vecteur [Y, T, XUNIT, YUNIT, HEADER].
%
%   Y : Vecteur des ordonnées des points
%   T : Vecteur des abscisses des points
%   XUNIT : Caractères donnant l'unité des abscisses
%   YUNIT : Caractères donnant l'unité des ordonnées
%   HEADER : ???
%
%   Exemple d'appel de la fonction :  [Y, T, XUNIT, YUNIT, HEADER] = osc_getWaveform(1)
%
%   PS : Un plot(T,Y) redonne l'affichage de l'oscilloscope dans une figure.


global deviceObj

connect(deviceObj);
groupObj = get(deviceObj, 'Waveform');
[Y, T, XUNIT, YUNIT, HEADER] = invoke(groupObj, 'readwaveform', strcat('channel',int2str(nChannel)));
disconnect(deviceObj);

end