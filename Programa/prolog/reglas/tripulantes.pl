/*
    Archivo: tripulantes.pl
    Descripcion: Reglas relacionadas con el rescate de tripulantes.
    Autores: Jareck Levell C.
    Fecha: 30/05/2026
*/

/*
    rescatar
    Entradas: Tripulante.
    Salidas: Muestra un mensaje de exito o fallo.
    Restricciones: El jugador debe estar en el mismo modulo que el tripulante,
                   el tripulante debe estar atrapado y los sistemas requeridos deben funcionar.
    Objetivo: Cambiar el estado de un tripulante de atrapado a rescatado.
*/

rescatar(Tripulante) :-
    tripulante(Tripulante, _, _, rescatado),
    write('Este tripulante ya fue rescatado: '),
    write(Tripulante),
    nl,
    !.

rescatar(Tripulante) :-
    jugador(ModuloActual),
    tripulante(Tripulante, ModuloActual, SistemasNecesarios, atrapado),
    sistemas_funcionan(SistemasNecesarios),
    retract(tripulante(Tripulante, ModuloActual, SistemasNecesarios, atrapado)),
    asserta(tripulante(Tripulante, ModuloActual, SistemasNecesarios, rescatado)),
    write('Tripulante rescatado: '),
    write(Tripulante),
    nl,
    !.

rescatar(Tripulante) :-
    write('No se puede rescatar este tripulante ahora: '),
    write(Tripulante),
    nl,
    fail.


/*
    mostrar_tripulantes_rescatados
    Salidas: Muestra todos los tripulantes rescatados.
    Objetivo: Mostrar un resumen de la tripulacion rescatada.
*/

mostrar_tripulantes_rescatados :-
    tripulante(Tripulante, _, _, rescatado),
    write('- '),
    write(Tripulante),
    nl,
    fail.

mostrar_tripulantes_rescatados.