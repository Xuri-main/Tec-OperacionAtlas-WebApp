/*
    Archivo: reglas.pl
    Descripcion: Reglas principales del juego Operacion Atlas. Aqui esta el cerebro logico del proyecto.
    Autores: Emilio Funes R. , Ginger Rodríguez G. & Jareck Levell C.
    Fecha: 29/05/2026
*/


% ------------------------------------------------------------
% en_lista(Elemento, Lista)
% Verifica si un elemento esta dentro de una lista.
% Se hace con recursion para evitar depender de member/2.
% ------------------------------------------------------------

en_lista(Elemento, [Elemento|_]).

en_lista(Elemento, [_|Cola]) :-
    en_lista(Elemento, Cola).


% ------------------------------------------------------------
% todos_en_lista(ListaRequerida, ListaDisponible)
% Verifica que todos los elementos requeridos esten disponibles.
% ------------------------------------------------------------

todos_en_lista([], _).

todos_en_lista([Cabeza|Cola], ListaDisponible) :-
    en_lista(Cabeza, ListaDisponible),
    todos_en_lista(Cola, ListaDisponible).


% ------------------------------------------------------------
% agregar_final(Lista, Elemento, NuevaLista)
% Agrega un elemento al final de una lista usando recursion.
% Sirve para mantener el historial en orden.
% ------------------------------------------------------------

agregar_final([], Elemento, [Elemento]).

agregar_final([Cabeza|Cola], Elemento, [Cabeza|NuevaCola]) :-
    agregar_final(Cola, Elemento, NuevaCola).


% ------------------------------------------------------------
% conectado(Modulo1, Modulo2)
% Un enlace se considera bidireccional.
% Si hay enlace(A, B), tambien se puede ir de B a A.
% ------------------------------------------------------------

conectado(Modulo1, Modulo2) :-
    enlace(Modulo1, Modulo2).

conectado(Modulo1, Modulo2) :-
    enlace(Modulo2, Modulo1).


% ------------------------------------------------------------
% falta_artefacto_para_entrar(Modulo)
% Es verdadero si el modulo necesita un artefacto
% que aun no ha sido usado.
% ------------------------------------------------------------

falta_artefacto_para_entrar(Modulo) :-
    necesita(Modulo, Artefacto),
    not(artefactoUsado(Artefacto)).


% ------------------------------------------------------------
% cumple_artefacto(Modulo)
% Es verdadero si no falta ningun artefacto requerido.
% ------------------------------------------------------------

cumple_artefacto(Modulo) :-
    not(falta_artefacto_para_entrar(Modulo)).


% ------------------------------------------------------------
% falta_estado_para_entrar(Modulo)
% Es verdadero si el modulo necesita un sistema en cierto estado
% y ese sistema todavia no cumple esa condicion.
% ------------------------------------------------------------

falta_estado_para_entrar(Modulo) :-
    necesitaEstado(Modulo, Sistema, EstadoNecesario),
    not(sistema(_, Sistema, _, EstadoNecesario)).


% ------------------------------------------------------------
% cumple_estado(Modulo)
% Es verdadero si el modulo no tiene restricciones de estado
% pendientes.
% ------------------------------------------------------------

cumple_estado(Modulo) :-
    not(falta_estado_para_entrar(Modulo)).


% ------------------------------------------------------------
% falta_paso_previo(Modulo)
% Es verdadero si el modulo necesita haber visitado otro modulo
% previamente y ese modulo no ha sido visitado.
% ------------------------------------------------------------

falta_paso_previo(Modulo) :-
    pasoPrevio(Modulo, ModuloPrevio),
    not(visitado(ModuloPrevio)).


% ------------------------------------------------------------
% cumple_paso_previo(Modulo)
% Es verdadero si no falta ningun paso previo.
% ------------------------------------------------------------

cumple_paso_previo(Modulo) :-
    not(falta_paso_previo(Modulo)).


% ------------------------------------------------------------
% puedo_ir(Hacia)
% Determina si el jugador puede moverse desde su modulo actual
% hacia otro modulo.
% Valida enlace, artefactos usados, estados y pasos previos.
% ------------------------------------------------------------

puedo_ir(Hacia) :-
    jugador(Actual),
    conectado(Actual, Hacia),
    cumple_artefacto(Hacia),
    cumple_estado(Hacia),
    cumple_paso_previo(Hacia).


% ------------------------------------------------------------
% registrar_visitado(Modulo)
% Registra un modulo como visitado si no estaba registrado.
% Se usa cut para evitar duplicados.
% ------------------------------------------------------------

registrar_visitado(Modulo) :-
    visitado(Modulo),
    !.

registrar_visitado(Modulo) :-
    asserta(visitado(Modulo)).


% ------------------------------------------------------------
% actualizar_historial(Modulo)
% Agrega el modulo al historial de movimiento.
% ------------------------------------------------------------

actualizar_historial(Modulo) :-
    historialModulos(Lista),
    agregar_final(Lista, Modulo, NuevaLista),
    retract(historialModulos(Lista)),
    asserta(historialModulos(NuevaLista)).


% ------------------------------------------------------------
% mover(Modulo)
% Mueve al jugador si puedo_ir(Modulo) se cumple.
% Actualiza la ubicacion actual y el historial.
% ------------------------------------------------------------

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
