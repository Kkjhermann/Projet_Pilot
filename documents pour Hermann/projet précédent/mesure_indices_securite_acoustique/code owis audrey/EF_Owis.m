function EF_Owis()

ps35 = evalin('base','ps35');
pts = evalin('base','pts_inc');

disp('Displacement of the probe');

global A

if isempty(A)
    A = 1;
else
    A = A + 1;
end


disp(A)


for i = 1:2
    fprintf(ps35,['?ENCPOS' num2str(i)])
    idn = fscanf(ps35);
    N = pts(i,A) - str2double(idn);
    disp(['axe ' num2str(i) ' = ' idn]);
    disp(N)
    fprintf(ps35,['INIT' num2str(i)])
    fprintf(ps35,['RELAT' num2str(i)])
    fprintf(ps35,['PSET' num2str(i) '=' num2str(N)]);
    fprintf(ps35,['PGO' num2str(i)]);
    pause(.5)
end

end
