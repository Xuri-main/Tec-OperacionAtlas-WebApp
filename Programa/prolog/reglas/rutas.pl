/*
    Archivo: rutas.pl
    Descripcion: Reglas para encontrar rutas entre modulos usando recursion y backtracking.
    Autores: Emilio Funes R.
    Fecha: 30/05/2026
*/

/*
    ruta
    Entradas: Inicio, Fin.
    Salidas: Camino.
    Restricciones: Inicio y Fin deben ser modulos conectados directa o indirectamente.
    Objetivo: Encontrar una ruta logica entre dos modulos.
*/

ruta(Inicio, Fin, Camino) :-
    ruta_auxiliar(Inicio, Fin, [Inicio], Camino).


/*
    ruta_auxiliar
    Entradas: Actual, Fin, Visitados.
    Salidas: Camino.
    Restricciones: Visitados debe ser una lista de modulos ya recorridos en la busqueda.
    Objetivo: Construir una ruta evitando ciclos.
*/

ruta_auxiliar(Fin, Fin, _, [Fin]).

ruta_auxiliar(Actual, Fin, Visitados, [Actual|Camino]) :-
    conectado(Actual, Siguiente),
    not(en_lista(Siguiente, Visitados)),
    ruta_auxiliar(Siguiente, Fin, [Siguiente|Visitados], Camino).