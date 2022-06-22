function bras_ouvrirPort( COM )
%bras_ouvrirPort commencer la communication avec le bras
%   TODO

if nargin ~= 1
    fprintf(2, 'init(COM_PORT)\n');
    fprintf(2, 'exemple: init(13)\n');
    return
end

% set parameters *************
if ischar(COM) == 0
    nComPort=int32(COM);
else
    nComPort=int32(str2double(COM));
end
% ****************************

if not(libisloaded('ps35'))
    loadlibrary('ps35', 'ps35.h')
end

% open virtual serial interface
calllib('ps35','PS35_Connect', 1, 0, nComPort, 9600, 0, 0, 8, 0);

% initialize axis
calllib('ps35','PS35_MotorInit', 1, 1);
calllib('ps35','PS35_MotorInit', 1, 2);
calllib('ps35','PS35_MotorInit', 1, 3);

end