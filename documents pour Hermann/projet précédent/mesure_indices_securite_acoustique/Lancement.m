% INITIALISATION Execut� au lancement de l'application
clc;
clear;
close all;

% Ajouter les dossiers et sous-dossiers au chemin de recherche
addpath(genpath(pwd));

% Cr�ation de l'Interface Homme Machine
IHM_START;

% Fermeture de la connexion avec l'oscilloscope
% osc_fermerPort;