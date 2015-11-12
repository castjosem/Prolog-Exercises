%
% 960125 - INTELIGENCIA ARTIFICIAL
% EL PLANIFICADOR BASADO EN BUSQUEDA EN ANCHO PARA LOGICA SITUACIONAL.
% TAREA
%

% PREDICADO PRINCIPAL CON META INSTANCIADA
plan:-
 Meta = y(y(sobre(a,b),sobre(b,c)),sobre(c,m)),
 ancho(Meta).
%

% CODIGO DEL PLANIFICADOR BASADO EN BUSQUEDA EN ANCHO PARA LOGICA SITUACIONAL
ancho(Meta):- 
 ancho(Meta, [s0], Solucion), nl, write('Solución: '), write(Solucion), nl.

ancho(Meta,[Tope|_],Tope):-
 cierto(Meta,Tope).
 
ancho(Meta,[Edo|Resto],Solucion):-

 findall(result(Accion,Edo),puedo(Accion,Edo),Lista),
 append(Resto,Lista,Nuevo),

 ancho(Meta,Nuevo,Solucion).

cierto(y(X,Y),S):-
 cierto(Y,S),
 cierto(X,S).
% FIN DE CODIGO DEL PLANIFICADOR BASADO EN BUSQUEDA EN ANCHO PARA LOGICA SITUACIONAL

% DEFINICION DEL ESTADO INICIAL:

% FIN DEFINICION ESTADO INICIAL.

% PRECONDICIONES USANDO 'puedo(...)'

% FIN DE PRECONDICIONES.

% EFECTOS DE LAS ACCIONES.

% FIN DE EFECTOS DE LAS ACCIONES