/*
    Archivo: estado.pl
    Descripcion: Reglas relacionadas con el estado general del jugador.
    Autores: Emilio Funes R. , Ginger Rodriguez G. & Jareck Levell C.
    Fecha: 29/05/2026
*/

/*
    donde_estoy
    Salidas: Muestra en pantalla el modulo actual del jugador.
    Objetivo: Informar la ubicacion actual del jugador.
*/

donde_estoy :-
    jugador(Modulo),
    write('Estas en: '),
    write(Modulo),
    nl.


/*
    que_tengo
    Salidas: Muestra en pantalla la lista de artefactos logrados.
    Objetivo: Consultar el inventario actual del jugador.
*/

que_tengo :-
    artefactosLogrados(Lista),
    write('Artefactos logrados: '),
    write(Lista),
    nl.


/*
    modulos_visitados
    Salidas: Muestra en pantalla el historial de modulos visitados.
    Objetivo: Consultar la ruta recorrida por el jugador.
*/

modulos_visitados :-
    historialModulos(Lista),
    write('Modulos visitados: '),
    write(Lista),
    nl.


/*
    registrar_visitado
    Entradas: Modulo.
    Restricciones: Modulo debe ser un modulo valido del juego.
    Objetivo: Registrar un modulo como visitado, evitando duplicados.
*/

registrar_visitado(Modulo) :-
    visitado(Modulo),
    !.

registrar_visitado(Modulo) :-
    asserta(visitado(Modulo)).


/*
    actualizar_historial
    Entradas: Modulo.
    Restricciones: Debe existir historialModulos/1 en la base de conocimiento.
    Objetivo: Agregar el modulo visitado al historial del jugador.
*/

actualizar_historial(Modulo) :-
    historialModulos(Lista),
    agregar_final(Lista, Modulo, NuevaLista),
    retract(historialModulos(Lista)),
    asserta(historialModulos(NuevaLista)).