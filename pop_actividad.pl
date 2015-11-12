%Planificador
% Code for POPDEPTH
popdepth(CPlan,FPlan):-
 complete(CPlan),
 FPlan=CPlan.
 
popdepth(CPlan,FPlan):-
 loop(CPlan,XPlan),
 popdepth(XPlan,YPlan),
 FPlan=YPlan.


% need a test for completeness
complete(Plan):-
 \+ selectSubgoal(Plan,_,_).
  
% need a main loop
loop(Plan,NPlan):-
  selectSubgoal(Plan,S:Action,Constraint),
  chooseOperator(Plan,S:Action,Constraint,XPlan),
  resolveThreats(XPlan,NPlan).

selectSubgoal(CPlan,S:Action,Constraint) :-
        CPlan = plan(Steps,_Orderings,Links),
        member(Step,Steps),
        Step = S:op(Action,Preconditions,_Effects),
        member(Constraint,Preconditions),
        \+ (member(l(_Si,Constraint,T),Links),T==S).

chooseOperator(CPlan,SNeed:_SNeedAction,Constraint,NPlan) :-
        CPlan = plan(Steps,_Orderings,_Links),
        member(StepKnight,Steps),
        StepKnight = SKnight:op(_Action,_Preconditions,Effects),
        member(Constraint,Effects),
        addOrder(p(SKnight,SNeed),CPlan,CPlan1),
        addLink(l(SKnight,Constraint,SNeed),CPlan1,NPlan).

% need a second version of chooseOperator that searches
% for an action schema
chooseOperator(CPlan,SNeed:SNeedAction,Constraint,NPlan) :- 
        action(AAction,APreconditions,AEffects),
        member(Constraint,AEffects),
        gensym(s,NewState),
        SKnight = NewState:op(AAction,APreconditions,AEffects),
        addStep(SKnight,CPlan,CPlan1),
        addLink(l(NewState,Constraint,SNeed),CPlan1,CPlan2),
        addOrder(p(start,NewState),CPlan2,CPlan3),
        addOrder(p(NewState,finish),CPlan3,NPlan).

% resolveThreats 
resolveThreats(Plan,NPlan):-
 findThreat(Threat,Link,Plan),
 !,
 resolveThreat(Threat,Link,Plan,NPlan),
 resolveThreats(NPlan,NNPlan).
 
resolveThreats(Plan,Plan). % Succeeds if no threats were found.
 
findThreat(SThreat,Link,CPlan) :-
        CPlan = plan(Steps,Orderings,Links),
        member(SThreat:op(Action,_Preconditions,Effects),Steps),
        member(not(Constraint1),Effects),
        member(Link,Links),
        Link = l(SKnight,Constraint2,SNeed),
        % make sure that any threat that can unify
        % is viewed as a threat
        % But don't force instantiation now
        \+ (\+ Constraint1 = Constraint2),
        \+ SThreat == SNeed,
        \+ SThreat == SKnight,
        \+ prec(p(SThreat,SKnight),Orderings),
        \+ prec(p(SNeed,SThreat),Orderings).


findThreat(_,_,_) :-
        fail.

% resolveThreat
resolveThreat(SThreat,Link,CPlan,NPlan):- % Resolve by Promotion
 CPlan = plan(Steps,Orderings,Links),
 Link = l(Si,C,Sj),
 addOrder(p(Sj,SThreat),CPlan,NPlan).

resolveThreat(SThreat,Link,CPlan,NPlan):- % Resolve by Demotion if Promotion fails.
 CPlan = plan(Steps,Orderings,Links),
 Link = l(Si,C,Sj),
 addOrder(p(SThreat,Si),CPlan,NPlan).

% prec
prec(p(Si,Sj),Constraints):-
 member(p(Si1,Sj1),Constraints),
 Si==Si1,
 Sj==Sj1.
 
prec(p(Si,Sj),Constraints):-
 member(p(Si,Sk),Constraints),
 prec(p(Sk,Sj),Constraints).

% code to addStep
addStep(NewStep,plan(Steps,Orderings,Links),plan(NSteps,Orderings,Links)):-
 append(Steps,[NewStep],NSteps).

addOrder(O,plan(Steps,Orderings,Links),plan(Steps,Orderings,Links)) :-
        prec(O,Orderings),
        %member(O1,Orderings), O1==O,
        %write('first addOrder predicated has succeeded!'),
        !.

addOrder(O,plan(Steps,Orderings,Links),plan(Steps,NOrderings,Links)) :-
        O = p(Si,Sj),
        \+ Si == Sj,
        \+ prec(p(Sj,Si),Orderings),
        %write('adding '),write(Sj<Si),nl,
        append(Orderings,[O],NOrderings),
        %write('second addOrder predicated has succeeded!'),
        !.

% addLink
addLink(NewLink,plan(Steps,Orderings,Links),plan(Steps,Orderings,NLinks)):-
 append(Links,[NewLink],NLinks).


stepSymbol(_).


%PlanPrint:
printPlan(plan(Steps,Ordering,Links)) :-
        nl,
        write('Plan'),nl,
        write('----'),nl,
        linearize(Steps,Ordering,Linearized),
        nl,
        printSteps(Linearized,Links).


linearize(Steps,Ordering,[Step|LSteps]) :-
        pulloutone(Step,Rest,Steps),
        beforerest(Step,Rest,Ordering),
        !,
        linearize(Rest,Ordering,LSteps).

linearize([],_,[]).

beforerest(Step:_,Rest,Ordering) :-
        member(Other:_,Rest),
        prec(p(Other,Step),Ordering),
        !,
        fail.

beforerest(_,_,_).

printSteps([S:op(Action,Preconditions,Effects)|Steps],Links) :-
        write('     '),printPre(Preconditions,S,Links),nl,
        write(S),write(':'),write(Action),nl,
        write('     '),printEff(Effects,S,Links),nl,
        nl,
        printSteps(Steps,Links).

printSteps([],_).

printPre([],_,_).
printPre([Pre|Rest],Step,Links) :-
        member(l(Knight,Pre,StepP),Links),
        StepP == Step,
        !,
        write(Knight),write(':'),write(Pre),write(' '),
        printPre(Rest,Step,Links).

printPre([Pre|Rest],Step,Links) :-
        write('*:'),write(Pre),write(' '),
        printPre(Rest,Step,Links).


printEff([],_,_).
printEff([Pre|Rest],Step,Links) :-
        member(l(StepP,Pre,Need),Links),
        StepP == Step,
        !,
        write(Need),write(':'),write(Pre),write(' '),
        printEff(Rest,Step,Links).

printEff([Pre|Rest],Step,Links) :-
        write('*:'),write(Pre),write(' '),
        printEff(Rest,Step,Links).


printOrdering([S|Steps]) :-
        write(S),nl,
        printOrdering(Steps).

printOrdering([]).

printLinks([S|Steps]) :-
        write(S),nl,
        printLinks(Steps).

printLinks([]).


%PlanMisc:
member(A,[A|_]).
member(A,[_|List]) :- member(A,List).


pulloutone(A,List,[A|List]).
pulloutone(A,[B|Rest],[B|List]) :-
        pulloutone(A,Rest,List).

% co de to reload after you have made a change.
r :- ['planificador.pl'].

% code for depth-first search
main :- initial(Initial),
        goal(Goal),
        makeInitialPlan(Initial,Goal,CPlan),
        popdepth(CPlan,FPlan),
        write(FPlan),get0(_),
        printPlan(FPlan).

% code for best-first search
best :- initial(Initial),
        goal(Goal),
        makeInitialPlan(Initial,Goal,CPlan),
        CPlan = plan(Steps,Orderings,Links),
        length(Steps,StepsLen),
        length(Links,LinksLen),
        retractall(plan(_,_,_,_)),
        assert(plan(StepsLen,LinksLen,CPlan)),
        popbest(2,FPlan),
        printPlan(FPlan).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% EL CODIGO QUE SIGUE ES EL QUE DEBEN MODIFICAR PARA EL MUNDO DE BLOQUES %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


action(mover(X,m),[bloque(X),despejado(X),sobre(X,G),bloque(G)],[not(sobre(X,G)),sobre(X,m),despejado(G)]).
action(mover(X,Y),[bloque(X),despejado(X),despejado(Y),sobre(X,G)],[not(sobre(X,G)),not(despejado(Y)),sobre(X,Y) ,despejado(G)]).

initial([sobre(c,b),sobre(b,a),sobre(a,m),despejado(c),despejado(m),bloque(a),bloque(b),bloque(c),mesa(m)]).
goal([sobre(a,b),sobre(b,c),sobre(c,m)]).

%makeInitialPlan.
makeInitialPlan(Initial,Goal,CPlan):-
 Start=start,
 Finish=finish,
 Steps=[Start:op(start,[],Initial),Finish:op(finish,Goal,[])],
 Orderings=[p(Start,Finish)],
 Links=[],
 CPlan=plan(Steps,Orderings,Links).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Tomando en cuenta lo visto en clase y los resultados de su ejercicio,    %%
%% comente sobre aspectos de diseño e implementación de su solución usando  %%
%% un lenguaje de programación no lógica (sino imperativo, como C++ o Java) %% 
%% y sobre las ventajas y desventajas de ello.                              %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
