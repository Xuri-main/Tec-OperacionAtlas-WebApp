/*
    Archivo: main.pl
    Descripcion: Archivo principal que carga los hechos y las reglas del juego.
    Autores: Emilio Funes R. , Ginger Rodriguez G. & Jareck Levell C.
    Fecha: 29/05/2026
*/

% Predicados dinamicos del estado del juego.
:- dynamic jugador/1.
:- dynamic artefactosLogrados/1.
:- dynamic artefactoUsado/1.
:- dynamic visitado/1.
:- dynamic historialModulos/1.
:- dynamic sistema/4.
:- dynamic tripulante/4.

% Carga de hechos y reglas.
:- consult('hechos.pl').
:- consult('reglas.pl').