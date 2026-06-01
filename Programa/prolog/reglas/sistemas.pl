/*
    Archivo: sistemas.pl
    Descripcion: Reglas relacionadas con la reparacion y consulta de sistemas.
    Autores: Ginger Rodriguez G.
    Fecha: 30/05/2026
*/

/*
    reparar
    Entradas: Sistema.
    Salidas: Muestra un mensaje de exito o fallo.
    Restricciones: El jugador debe estar en el modulo correcto, tener los artefactos necesarios
                   y el sistema debe estar en fallo.
    Objetivo: Cambiar el estado de un sistema de fallo a restaurado.
*/

reparar(Sistema) :-
    sistema(_, Sistema, _, restaurado),
    write('Este sistema ya fue reparado: '),
    write(Sistema),
    nl,
    !.

reparar(Sistema) :-
    jugador(ModuloActual),
    sistema(ModuloActual, Sistema, ArtefactosNecesarios, fallo),
    artefactosLogrados(ListaArtefactos),
    todos_en_lista(ArtefactosNecesarios, ListaArtefactos),
    retract(sistema(ModuloActual, Sistema, ArtefactosNecesarios, fallo)),
    asserta(sistema(ModuloActual, Sistema, ArtefactosNecesarios, restaurado)),
    write('Sistema reparado: '),
    write(Sistema),
    nl,
    !.

reparar(Sistema) :-
    write('No se puede reparar este sistema ahora: '),
    write(Sistema),
    nl,
    fail.


/*
    sistemas_funcionan
    Entradas: ListaSistemas.
    Salidas: verdadero si todos los sistemas de la lista estan restaurados.
    Restricciones: La entrada debe ser una lista de sistemas.
    Objetivo: Validar condiciones necesarias para rescatar tripulantes o avanzar.
*/

sistemas_funcionan([]).

sistemas_funcionan([Sistema|Resto]) :-
    sistema(_, Sistema, _, restaurado),
    sistemas_funcionan(Resto).


/*
    mostrar_sistemas_reparados
    Salidas: Muestra todos los sistemas que estan restaurados.
    Objetivo: Mostrar un resumen de sistemas reparados.
*/

mostrar_sistemas_reparados :-
    sistema(_, Sistema, _, restaurado),
    write('- '),
    write(Sistema),
    nl,
    fail.

mostrar_sistemas_reparados.