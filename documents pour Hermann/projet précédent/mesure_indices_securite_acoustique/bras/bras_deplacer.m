function bras_deplacer( x, y, z )
%bras_deplacer deplacer un ou des axes
%   TODO

global bras_posMax bras_posMin

bras_posMin = [-50 -50 -50]';
bras_posMax = [95 195 95]';

%vitF=50.0;

if nargin ~= 3
    fprintf(2, 'move(x, y, z)\n');
    fprintf(2, 'exemple: move(0,0,10)\n');
    return;
end

if isempty(bras_posMax) || isempty(bras_posMin)
    fprintf(2, 'Erreur : position maximale et/ou minimale inconnue');
    return;
end

% set target mode : 1 is absolute - 0 is relative
calllib('ps35','PS35_SetTargetMode', 1, 1, 0);
calllib('ps35','PS35_SetTargetMode', 1, 2, 0);
calllib('ps35','PS35_SetTargetMode', 1, 3, 0);

[ pos1, pos2, pos3 ] = bras_position;

if ~isempty(x)
    % coerce to max
    if x>=0
        x(pos1+x>bras_posMax(1)) = bras_posMax(1);
        % coerce to min
    else
        x(pos1+x<bras_posMin(1)) = bras_posMin(1);
    end
    
    % move
    fprintf('x=%f\n',x)
    calllib('ps35','PS35_MoveEx', 1, 1, x, 1);
end

if ~isempty(y)
    % coerce to max
    if y>=0
        y(pos2+y>bras_posMax(2)) = bras_posMax(2);
        % coerce to min
    else
        y(pos2+y<bras_posMin(2)) = bras_posMin(2);
    end
    
    % move
    fprintf('y=%f\n',y)
    calllib('ps35','PS35_MoveEx', 1, 2, y, 1);
end

if ~isempty(z)
    % coerce to max
    %
    % coerce to max
    if z>=0
        z(pos3+z>bras_posMax(3)) = bras_posMax(3);
        % coerce to min
    else
        z(pos2+z<bras_posMin(3)) = bras_posMin(3);
    end
    
    % move
    fprintf('z=%f\n',z)
    calllib('ps35','PS35_MoveEx', 1, 3, z, 1);
end
end