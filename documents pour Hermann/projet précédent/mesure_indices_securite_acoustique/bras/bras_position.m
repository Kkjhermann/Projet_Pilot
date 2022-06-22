function [ pos1, pos2, pos3 ] = bras_position
%bras_position obtenir la position absolue du bras
%   TODO

pos1 = calllib('ps35','PS35_GetPositionEx', 1, 1);
pos2 = calllib('ps35','PS35_GetPositionEx', 1, 2);
pos3 = calllib('ps35','PS35_GetPositionEx', 1, 3);
end