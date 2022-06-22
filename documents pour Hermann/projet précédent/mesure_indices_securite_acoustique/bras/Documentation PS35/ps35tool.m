function retval = ps35tool( in1, in2, in3, in4 )
%ps35tool This is a demo application for the PS 35 controller.
%   retval = ps35tool( COM_port, axis_no, velocity, distance ) moves the attached axis...
%   function parameters 
%   parameter 1 - COM port
%   parameter 2 - axis number
%   parameter 3 - positioning velocity in Hz
%   parameter 4 - distance for positioning in mm, distance=0 - reference run

nComPort=int32(6); 
nAxis=int32(1);
dPosF=30000.0;
dDistance=10.0; 

if nargin ~= 4  
	fprintf(2, 'ps35tool(COM_port, axis_no, velocity, distance)\n');
	fprintf(2, 'e.g. ps35tool(6,1,30000,10)\n');
    return;
end

% set parameters *************
if ischar(in1) == 0
	nComPort=int32(in1);
else
    nComPort=int32(str2double(in1));
end
if ischar(in2) == 0
	nAxis=int32(in2);
else
    nAxis=int32(str2double(in2));
end
if ischar(in3) == 0
	dPosF=int32(in3);
else
    dPosF=str2double(in3);
end
if ischar(in4) == 0
	dDistance=in4;
else
    dDistance=str2double(in4);
end
% ****************************

loadlibrary('ps35','ps35.h')

% open virtual serial interface
calllib('ps35','PS35_Connect', 1, 0, nComPort, 9600, 0, 0, 8, 0);

% define constants for calculation Inc -> mm
% calllib('ps35','PS35_SetStageAttributes', 1, nAxis, 1.0, 200, 1.0);

% initialize axis
calllib('ps35','PS35_MotorInit', 1, nAxis);

% set target mode (0 - relative)
calllib('ps35','PS35_SetTargetMode', 1, nAxis, 0);

% set velocity 
calllib('ps35','PS35_SetPosF', 1, nAxis, dPosF);

% check position
PositionA = calllib('ps35','PS35_GetPositionEx', 1, nAxis);
fprintf(1, 'Position=%.3f\n', PositionA);

% start positioning
if(dDistance==0.0) % go home (to start position)
	calllib('ps35','PS35_GoRef', 1, nAxis, 4);
else % move to target position (+ positive direction, - negative direction)
	calllib('ps35','PS35_MoveEx', 1, nAxis, dDistance, 1);
end

% check move state of the axis
fprintf(1, 'Axis is moving...\n');
while calllib('ps35','PS35_GetMoveState', 1, nAxis) > 0 
end
fprintf(1, 'Axis is in position.\n');

% check position
PositionB = calllib('ps35','PS35_GetPositionEx', 1, nAxis);
fprintf(1, 'Position=%.3f\n', PositionB);
retval = PositionB;

% close interface
calllib('ps35','PS35_Disconnect',1);

unloadlibrary ps35

end

