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