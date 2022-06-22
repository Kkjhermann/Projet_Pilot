function res = bras_estEnMouvement
%bras_estEnMouvement est-ce que les bras est immobile ?
%   TODO

res = [calllib('ps35','PS35_GetMoveState', 1, 1) > 0; ...
    calllib('ps35','PS35_GetMoveState', 1, 2) > 0; ...
    calllib('ps35','PS35_GetMoveState', 1, 3) > 0;];
end