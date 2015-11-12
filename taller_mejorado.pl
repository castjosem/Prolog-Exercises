%Situaciesta Inicial

cuarto(1).
cuarto(2).
cuarto(3).
wumpus(w).

cierto(sucio(1),s0).
cierto(sucio(2),s0).
cierto(sucio(3),s0).
cierto(esta(w,1),s0).
%cierto(clear(1),s0).
%cierto(clear(2),s0).

% Fin Situaciesta Inicial

% Precestadiciestaes

puedo(ir(W,X),S) :- wumpus(W),cuarto(X),\+cierto(esta(W,X),S).

puedo(limpiar(X),S) :- cuarto(X), wumpus(W), cierto(esta(W,X),S), cierto(sucio(X),S).

% Fin Precestadiciestaes

% Efectos

cierto(and(X,Y),S):-cierto(Y,S),cierto(X,S).

cierto(esta(X,Y),result(ir(X,Y),_)).

cierto(esta(W,X),result(limpiar(X),S)) :- wumpus(W),cuarto(X),cierto(sucio(X),S).

cierto(limpio(X),result(limpiar(X),S)) :- cuarto(X), cierto(sucio(X),S).

cierto(sucio(Y), result(_,S) ) :- wumpus(W), cuarto(X) , cierto(esta(W,X),S) , cierto(sucio(Y),S).

cierto(limpio(Y), result(_,S) ) :- wumpus(W), cuarto(X) , cierto(esta(W,X),S) , cierto(limpio(Y),S).

% Fin Efectos

%Plan

plan :- Meta= and(and(limpio(1),limpio(2)),limpio(3)),ancho(Meta).

ancho(Meta):-ancho(Meta, [s0], Solutiesta), nl, write('Solutiesta: '), write(Solutiesta).

ancho(Meta,[Top|_],Top):-cierto(Meta,Top).

ancho(Meta,[State|Rest],Solutiesta):-
 
 findall(result(Actiesta,State),puedo(Actiesta,State),List),
 
 append(Rest,List,New),

 ancho(Meta,New,Solutiesta).

% Fin Planificador