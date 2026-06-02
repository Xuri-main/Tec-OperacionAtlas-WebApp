/*
    Archivo: control.pl
    Descripcion: Reglas generales de control de partida. Permite consultar el estado actual,
                 ver acciones disponibles, mostrar ayuda y reiniciar el juego.
    Autores: Emilio Funes R. , Ginger Rodriguez G. & Jareck Levell C.
    Fecha: 29/05/2026
*/

/*
    descripcion_modulo_actual
    Salidas: Muestra la descripcion del modulo donde se encuentra el jugador.
    Restricciones: Debe existir jugador/1 y modulo/2 para el modulo actual.
    Objetivo: Mostrar informacion descriptiva del lugar actual del jugador.
*/

descripcion_modulo_actual :-
    jugador(Modulo),
    modulo(Modulo, Descripcion),
    write('Modulo actual: '),
    write(Modulo),
    nl,
    write('Descripcion: '),
    write(Descripcion),
    nl,
    !.

descripcion_modulo_actual :-
    write('No se pudo obtener la descripcion del modulo actual.'),
    nl,
    fail.


/*
    mostrar_artefactos_usados
    Salidas: Muestra los artefactos que ya fueron usados por el jugador.
    Objetivo: Consultar que artefactos ya desbloquearon restricciones.
*/

mostrar_artefactos_usados :-
    not(artefactoUsado(_)),
    write('Ningun artefacto ha sido usado.'),
    nl,
    !.

mostrar_artefactos_usados :-
    artefactoUsado(Artefacto),
    write('- '),
    write(Artefacto),
    nl,
    fail.

mostrar_artefactos_usados.


/*
    mostrar_sistemas_estado_general
    Salidas: Muestra todos los sistemas con su modulo y estado actual.
    Restricciones: Deben existir hechos sistema/4.
    Objetivo: Consultar el estado general de los sistemas de la estacion.
*/

mostrar_sistemas_estado_general :-
    not(sistema(_, _, _, _)),
    write('No hay sistemas registrados.'),
    nl,
    !.

mostrar_sistemas_estado_general :-
    sistema(Modulo, Sistema, _, Estado),
    write('- '),
    write(Sistema),
    write(' en '),
    write(Modulo),
    write(': '),
    write(Estado),
    nl,
    fail.

mostrar_sistemas_estado_general.


/*
    mostrar_tripulantes_estado_general
    Salidas: Muestra todos los tripulantes con su modulo y estado actual.
    Restricciones: Deben existir hechos tripulante/4.
    Objetivo: Consultar el estado general de la tripulacion.
*/

mostrar_tripulantes_estado_general :-
    not(tripulante(_, _, _, _)),
    write('No hay tripulantes registrados.'),
    nl,
    !.

mostrar_tripulantes_estado_general :-
    tripulante(Tripulante, Modulo, _, Estado),
    write('- '),
    write(Tripulante),
    write(' en '),
    write(Modulo),
    write(': '),
    write(Estado),
    nl,
    fail.

mostrar_tripulantes_estado_general.


/*
    estado_juego
    Salidas: Muestra un resumen general del estado actual de la partida.
    Restricciones: Deben existir los predicados de estado principal del juego.
    Objetivo: Dar a la interfaz o al jugador una vista general del progreso actual.
*/

estado_juego :-
    write('========== ESTADO ACTUAL DEL JUEGO =========='), nl,
    descripcion_modulo_actual,
    write('---------------------------------------------'), nl,
    write('Artefactos logrados:'), nl,
    artefactosLogrados(Artefactos),
    write(Artefactos),
    nl,
    write('---------------------------------------------'), nl,
    write('Artefactos usados:'), nl,
    mostrar_artefactos_usados,
    write('---------------------------------------------'), nl,
    write('Modulos visitados:'), nl,
    historialModulos(Historial),
    write(Historial),
    nl,
    write('---------------------------------------------'), nl,
    write('Sistemas:'), nl,
    mostrar_sistemas_estado_general,
    write('---------------------------------------------'), nl,
    write('Tripulantes:'), nl,
    mostrar_tripulantes_estado_general,
    write('============================================='), nl.


/*
    hay_movimiento_disponible
    Salidas: verdadero si existe al menos un modulo al que el jugador puede moverse.
    Objetivo: Saber si se deben mostrar movimientos disponibles.
*/

hay_movimiento_disponible :-
    puedo_ir(_).


/*
    mostrar_movimientos_disponibles
    Salidas: Muestra los modulos a los que el jugador puede moverse actualmente.
    Restricciones: Los destinos deben cumplir puedo_ir/1.
    Objetivo: Mostrar movimientos validos desde la ubicacion actual.
*/

mostrar_movimientos_disponibles :-
    not(hay_movimiento_disponible),
    write('No hay movimientos disponibles actualmente.'),
    nl,
    !.

mostrar_movimientos_disponibles :-
    puedo_ir(Modulo),
    write('- mover('),
    write(Modulo),
    write(')'),
    nl,
    fail.

mostrar_movimientos_disponibles.


/*
    hay_artefacto_disponible
    Salidas: verdadero si hay un artefacto en el modulo actual que no esta en inventario.
    Objetivo: Saber si se deben mostrar artefactos disponibles para tomar.
*/

hay_artefacto_disponible :-
    jugador(Modulo),
    artefacto(Artefacto, Modulo),
    artefactosLogrados(Lista),
    not(en_lista(Artefacto, Lista)).


/*
    mostrar_artefactos_disponibles
    Salidas: Muestra artefactos disponibles para tomar en el modulo actual.
    Restricciones: El artefacto debe estar en el mismo modulo que el jugador.
    Objetivo: Mostrar posibles acciones tomar(Artefacto).
*/

mostrar_artefactos_disponibles :-
    not(hay_artefacto_disponible),
    write('No hay artefactos nuevos para tomar en este modulo.'),
    nl,
    !.

mostrar_artefactos_disponibles :-
    jugador(Modulo),
    artefacto(Artefacto, Modulo),
    artefactosLogrados(Lista),
    not(en_lista(Artefacto, Lista)),
    write('- tomar('),
    write(Artefacto),
    write(')'),
    nl,
    fail.

mostrar_artefactos_disponibles.


/*
    hay_artefacto_para_usar
    Salidas: verdadero si el jugador tiene un artefacto que todavia no ha usado.
    Objetivo: Saber si existen artefactos disponibles para usar.
*/

hay_artefacto_para_usar :-
    artefactosLogrados(Lista),
    en_lista(Artefacto, Lista),
    not(artefactoUsado(Artefacto)).


/*
    mostrar_artefactos_para_usar
    Salidas: Muestra los artefactos del inventario que aun no se han usado.
    Restricciones: El artefacto debe estar en la lista de artefactos logrados.
    Objetivo: Mostrar posibles acciones usar(Artefacto).
*/

mostrar_artefactos_para_usar :-
    not(hay_artefacto_para_usar),
    write('No hay artefactos pendientes de usar.'),
    nl,
    !.

mostrar_artefactos_para_usar :-
    artefactosLogrados(Lista),
    en_lista(Artefacto, Lista),
    not(artefactoUsado(Artefacto)),
    write('- usar('),
    write(Artefacto),
    write(')'),
    nl,
    fail.

mostrar_artefactos_para_usar.


/*
    hay_sistema_reparable
    Salidas: verdadero si hay un sistema que se puede reparar en el modulo actual.
    Objetivo: Saber si se deben mostrar sistemas reparables.
*/

hay_sistema_reparable :-
    jugador(Modulo),
    sistema(Modulo, _, ArtefactosNecesarios, fallo),
    artefactosLogrados(ListaArtefactos),
    todos_en_lista(ArtefactosNecesarios, ListaArtefactos).


/*
    mostrar_sistemas_reparables
    Salidas: Muestra los sistemas que pueden repararse actualmente.
    Restricciones: El jugador debe estar en el modulo del sistema y tener los artefactos necesarios.
    Objetivo: Mostrar posibles acciones reparar(Sistema).
*/

mostrar_sistemas_reparables :-
    not(hay_sistema_reparable),
    write('No hay sistemas reparables en este momento.'),
    nl,
    !.

mostrar_sistemas_reparables :-
    jugador(Modulo),
    sistema(Modulo, Sistema, ArtefactosNecesarios, fallo),
    artefactosLogrados(ListaArtefactos),
    todos_en_lista(ArtefactosNecesarios, ListaArtefactos),
    write('- reparar('),
    write(Sistema),
    write(')'),
    nl,
    fail.

mostrar_sistemas_reparables.


/*
    hay_tripulante_rescatable
    Salidas: verdadero si hay un tripulante que se puede rescatar en el modulo actual.
    Objetivo: Saber si se deben mostrar tripulantes rescatables.
*/

hay_tripulante_rescatable :-
    jugador(Modulo),
    tripulante(_, Modulo, SistemasNecesarios, atrapado),
    sistemas_funcionan(SistemasNecesarios).


/*
    mostrar_tripulantes_rescatables
    Salidas: Muestra los tripulantes que pueden rescatarse actualmente.
    Restricciones: El jugador debe estar en el mismo modulo y los sistemas necesarios deben funcionar.
    Objetivo: Mostrar posibles acciones rescatar(Tripulante).
*/

mostrar_tripulantes_rescatables :-
    not(hay_tripulante_rescatable),
    write('No hay tripulantes rescatables en este momento.'),
    nl,
    !.

mostrar_tripulantes_rescatables :-
    jugador(Modulo),
    tripulante(Tripulante, Modulo, SistemasNecesarios, atrapado),
    sistemas_funcionan(SistemasNecesarios),
    write('- rescatar('),
    write(Tripulante),
    write(')'),
    nl,
    fail.

mostrar_tripulantes_rescatables.


/*
    acciones_disponibles
    Salidas: Muestra las acciones que el jugador puede intentar segun el estado actual.
    Restricciones: Depende del modulo actual, inventario, sistemas y tripulantes.
    Objetivo: Orientar al jugador o a la interfaz sobre las acciones posibles.
*/

acciones_disponibles :-
    write('========== ACCIONES DISPONIBLES =========='), nl,
    write('Movimientos:'), nl,
    mostrar_movimientos_disponibles,
    write('------------------------------------------'), nl,
    write('Artefactos para tomar:'), nl,
    mostrar_artefactos_disponibles,
    write('------------------------------------------'), nl,
    write('Artefactos para usar:'), nl,
    mostrar_artefactos_para_usar,
    write('------------------------------------------'), nl,
    write('Sistemas reparables:'), nl,
    mostrar_sistemas_reparables,
    write('------------------------------------------'), nl,
    write('Tripulantes rescatables:'), nl,
    mostrar_tripulantes_rescatables,
    write('=========================================='), nl.


/*
    ayuda
    Salidas: Muestra los comandos principales disponibles para jugar.
    Objetivo: Dar una guia rapida de uso del juego.
*/

ayuda :-
    write('========== AYUDA DEL JUEGO =========='), nl,
    write('Comandos principales:'), nl,
    write('- donde_estoy.'), nl,
    write('- estado_juego.'), nl,
    write('- acciones_disponibles.'), nl,
    write('- mover(Modulo).'), nl,
    write('- tomar(Artefacto).'), nl,
    write('- usar(Artefacto).'), nl,
    write('- reparar(Sistema).'), nl,
    write('- rescatar(Tripulante).'), nl,
    write('- donde_esta(Artefacto).'), nl,
    write('- que_tengo.'), nl,
    write('- modulos_visitados.'), nl,
    write('- ruta(Inicio, Fin, Camino).'), nl,
    write('- como_gano.'), nl,
    write('- verifica_gane.'), nl,
    write('- reiniciar_juego.'), nl,
    write('====================================='), nl.


/*
    reiniciar_juego
    Salidas: Reinicia la partida y muestra un mensaje de confirmacion.
    Restricciones: Debe existir el archivo hechos.pl con el estado inicial del juego.
    Objetivo: Limpiar el estado dinamico actual y volver a cargar los hechos iniciales.
*/

reiniciar_juego :-
    retractall(jugador(_)),
    retractall(artefactosLogrados(_)),
    retractall(artefactoUsado(_)),
    retractall(visitado(_)),
    retractall(historialModulos(_)),
    retractall(sistema(_, _, _, _)),
    retractall(tripulante(_, _, _, _)),
    consult('hechos.pl'),
    write('La partida fue reiniciada correctamente.'),
    nl.