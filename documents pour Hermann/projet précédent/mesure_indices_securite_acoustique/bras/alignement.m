% ce script permet de réaliser l'alignement de l'hydropone avec la sonde.
% Il est supposé que l'utilisateur suive la procédure de la brochure
% investigateur et que l'hydrophone soit placé à 1 mm de la sonde et environ
% au centre de la sonde dans la direction latérale.

%% Initialisation de variables

% vitessse de propagation des ondes ultrasonores dans l'eau
c = 1540;

% position initiale des trois axes du banc mise à zéro
% posX = 0;
% posY = 0;
% posZ = 0;

% pas de deplacement
pasX = 0.5; % pour anticiper étape 4

% %% Ajout des fonctions banc et oscilloscope
% addpath ('bras/');
% addpath ('oscilloscope/');

%% Ouverture de la communication avec le contrôleur OWIS du banc

% récupération du numéro du port de communication connecté au contrôleur
% OWIS
num_COM= input ('n\ entrer le n° du port de communication : \n');

% Etablissement de la communication
bras_ouvrirPort( num_COM );

%% Placement de l'hydrophone à la séparation champ proche / champ lointain
% L'hydrophone aura été préalablement placé au plus près de la sonde

% le calcul de la distance de fresnel se fait dans un tableau excel à part

dist_fresnel = input ('n\ Entrer la distance de Fresnel en mm \n');

deplacement_fresnel = - dist_fresnel;

% déplacement de l'hydrophone à la distance de la zone de Fesnel

bras_deplacer( 0, 0, deplacement_fresnel );

%% 1er scan dans la direction latérale

% récupération de la longueur totale à scanner

long_x = input ('n\ Indiquer en mm la longueur totale dans la direction latérale à scanner \n');

%récupération de la position de l'axe X

[ posX, posY, posZ ] = bras_position ;

% déplacement de l'axe X à la première extrémité. On estime que via la
% procédure l'hydrophone est placé à peu près au milieu de la sonde dans la
% dimension latérale
% calcul de la position extrême
ext_x1 = posX + long_x/2;

% vérification de la non atteinte de la butée
if ext_x1 >= 100
    long_x = fprintf ('\n Attention butée max axe X atteinte - diminuer la longueur totale à scanner ou quitter la procédure alignement pour modifier emplacement sonde et/ou hydrophone \n');
    ext_x1 = posX + long_x/2;
end

%déplacement

bras_deplacer( ext_x1, 0, 0); %% revoir si il faut intégrer dans la procédure globale le deplacement reference pour utiliser la fonction bras_deplacer + voir si on fonctionne en absolu

% récupération des données et recherche du maximum
% ouverture de la communication avec l'oscilloscope
osc_ouvrirPort('128.0.254.2');
channel = input ('n\ Indiquer le n° de voie de oscilloscope pour récupérer les données \n');

% récupérer la waveform et trouver le max - vérifier que mettre le trigger
% de l'échographe suffit.
nb_pas_x = round(long_x/pasX);

%allocation vecteur_max
maxX=zeros(1,nb_pas_x);

for ii=0:nb_pas_x
    [Y, ~, ~, ~, ~] = osc_getWaveform(channel);
    maxX(1,ii+1)=max(Y);
    bras_deplacer(pasX, 0, 0);
    clear Y T XUNIT YUNIT HEADER
end