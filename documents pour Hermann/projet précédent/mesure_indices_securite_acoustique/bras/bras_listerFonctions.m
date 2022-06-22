function bras_listerFonctions
%bras_listerFonctions afficher toute les fonctions du bras (voir doc)
%   TODO

if not(libisloaded('ps35'))
    loadlibrary('ps35', 'ps35.h')
end
libfunctionsview ps35

end