function [b1, b2, b3] = bras_butee
%bras_butee obtenir l'etat des butee de deplacement
%   TODO

b1 = return_state(calllib('ps35','PS35_GetSwitchState', 1, 1));
b2 = return_state(calllib('ps35','PS35_GetSwitchState', 1, 2));
b3 = return_state(calllib('ps35','PS35_GetSwitchState', 1, 3));

end

function res = return_state(state)
if (state < 1)
    res = 0;
else
    if (state < 4)
        res = -1;
    else
        res = 1;
    end
end
end