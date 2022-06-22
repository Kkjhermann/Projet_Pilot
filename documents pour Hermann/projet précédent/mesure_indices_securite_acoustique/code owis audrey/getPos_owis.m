function getPos_owis(ps35)

for i = 1:3
    fprintf(ps35,['?ENCPOS' num2str(i)])
    idn = fscanf(ps35);
    disp(['axe ' num2str(i) ' = ' idn]);
end
end