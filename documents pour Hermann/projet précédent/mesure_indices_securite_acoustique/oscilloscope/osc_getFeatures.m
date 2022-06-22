function [freq, amp, max] = osc_getFeatures(nChannel)
%osc_getFeatures choper des measurements
%   Cette fonction a pour but de récupérer des informations clé sur l'aqcuisition du signal et particulièrement la fréquence et l'amplitude.
%   Elle retourne un vecteur [freq amp].
%   Elle prend en paramètre le numéro de la channel étudiée.
%
%   freq : Valeur de la fréquence mesurée en Hz
%   amp :  Valeur de l'amplitude mesurée en V
%
%   Exemple d'appel de la fonction :  [freq amp] = osc_getFeatures(1)
%
%   PS : On peut de la même manière récupérer les valeurs des mesures suivante:
%             -frequency (done here)
%             -mean
%             -period
%             -peak2peak
%             -crms
%             -amplitude (done here)
%             -area
%             -base


global deviceObj

disconnect(deviceObj);
connect(deviceObj);
set(deviceObj.Measurement(1), 'Source', strcat('channel',int2str(nChannel)));
set(deviceObj.Measurement(1), 'MeasurementType', 'frequency');
freq = get(deviceObj.Measurement(1), 'Value');

set(deviceObj.Measurement(1), 'MeasurementType', 'amplitude');
amp = get(deviceObj.Measurement(1), 'Value');

set(deviceObj.Measurement(1), 'MeasurementType', 'P1');
max = get(deviceObj.Measurement(1), 'Value');

disconnect(deviceObj);
end