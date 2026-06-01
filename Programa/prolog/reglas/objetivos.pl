/*
    Archivo: objetivos.pl
    Descripcion: Reglas relacionadas con objetivos del juego, guia de victoria y verificacion de gane.
    Autores: Emilio Funes R.
    Fecha: 30/05/2026
*/

/*
    objetivo_sistema_pendiente
    Salidas: verdadero si existe un sistema objetivo que aun no cumple su estado requerido.
    Objetivo: Detectar si falta reparar algun sistema necesario para ganar.
*/

objetivo_sistema_pendiente :-
    objetivoS(Sistema, Estado),
    not(sistema(_, Sistema, _, Estado)).


/*
    objetivos_sistemas_cumplidos
    Salidas: verdadero si todos los sistemas objetivo estan cumplidos.
    Objetivo: Validar la parte de sistemas de la condicion de victoria.
*/

objetivos_sistemas_cumplidos :-
    not(objetivo_sistema_pendiente).


/*
    objetivo_tripulante_pendiente
    Salidas: verdadero si existe un tripulante objetivo que aun no cumple su estado requerido.
    Objetivo: Detectar si falta rescatar algun tripulante necesario para ganar.
*/

objetivo_tripulante_pendiente :-
    objetivoT(Tripulante, Estado),
    not(tripulante(Tripulante, _, _, Estado)).


/*
    objetivos_tripulantes_cumplidos
    Salidas: verdadero si todos los tripulantes objetivo estan cumplidos.
    Objetivo: Validar la parte de tripulantes de la condicion de victoria.
*/

objetivos_tripulantes_cumplidos :-
    not(objetivo_tripulante_pendiente).


/*
    mostrar_objetivos_sistemas
    Salidas: Muestra los sistemas requeridos para ganar.
    Objetivo: Informar los objetivos de sistemas.
*/

mostrar_objetivos_sistemas :-
    objetivoS(Sistema, Estado),
    write('- Sistema '),
    write(Sistema),
    write(' debe estar en estado: '),
    write(Estado),
    nl,
    fail.

mostrar_objetivos_sistemas.


/*
    mostrar_objetivos_tripulantes
    Salidas: Muestra los tripulantes requeridos para ganar.
    Objetivo: Informar los objetivos de tripulantes.
*/

mostrar_objetivos_tripulantes :-
    objetivoT(Tripulante, Estado),
    write('- Tripulante '),
    write(Tripulante),
    write(' debe estar en estado: '),
    write(Estado),
    nl,
    fail.

mostrar_objetivos_tripulantes.


/*
    como_gano
    Salidas: Muestra una guia general de los objetivos y recursos disponibles.
    Objetivo: Orientar al jugador sobre como completar el juego.
*/

como_gano :-
    write('Para ganar debe cumplir estos objetivos:'), nl,
    write('Sistemas objetivo:'), nl,
    mostrar_objetivos_sistemas,
    write('Tripulantes objetivo:'), nl,
    mostrar_objetivos_tripulantes,
    write('Artefactos disponibles en el mapa:'), nl,
    mostrar_artefactos,
    write('Puede usar ruta(Inicio, Fin, Camino) para buscar caminos posibles.'), nl.


/*
    verifica_gane
    Salidas: Muestra si se alcanzo o no la condicion de victoria.
    Restricciones: Deben cumplirse todos los objetivos de sistemas y tripulantes.
    Objetivo: Verificar la condicion final de victoria del juego.
*/

verifica_gane :-
    objetivos_sistemas_cumplidos,
    objetivos_tripulantes_cumplidos,
    write('CONDICION DE VICTORIA ALCANZADA'), nl,
    write('Ruta realizada: '), nl,
    historialModulos(Ruta),
    write(Ruta), nl,
    write('Lista final de artefactos logrados: '), nl,
    artefactosLogrados(Artefactos),
    write(Artefactos), nl,
    write('Sistemas reparados: '), nl,
    mostrar_sistemas_reparados,
    write('Tripulacion rescatada: '), nl,
    mostrar_tripulantes_rescatados,
    !.

verifica_gane :-
    write('Todavia no se cumplen todas las condiciones de victoria.'), nl,
    fail.