function [pts_mm, pts_inc] = get_grid(step,len,origin)

% Generates all the points in a grid defined
% step : step between each points
% len : total length of the side
% The arrays are given in order of the axes (1,2)

x = -len(1)/2:step(1):len(1)/2;
y = -len(2)/2:step(2):len(2)/2;

pts_mm = zeros([2 (length(x)*length(y))]);
pts_inc = zeros([2 (length(x)*length(y))]);

k = 1;
for i = 1:length(x)
    for j = 1:length(y)
        pts_mm(:,k) = [x(i) y(j)];
        
        pts_inc(:,k) = [origin(1) + x(i)/0.5e-6 , origin(2) + y(j)/0.5e-6];
        
        k = k+1;
    end
end

end