/*
    Archivo: artefactos.pl
    Descripcion: Reglas relacionadas con tomar, usar y consultar artefactos.
    Autores: Ginger Rodriguez G.
    Fecha: 29/05/2026
*/

/*
    tomar
    Entradas: Artefacto.
    Salidas: Muestra un mensaje de exito o fallo.
    Restricciones: El artefacto debe estar en el modulo actual y no debe estar ya tomado.
    Objetivo: Agregar un artefacto al inventario del jugador.
*/

tomar(Artefacto) :-
    artefactosLogrados(Lista),
    en_lista(Artefacto, Lista),
    write('Ya tienes este artefacto: '),
    write(Artefacto),
    nl,
    !.

tomar(Artefacto) :-
    jugador(ModuloActual),
    artefacto(Artefacto, ModuloActual),
    artefactosLogrados(Lista),
    retract(artefactosLogrados(Lista)),
    asserta(artefactosLogrados([Artefacto|Lista])),
    write('Artefacto tomado: '),
    write(Artefacto),
    nl,
    !.

tomar(Artefacto) :-
    write('No se puede tomar este artefacto aqui: '),
    write(Artefacto),
    nl,
    fail.


/*
    usar
    Entradas: Artefacto.
    Salidas: Muestra un mensaje de exito o fallo.
    Restricciones: El jugador debe tener el artefacto y no debe haberlo usado antes.
    Objetivo: Registrar que un artefacto fue usado para desbloquear restricciones.
*/

usar(Artefacto) :-
    artefactoUsado(Artefacto),
    write('Este artefacto ya fue usado: '),
    write(Artefacto),
    nl,
    !.

usar(Artefacto) :-
    artefactosLogrados(Lista),
    en_lista(Artefacto, Lista),
    asserta(artefactoUsado(Artefacto)),
    write('Artefacto usado: '),
    write(Artefacto),
    nl,
    !.

usar(Artefacto) :-
    write('No tienes este artefacto, por eso no puedes usarlo: '),
    write(Artefacto),
    nl,
    fail.


/*
    donde_esta
    Entradas: Artefacto.
    Salidas: Muestra el modulo donde se encuentra el artefacto.
    Restricciones: El artefacto debe existir en la base de conocimiento.
    Objetivo: Consultar la ubicacion de un artefacto.
*/

donde_esta(Artefacto) :-
    artefacto(Artefacto, Modulo),
    write('El artefacto '),
    write(Artefacto),
    write(' esta en: '),
    write(Modulo),
    nl,
    !.

donde_esta(Artefacto) :-
    write('No se encontro el artefacto: '),
    write(Artefacto),
    nl,
    fail.


/*
    mostrar_artefactos
    Salidas: Muestra todos los artefactos y sus ubicaciones.
    Objetivo: Listar los artefactos disponibles en el mapa.
*/

mostrar_artefactos :-
    artefacto(Artefacto, Modulo),
    write('- '),
    write(Artefacto),
    write(' esta en '),
    write(Modulo),
    nl,
    fail.

mostrar_artefactos.