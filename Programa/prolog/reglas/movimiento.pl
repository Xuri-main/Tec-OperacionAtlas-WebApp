/*
    Archivo: movimiento.pl
    Descripcion: Reglas relacionadas con conexiones, restricciones de acceso y movimiento.
    Autores: Jareck Levell C.
    Fecha: 29/05/2026
*/

/*
    conectado
    Entradas: Modulo1, Modulo2.
    Salidas: verdadero si existe conexion entre ambos modulos.
    Restricciones: Debe existir un hecho enlace/2 entre los modulos.
    Objetivo: Interpretar los enlaces como conexiones bidireccionales.
*/

conectado(Modulo1, Modulo2) :-
    enlace(Modulo1, Modulo2).

conectado(Modulo1, Modulo2) :-
    enlace(Modulo2, Modulo1).


/*
    falta_artefacto_para_entrar
    Entradas: Modulo.
    Salidas: verdadero si falta usar un artefacto necesario para entrar.
    Objetivo: Detectar restricciones de acceso por artefacto.
*/

falta_artefacto_para_entrar(Modulo) :-
    necesita(Modulo, Artefacto),
    not(artefactoUsado(Artefacto)).


/*
    cumple_artefacto
    Entradas: Modulo.
    Salidas: verdadero si no falta ningun artefacto para entrar.
    Objetivo: Validar restricciones por artefactos.
*/

cumple_artefacto(Modulo) :-
    not(falta_artefacto_para_entrar(Modulo)).


/*
    falta_estado_para_entrar
    Entradas: Modulo.
    Salidas: verdadero si falta restaurar un sistema necesario.
    Objetivo: Detectar restricciones de acceso por estado de sistema.
*/

falta_estado_para_entrar(Modulo) :-
    necesitaEstado(Modulo, Sistema, EstadoNecesario),
    not(sistema(_, Sistema, _, EstadoNecesario)).


/*
    cumple_estado
    Entradas: Modulo.
    Salidas: verdadero si el modulo no tiene restricciones de estado pendientes.
    Objetivo: Validar restricciones por estado de sistemas.
*/

cumple_estado(Modulo) :-
    not(falta_estado_para_entrar(Modulo)).


/*
    falta_paso_previo
    Entradas: Modulo.
    Salidas: verdadero si falta visitar un modulo previo requerido.
    Objetivo: Detectar restricciones de acceso por pasos previos.
*/

falta_paso_previo(Modulo) :-
    pasoPrevio(Modulo, ModuloPrevio),
    not(visitado(ModuloPrevio)).


/*
    cumple_paso_previo
    Entradas: Modulo.
    Salidas: verdadero si se han cumplido los pasos previos necesarios.
    Objetivo: Validar restricciones por recorrido previo.
*/

cumple_paso_previo(Modulo) :-
    not(falta_paso_previo(Modulo)).


/*
    puedo_ir
    Entradas: Hacia.
    Salidas: verdadero si el jugador puede moverse al modulo indicado.
    Restricciones: Debe existir conexion y deben cumplirse las restricciones del destino.
    Objetivo: Determinar si un movimiento es permitido.
*/

puedo_ir(Hacia) :-
    jugador(Actual),
    conectado(Actual, Hacia),
    cumple_artefacto(Hacia),
    cumple_estado(Hacia),
    cumple_paso_previo(Hacia).


/*
    mover
    Entradas: Modulo.
    Salidas: Muestra un mensaje de exito o fallo.
    Restricciones: El movimiento debe cumplir puedo_ir/1.
    Objetivo: Cambiar la ubicacion del jugador y actualizar el historial.
*/

mover(Modulo) :-
    puedo_ir(Modulo),
    retract(jugador(_)),
    asserta(jugador(Modulo)),
    registrar_visitado(Modulo),
    actualizar_historial(Modulo),
    write('Te moviste a: '),
    write(Modulo),
    nl,
    !.

mover(Modulo) :-
    write('No es posible moverse a: '),
    write(Modulo),
    nl,
    fail.