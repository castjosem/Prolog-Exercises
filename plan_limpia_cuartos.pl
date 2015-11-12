%SITUACION INICIAL


%HECHOS
cuarto(c1).
cuarto(c2).
cuarto(c3).
cuarto(c4).
cuarto(c5).
cuarto(c6).
cuarto(c7).
cuarto(c8).
cuarto(c9).


connected(c1,c2).
connected(c1,c4).
connected(c2,c1).
connected(c2,c3).
connected(c2,c5).
connected(c3,c2).
connected(c3,c6).
connected(c4,c1).
connected(c4,c5).
connected(c4,c7).
connected(c5,c2).
connected(c5,c4).
connected(c5,c6).
connected(c5,c8).
connected(c6,c3).
connected(c6,c5).
connected(c6,c9).
connected(c7,c4).
connected(c7,c8).
connected(c8,c5).
connected(c8,c7).
connected(c8,c9).
connected(c9,c6).
connected(c9,c8).

wumpus(w).


%******************************* SITUACION INICIAL *************************************
cierto(sucio(c1),s0).
cierto(limpio(c2),s0).
cierto(sucio(c3),s0).
cierto(limpio(c4),s0).
cierto(limpio(c5),s0).
cierto(limpio(c6),s0).
cierto(sucio(c7),s0).
cierto(limpio(c8),s0).
cierto(limpio(c9),s0).

cierto(esta(w,c5),s0).

%***************************************************************************************






%***************************** CODIFICACIÓN DE ACCIONES*********************************

puedo(ir(X),S):- cierto(esta(w,Y),S),cuarto(X),  X\=Y, connected(Y,X).

puedo(limpiar,S):- cierto(esta(w,Y),S), cierto(sucio(Y),S).

%***************************************************************************************






%****************************** CODIFICACIÓN DE EFECTOS********************************

cierto(y(X,Y),S):- cierto(Y,S), cierto(X,S).

cierto(esta(_,X),resultado(ir(X),_)).

cierto(esta(_,X),resultado(limpiar,S)):- cierto(esta(_,X),S), cierto(sucio(X),S).

cierto(limpio(X),resultado(limpiar,S)):- cierto(esta(_,X),S), cierto(sucio(X),S).

cierto(sucio(X),resultado(_,S)):- cierto(sucio(X),S).

cierto(limpio(X),resultado(_,S)):- cierto(limpio(X),S).


%***************************************************************************************










%*********************  PREDICADO PRINCIPAL CON META INSTANCIADA *************************

plan:- Meta = y(y(y(y(y(y(y(y(limpio(c9),limpio(c8)),limpio(c7)),limpio(c6)),limpio(c5)),limpio(c4)),limpio(c3)),limpio(c2)),limpio(c1)), ancho(Meta).

%******************************************************************************************





% *****  CODIGO DEL PLANIFICADOR BASADO EN BUSQUEDA EN ANCHO PARA LOGICA SITUACIONAL  *****
ancho(Meta):-  ancho(Meta, [s0], Solucion), nl, write('Solución: '), write(Solucion), nl.

ancho(Meta,[Tope|_],Tope):- cierto(Meta,Tope).
 
ancho(Meta,[Edo|Resto],Solucion):-  findall(resultado(Accion,Edo),puedo(Accion,Edo),Lista),
									append(Resto,Lista,Nuevo), ancho(Meta,Nuevo,Solucion).
									
%******************************************************************************************

