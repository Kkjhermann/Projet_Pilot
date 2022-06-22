% ce script permet de r�aliser l'alignement de l'hydropone avec la sonde.
% Il est suppos� que l'utilisateur suive la proc�dure de la brochure
% investigateur et que l'hydrophone soit plac� � 1 mm de la sonde et environ
% au centre de la sonde dans la direction lat�rale.

%% Initialisation de variables

% vitessse de propagation des ondes ultrasonores dans l'eau
c = 1540;

% position initiale des trois axes du banc mise � z�ro
% posX = 0;
% posY = 0;
% posZ = 0;

% pas de deplacement
pasX = 0.5; % pour anticiper �tape 4

% %% Ajout des fonctions banc et oscilloscope
% addpath ('bras/');
% addpath ('oscilloscope/');

%% Ouverture de la communication avec le contr�leur OWIS du banc

% r�cup�ration du num�ro du port de communication connect� au contr�leur
% OWIS
num_COM= input ('n\ entrer le n� du port de communication : \n');

% Etablissement de la communication
bras_ouvrirPort( num_COM );

%% Placement de l'hydrophone � la s�paration champ proche / champ lointain
% L'hydrophone aura �t� pr�alablement plac� au plus pr�s de la sonde

% le calcul de la distance de fresnel se fait dans un tableau excel � part

dist_fresnel = input ('n\ Entrer la distance de Fresnel en mm \n');

deplacement_fresnel = - dist_fresnel;

% d�placement de l'hydrophone � la distance de la zone de Fesnel

bras_deplacer( 0, 0, deplacement_fresnel );

%% 1er scan dans la direction lat�rale

% r�cup�ration de la longueur totale � scanner

long_x = input ('n\ Indiquer en mm la longueur totale dans la direction lat�rale � scanner \n');

%r�cup�ration de la position de l'axe X

[ posX, posY, posZ ] = bras_position ;

% d�placement de l'axe X � la premi�re extr�mit�. On estime que via la
% proc�dure l'hydrophone est plac� � peu pr�s au milieu de la sonde dans la
% dimension lat�rale
% calcul de la position extr�me
ext_x1 = posX + long_x/2;

% v�rification de la non atteinte de la but�e
if ext_x1 >= 100
    long_x = fprintf ('\n Attention but�e max axe X atteinte - diminuer la longueur totale � scanner ou quitter la proc�dure alignement pour modifier emplacement sonde et/ou hydrophone \n');
    ext_x1 = posX + long_x/2;
end

%d�placement

bras_deplacer( ext_x1, 0, 0); %% revoir si il faut int�grer dans la proc�dure globale le deplacement reference pour utiliser la fonction bras_deplacer + voir si on fonctionne en absolu

% r�cup�ration des donn�es et recherche du maximum
% ouverture de la communication avec l'oscilloscope
osc_ouvrirPort('128.0.254.2');
channel = input ('n\ Indiquer le n� de voie de oscilloscope pour r�cup�rer les donn�es \n');

% r�cup�rer la waveform et trouver le max - v�rifier que mettre le trigger
% de l'�chographe suffit.
nb_pas_x = round(long_x/pasX);

%allocation vecteur_max
maxX=zeros(1,nb_pas_x);

for ii=0:nb_pas_x
    [Y, ~, ~, ~, ~] = osc_getWaveform(channel);
    maxX(1,ii+1)=max(Y);
    bras_deplacer(pasX, 0, 0);
    clear Y T XUNIT YUNIT HEADER
end