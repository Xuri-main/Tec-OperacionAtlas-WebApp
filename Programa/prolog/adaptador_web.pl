/*
    Archivo: adaptador_web.pl
    Descripcion: Adaptador entre el backend web y el cerebro logico en Prolog.
                 Lee comandos enviados desde Node.js, ejecuta predicados permitidos
                 y devuelve la respuesta por consola.
    Autores: Emilio Funes R. , Ginger Rodriguez G. & Jareck Levell C.
    Fecha: 29/05/2026
*/

/*
    iniciar_puente
    Salidas: Muestra un mensaje indicando que el puente esta listo.
    Objetivo: Iniciar el ciclo de lectura de comandos enviados desde el backend.
*/

iniciar_puente :-
    write('puente_listo'),
    nl,
    leer_comandos.


/*
    leer_comandos
    Entradas: Lee comandos desde la entrada estandar usando read/1.
    Salidas: Imprime la respuesta del comando y la marca fin_respuesta.
    Objetivo: Mantener activo el proceso de Prolog para recibir varios comandos.
*/

leer_comandos :-
    read(Comando),
    ejecutar_comando(Comando),
    write('fin_respuesta'),
    nl,
    leer_comandos.


/*
    ejecutar_comando
    Entradas: Comando.
    Salidas: Ejecuta el predicado correspondiente.
    Restricciones: Solo se aceptan comandos definidos en este archivo.
    Objetivo: Evitar que el backend ejecute consultas arbitrarias en Prolog.
*/

ejecutar_comando(estado_juego) :-
    estado_juego,
    !.

ejecutar_comando(acciones_disponibles) :-
    acciones_disponibles,
    !.

ejecutar_comando(como_gano) :-
    como_gano,
    !.

ejecutar_comando(verifica_gane) :-
    verifica_gane,
    !.

ejecutar_comando(verifica_gane).

ejecutar_comando(reiniciar_juego) :-
    reiniciar_juego,
    !.

ejecutar_comando(ayuda) :-
    ayuda,
    !.

ejecutar_comando(donde_estoy) :-
    donde_estoy,
    !.

ejecutar_comando(que_tengo) :-
    que_tengo,
    !.

ejecutar_comando(modulos_visitados) :-
    modulos_visitados,
    !.

ejecutar_comando(descripcion_modulo_actual) :-
    descripcion_modulo_actual,
    !.

ejecutar_comando(mover(Modulo)) :-
    mover(Modulo),
    !.

ejecutar_comando(mover(_)).

ejecutar_comando(tomar(Artefacto)) :-
    tomar(Artefacto),
    !.

ejecutar_comando(tomar(_)).

ejecutar_comando(usar(Artefacto)) :-
    usar(Artefacto),
    !.

ejecutar_comando(usar(_)).

ejecutar_comando(reparar(Sistema)) :-
    reparar(Sistema),
    !.

ejecutar_comando(reparar(_)).

ejecutar_comando(rescatar(Tripulante)) :-
    rescatar(Tripulante),
    !.

ejecutar_comando(rescatar(_)).

ejecutar_comando(donde_esta(Artefacto)) :-
    donde_esta(Artefacto),
    !.

ejecutar_comando(donde_esta(_)).

/*
    ejecutar_comando ruta
    Entradas: ruta(Inicio, Fin).
    Salidas: Muestra una ruta entre Inicio y Fin.
    Restricciones: Debe existir una ruta entre ambos modulos.
    Objetivo: Permitir consultar rutas desde la interfaz web sin pedir una variable Camino.
*/

ejecutar_comando(ruta(Inicio, Fin)) :-
    ruta(Inicio, Fin, Camino),
    write('Ruta encontrada: '),
    write(Camino),
    nl,
    !.

ejecutar_comando(ruta(_, _)) :-
    write('No se encontro una ruta con esos modulos.'),
    nl,
    !.

/*
    ejecutar_comando puedo_ir
    Entradas: puedo_ir(Modulo).
    Salidas: Muestra si el jugador puede moverse al modulo indicado.
    Objetivo: Permitir consultar desde la interfaz si un movimiento es posible.
*/

ejecutar_comando(puedo_ir(Modulo)) :-
    puedo_ir(Modulo),
    write('Si es posible moverse a: '),
    write(Modulo),
    nl,
    !.

ejecutar_comando(puedo_ir(Modulo)) :-
    write('No es posible moverse a: '),
    write(Modulo),
    nl,
    !.
    
/*
    ejecutar_comando generico
    Entradas: Comando.
    Salidas: Mensaje de comando no reconocido.
    Objetivo: Controlar comandos que no existen o no estan permitidos.
*/

ejecutar_comando(Comando) :-
    write('Comando no reconocido o no permitido: '),
    write(Comando),
    nl.