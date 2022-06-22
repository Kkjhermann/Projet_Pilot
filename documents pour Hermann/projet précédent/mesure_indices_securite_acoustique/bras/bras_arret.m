function bras_arret( in1 )
%bras_arret arreter un ou tout les axes
%   TODO

if nargin == 0
    calllib('ps35','PS35_Stop',1,1);
    calllib('ps35','PS35_Stop',1,2);
    calllib('ps35','PS35_Stop',1,3);
else
    calllib('ps35','PS35_Stop',1,in1);
end