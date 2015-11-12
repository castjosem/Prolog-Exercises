%SITUACION INICIAL


%HECHOS

lugar(casa).
lugar(fer).
lugar(sm).
vende(sm,leche).
vende(sm,cafe).
vende(fer,martillo).

%******************************* SITUACION INICIAL *************************************

cierto(en(casa),s0).

%***************************************************************************************







%***************************** CODIFICACIÓN DE ACCIONES*********************************

puedo(ir(X),S):- cierto(en(Y),S),lugar(X),Y\=X.

puedo(comprar(T),S):- cierto(en(X),S), vende(X,T),\+cierto(tener(T),S).

%***************************************************************************************






%****************************** CODIFICACIÓN DE EFECTOS********************************

cierto(y(X,Y),S):- cierto(Y,S), cierto(X,S).

cierto(en(X),resultado(ir(X),_)).

cierto(en(X),resultado(comprar(_),S)):- cierto(en(X),S).

cierto(tener(T),resultado(comprar(T),_)).

cierto(tener(T),resultado(_,S)):- cierto(tener(T),S).

%***************************************************************************************




%*********************  PREDICADO PRINCIPAL CON META INSTANCIADA *************************

plan:- Meta = y(y(y(en(casa),tener(cafe)),tener(leche)), tener(martillo)), ancho(Meta).

%******************************************************************************************





% *****  CODIGO DEL PLANIFICADOR BASADO EN BUSQUEDA EN ANCHO PARA LOGICA SITUACIONAL  *****
ancho(Meta):-  ancho(Meta, [s0], Solucion), nl, write('Solución: '), write(Solucion), nl.

ancho(Meta,[Tope|_],Tope):- cierto(Meta,Tope).
 
ancho(Meta,[Edo|Resto],Solucion):-  findall(resultado(Accion,Edo),puedo(Accion,Edo),Lista),
									append(Resto,Lista,Nuevo), ancho(Meta,Nuevo,Solucion).
									
%******************************************************************************************

