function [Y, T, XUNIT, YUNIT, HEADER] = osc_getWaveform(nChannel)
%osc_getWaveform choper le train d'onde
%   Cette fonction a pour but de r�cup�rer l'int�gralit� du signal affich�
%   par l'osciloscope. Elle prend en param�tre le num�ro de la channel
%   d�sir�e et retourne le vecteur [Y, T, XUNIT, YUNIT, HEADER].
%
%   Y : Vecteur des ordonn�es des points
%   T : Vecteur des abscisses des points
%   XUNIT : Caract�res donnant l'unit� des abscisses
%   YUNIT : Caract�res donnant l'unit� des ordonn�es
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