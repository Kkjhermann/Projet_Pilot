function bras_deplacementReference
%bras_deplacementReference chercher les limites de déplacement
%   TODO

global bras_posMax bras_posMin

bras_posMin = [0 0 0]';
bras_posMax = [100 100 100]';

% initialisation
bras_posMaxTemp = [0 0 0]';

% Arreter le mouvement du bras
calllib('ps35','PS35_Stop',1,1);
calllib('ps35','PS35_Stop',1,2);
calllib('ps35','PS35_Stop',1,3);

% mode 6 :
%   approach max ref switch
% & approach min ref switch
% & stop & set act. position to "0"
%calllib('ps35','PS35_GoRef', 1, axis, 6) % Ab j'ai remplacé dans le code
%initial axis par le numéro des axes
calllib('ps35','PS35_GoRef', 1, 1, 6)
calllib('ps35','PS35_GoRef', 1, 2, 6)
calllib('ps35','PS35_GoRef', 1, 3, 6)
m = bras_estEnMouvement();

% boucle
while any(m)
    % axe 1
    if m(1)
        p = calllib('ps35','PS35_GetPositionEx', 1, 1);
        if p > bras_posMaxTemp(1)
            bras_posMaxTemp(1) = p;
        end
    end
    
    % axe 2
    if m(2)
        p = calllib('ps35','PS35_GetPositionEx', 1, 2);
        if p > bras_posMaxTemp(2)
            bras_posMaxTemp(2) = p;
        end
    end
    
    %axe 3
    if m(3)
        p = calllib('ps35','PS35_GetPositionEx', 1, 3);
        if p > bras_posMaxTemp(3)
            bras_posMaxTemp(3) = p;
        end
    end
    
    % mise à jour de la condition
    m = bras_estEnMouvement();
end

% Marge de sécurité : 1mm
bras_posMaxTemp = bras_posMaxTemp - 1;

bras_posMin = [0 0 0]';
bras_posMax = bras_posMaxTemp;
end