/*
    Archivo: hechos.pl
    Descripcion: Base de conocimiento inicial del juego. Define modulos, enlaces, artefactos,
                 sistemas, tripulantes, restricciones, objetivos y estado inicial.
    Autores: Emilio Funes R. , Ginger Rodriguez G. & Jareck Levell C.
    Fecha: 29/05/2026
*/

% -------------------------
% Modulos del juego
% modulo(Nombre, Descripcion)
% -------------------------

modulo(puente_mando, "Centro principal de control de la estacion.").
modulo(laboratorio, "Laboratorio cientifico con herramientas y piezas sueltas.").
modulo(enfermeria, "Area medica de emergencia de la estacion.").
modulo(modulo_energia, "Modulo encargado del suministro energetico.").
modulo(centro_comunicaciones, "Modulo encargado de las comunicaciones externas.").
modulo(modulo_escape, "Zona final de evacuacion orbital.").

% -------------------------
% Enlaces entre modulos
% enlace(Modulo1, Modulo2)
% -------------------------

enlace(puente_mando, laboratorio).
enlace(puente_mando, enfermeria).
enlace(laboratorio, modulo_energia).
enlace(laboratorio, centro_comunicaciones).
enlace(centro_comunicaciones, modulo_escape).

% -------------------------
% Artefactos
% artefacto(Artefacto, Modulo)
% -------------------------

artefacto(tarjeta_seguridad, puente_mando).
artefacto(fusible, laboratorio).
artefacto(traje_espacial, enfermeria).

% -------------------------
% Sistemas reparables
% sistema(Modulo, Sistema, ListaArtefactosNecesarios, Estado)
% -------------------------

sistema(modulo_energia, energia, [fusible], fallo).
sistema(centro_comunicaciones, comunicaciones, [tarjeta_seguridad], fallo).

% -------------------------
% Tripulantes
% tripulante(Nombre, Modulo, ListaSistemasNecesarios, Estado)
% -------------------------

tripulante(elena, modulo_energia, [energia], atrapado).
tripulante(kai, modulo_escape, [energia, comunicaciones], atrapado).

% -------------------------
% Restricciones de acceso por artefacto
% necesita(ModuloDestino, Artefacto)
% -------------------------

necesita(modulo_energia, traje_espacial).
necesita(modulo_escape, tarjeta_seguridad).

% -------------------------
% Restricciones de acceso por estado
% necesitaEstado(ModuloDestino, Sistema, EstadoNecesario)
% -------------------------

necesitaEstado(modulo_escape, energia, restaurado).

% -------------------------
% Restricciones por pasos previos
% pasoPrevio(ModuloDestino, ModuloPrevio)
% -------------------------

pasoPrevio(modulo_escape, centro_comunicaciones).

% -------------------------
% Condiciones de gane
% objetivoS(Sistema, Estado)
% objetivoT(Tripulante, Estado)
% -------------------------

objetivoS(energia, restaurado).
objetivoS(comunicaciones, restaurado).

objetivoT(elena, rescatado).
objetivoT(kai, rescatado).

% -------------------------
% Estado inicial
% -------------------------

jugador(puente_mando).

artefactosLogrados([]).

historialModulos([puente_mando]).

visitado(puente_mando).