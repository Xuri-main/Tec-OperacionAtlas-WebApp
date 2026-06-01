/*
    Archivo: listas.pl
    Descripcion: Reglas auxiliares para trabajar con listas mediante recursion.
    Autores: Emilio Funes R. , Ginger Rodriguez G. & Jareck Levell C.
    Fecha: 29/05/2026
*/

/*
    en_lista
    Entradas: Elemento, Lista.
    Salidas: verdadero si Elemento esta dentro de Lista.
    Restricciones: Lista debe ser una lista valida de Prolog.
    Objetivo: Verificar pertenencia a una lista usando recursion.
*/

en_lista(Elemento, [Elemento|_]).

en_lista(Elemento, [_|Cola]) :-
    en_lista(Elemento, Cola).


/*
    todos_en_lista
    Entradas: ListaRequerida, ListaDisponible.
    Salidas: verdadero si todos los elementos de ListaRequerida estan en ListaDisponible.
    Restricciones: Ambas entradas deben ser listas.
    Objetivo: Validar si el jugador posee todos los elementos necesarios.
*/

todos_en_lista([], _).

todos_en_lista([Cabeza|Cola], ListaDisponible) :-
    en_lista(Cabeza, ListaDisponible),
    todos_en_lista(Cola, ListaDisponible).


/*
    agregar_final
    Entradas: Lista, Elemento.
    Salidas: NuevaLista.
    Restricciones: Lista debe ser una lista valida.
    Objetivo: Agregar un elemento al final de una lista usando recursion.
*/

agregar_final([], Elemento, [Elemento]).

agregar_final([Cabeza|Cola], Elemento, [Cabeza|NuevaCola]) :-
    agregar_final(Cola, Elemento, NuevaCola).