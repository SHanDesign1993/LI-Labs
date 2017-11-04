%----------------------------- UTILITIES ---------------------------------------
/** Pertinence: Permutates the elements of a given list
  *
  * Base case -> X is the first element of the list
  *
  * Recursive case -> We divide the list in two. We seek for X in the second part
  * of the list (X is not in the first part of the list, because if that was the
  * case it will be unified with the first statement).
  *
  * NOTE: [_] means that we dont care about the elements of the list.
*/
pertinence(X, [X|_]).
pertinence(X, [_|L]):- pertinence(X, L).

/** Concat: Concatenate a pair of given lists
  *
  * Base case -> One of the lists is empty. Returns the other one
  *
  * Recursive case -> The first element of the first list appears as the first element of the third list.
  *
  * NOTE: [_] means that we dont care about the elements of the list.
*/
concat([],L,L).
concat([X|L1],L2,[X|L3]):- concat(L1,L2,L3).

/** Permutation: gives all the permutations of a given lists
  *
  * Base case -> An empty list permutation is an empty list
  *
  * Recursive case -> The permutation of a given list is the concat of a list with the
  * first element if different positions.
*/
permutacion([],[]).
permutacion(L,[X|P]) :- pert_con_resto(X,L,R), permutacion(R,P).

pert_con_resto(X,L,Resto):- concat(L1,[X|L2],L), concat(L1,L2,Resto).

sum([], 0).
sum([Y| L], X):- sum(L, Z), X is Y + Z.

fact(0,1):-!.
fact(X,F):-  X1 is X - 1, fact(X1,F1), F is X * F1.

nat(0).
nat(N):- nat(N1), N is N1 + 1.

%mul(X,Y,M):- nat(M), 0 is M mod X, 0 is M mod Y.
mul(X,Y,M):- nat(N), M is N * X,   0 is M mod Y.

pert_con_resto(X,L,Resto):- concat(L1,[X|L2],L), concat(L1,L2,Resto).

% Alternativa una mica m�s eficient.
%pert_r(X,[X|L],L).
%pert_r(X,[Y|L],[Y|R]):- pert_r(X,L,R).

long([],0).
long([_|L],M):- long(L,N),M is N+1.

subcjto([],[]).  %subcjto(L,S) significa "S es un subconjunto de L".
subcjto([X|C],[X|S]):-subcjto(C,S).
subcjto([_|C],S):-subcjto(C,S).

cifras(L,N):- subcjto(L,S), permutacion(S,P), expresion(P,E),
              N is E, write(E),nl,fail.

expresion([X],X).
expresion(L,E1+E2):- concat(L1,L2,L),  L1\=[],L2\=[],
                     expresion(L1,E1), expresion(L2,E2).
expresion(L,E1-E2):- concat(L1,L2,L),  L1\=[],L2\=[],
                     expresion(L1,E1), expresion(L2,E2).
expresion(L,E1*E2):- concat(L1,L2,L),  L1\=[],L2\=[],
                     expresion(L1,E1), expresion(L2,E2).

% expresion(L,E1//E2):- concat(L1,L2,L),  L1\=[],L2\=[],
%                      expresion(L1,E1), expresion(L2,E2),
% 		     X is E2, X \= 0, 0 is E1 mod E2.


der(X, X, 1):-!.
der(C, _, 0) :- number(C).
der(A+B, X, A1+B1) :- der(A, X, A1), der(B, X, B1).
der(A-B, X, A1-B1) :- der(A, X, A1), der(B, X, B1).
der(A*B, X, A*B1+B*A1) :- der(A, X, A1), der(B, X, B1).
der(sin(A), X, cos(A)*B) :- der(A, X, B).
der(cos(A), X, -sin(A)*B) :- der(A, X, B).
der(e^A, X, B*e^A) :- der(A, X, B).
der(ln(A), X, B*1/A) :- der(A, X, B).


simplifica(E,E1):- unpaso(E,E2),!, simplifica(E2,E1).
simplifica(E,E).

unpaso(A+B,A+C):- unpaso(B,C),!.
unpaso(B+A,C+A):- unpaso(B,C),!.
unpaso(A*B,A*C):- unpaso(B,C),!.
unpaso(B*A,C*A):- unpaso(B,C),!.
unpaso(0*_,0):-!.
unpaso(_*0,0):-!.
unpaso(1*X,X):-!.
unpaso(X*1,X):-!.
unpaso(0+X,X):-!.
unpaso(X+0,X):-!.
unpaso(N1+N2,N3):- number(N1), number(N2), N3 is N1+N2,!.
unpaso(N1*N2,N3):- number(N1), number(N2), N3 is N1*N2,!.
unpaso(N1*X+N2*X,N3*X):- number(N1), number(N2), N3 is N1+N2,!.
unpaso(N1*X+X*N2,N3*X):- number(N1), number(N2), N3 is N1+N2,!.
unpaso(X*N1+N2*X,N3*X):- number(N1), number(N2), N3 is N1+N2,!.
unpaso(X*N1+X*N2,N3*X):- number(N1), number(N2), N3 is N1+N2,!.
%-------------------------------------------------------------------------------

%---------------------------- EXERCICE 2 ---------------------------------------

/** Product: This program multiplies a given list to obtain the product
  *
  * Base case -> Empty list returns 1 (doesn't return 0 because with 0 we are
  * going to obtain 0 anytime)
  *
  * Recursive case -> The product of a given list is the product of the first element
  * of the list with an integer & the product of the rest of the list
*/
prod([], 1).
prod([X|L], P1) :- prod(L, P), P1 is P*X.
%-------------------------------------------------------------------------------

%---------------------------- EXERCICE 3 ---------------------------------------
/** Escalar Product: This program calculates the scalar pruduct for a pair of given list
  *
  * Base case -> The two lists are empty. The product is 0
  *
  * Recursive case -> The scalar product of a pair of lists is the multiplication of
  * the first element of each list plus the scalar product of the rest of the list
*/
pescalar([], [], 0).
pescalar([X1|L1], [X2|L2], P):- pescalar(L1, L2, P1), P is P1 + X1*X2.

%-------------------------------------------------------------------------------

%---------------------------- EXERCICE 4 ---------------------------------------
/** Intersection: This program calculates the intersection for a pair of given lists
  *
  * Base case -> One of the lists is empty. The Intersection is null
  *
  * Recursive case -> If the first element of the first list is in the second list,
  * it must be in the intersection. If the first element is not in the second list,
  * it musnt be in the intersection.
*/
intersec([],_,[]).
intersec([X|L1], L2, [X|L3]):- pertinence(X, L2),!,intersec(L1,L2,L3).
intersec([_|L1], L2, L3):- intersec(L1,L2,L3).

/** Union: This program calculates the union for a pair of given lists
  *
  * Base case -> One of the lists is empty. The Union returns the other list
  *
  * Recursive case -> If the first element of the first list is in the second list,
  * it must be in the intersection. If the first element is not in the second list,
  * it musnt be in the intersection.
*/
union([],L,L).
union([X|L1], L2, L3):- pertinence(X, L2),!,union(L1,L2,L3).
union([X|L1], L2, [X|L3]):- union(L1, L2, L3).
%-------------------------------------------------------------------------------

%---------------------------- EXERCICE 5 ---------------------------------------
/** LastE: This program returns the last element of a given list
  *
  * Base case -> We have a list with only one element. We return this element
  *
  * Recursive case -> If we have a list with more than one element, we call lastE with
  * the same list without the first element.
*/
lastE([X], X).
lastE([_|L], X):- lastE(L, X).

/** Inverse: This program returns the inverse of a given list
  *
  * Base case -> We have an empty list. We return that empty list
  *
  * Recursive case -> We took the first element of the given list and we concat it to
  * the result list. We call inverse with the remaining list.
*/
inverse([], []).
inverse(L, [X|L1]):- concat(L2, [X], L), inverse(L2, L1).
%-------------------------------------------------------------------------------

%---------------------------- EXERCICE 6 ---------------------------------------
/**NOTE: The order of the expressions in prolog is important, because it determinate the
  * order of the backtrack in the backtrack queue. For example, calling fib(F1, N1) before calling
  * F1 is F - 1 will give an error.
  *
  * Fib: This program calculates the fibbonacci succession for a given step
  *
  * Base case -> fib(1) = 1. fib(2) = 1
  *
  * Recursive case -> We call fib(F, N) for the two numbers before the actual one.
  * Later we sum them.
*/
fib(1, 1).
fib(2, 1).
fib(F, N):- F > 2,  F1 is F - 1, fib(F1, N1), F2 is F - 2, fib(F2, N2), N is N1 + N2.

fib2(1,1).
fib2(2,1).
fib2(N,F):- N > 2, N1 is N-1, N2 is N-2, fib2(N1,F1), fib2(N2,F2), F is F1+F2.
%-------------------------------------------------------------------------------

%---------------------------- EXERCICE 7 ---------------------------------------
/** dados: This program returns all the possible combinations to obtain a puntuation by throwing
* a finite number of dices
*
* Base case -> If we throw 0 dices and we want to obtain 0 points, we return an empty list
*
* Recursive case -> We took a number between 1 and 6. We change accordingly the number of remaining
* dices and the punctuation accordingly and we call dados again.
*/
dados(0, 0, []).
dados(P, N, [X | L]):- N < 0, pertinence(X, [1, 2, 3, 4, 5, 6]), M is P - X, Q is N - 1, dados(M, Q, L).
%-------------------------------------------------------------------------------

%---------------------------- EXERCICE 8 ---------------------------------------
/** suma_demas: Programa que devuelve true si uno de los elementos de la lista pasada como parámetro
* es la suma del resto.
*
* Funcionamiento -> vamos dividiendo la lista en un elemento y el resto, e intentamos sumar el resto
* de elementos. Si pert_con_resto() y suma() unifica, acabamos la ejecución del algoritmo con ! (impedimos
* que se haga backtrack desde ahi)
*
*/
suma_demas(L) :- pert_con_resto(X,L,R), sum(R,X), !.
%-------------------------------------------------------------------------------

%---------------------------- EXERCICE 9 ---------------------------------------
/** suma_ants: Programa que devuelve true si uno de los elementos de la lista pasada como parámetro
* es la suma de los elementos anteriores.
*
* Funcionamiento -> vamos eliminando el último elemento de la lista cada vez, y comprobamos si este
* elemento eliminado es la suma de los elementos anteriores. Si se cumple la condición, paramos con !
*
*/
suma_ants(L) :- concat(L1,[X|_],L), sum(L1,X), !.
%-------------------------------------------------------------------------------

%---------------------------- EXERCICE 10 --------------------------------------

car([],[]).
car( [X|L] , [ [X,N1] |Cr] ):-car(L,C),pert_con_resto([X,N],C,Cr),!,N1 is N+1.
car( [X|L] , [ [X,1]   |C] ):-car(L,C).

car(L):-car(L,C),write(C).
%-------------------------------------------------------------------------------

%---------------------------- EXERCICE 11 --------------------------------------
/** esta_ordenada: Programa que devuelve true si la lista está ordenada. Sino devuelve false
*
* Funcionamiento -> Comparamos el primer elemento de la lista con el siguiente. Si el primero es mayor
* que el segundo, devuelve false. Sino, va repitiendo hasta unificar con la lista vacía, devolviendo true.
*/
esta_ordenada([]).
esta_ordenada([X | [Y | L]]):- X =< Y, esta_ordenada([Y | L]).
esta_ordenada([_|[]]):- esta_ordenada([]).
%-------------------------------------------------------------------------------

%---------------------------- EXERCICE 12 --------------------------------------
/** ordenación: Programa que dada una lista, te la devuelve ordenada.
*
* Funcionamiento -> Vamos permutando los elementos de una lista, hasta que una de las permutaciones
* es la lista ordenada. En ese momento paramos.
*/
ordenacion(L1, L2):- permutacion(L1, L2), esta_ordenada(L2), !.
%-------------------------------------------------------------------------------

%---------------------------- EXERCICE 13 --------------------------------------
% Sea n la longitud de la lista L.

% esta_ordenada(L) tiene complejidad lineal, ya que se hacen n-1 comparaciones
% en el peor caso (cuando la lista L est� ordenada).
%
% En el peor caso el predicado ordenacion(L,LO) tiene que generar todas las
% permutaciones (hay n!) y comprobar que si est�n ordenadas. Por tanto en el
% peor caso el coste es (n!)n < (n+1)!, donde n es la longitud de la lista L.
% Complejidad factorial en n+1.
% N�tese que n! crece muy r�pido: 2^n < n! a partir de n=4.
%-------------------------------------------------------------------------------

%---------------------------- EXERCICE 14 --------------------------------------
/** ordenación por insercion: Programa que dada una lista, te la devuelve ordenada.
*
* Funcionamiento -> Lo que vamos haciendo es recorrernos la lista inicial e ir insertando en
* la lista final cada elemento de la lista inicial en la posición en la que deberia ir.
*/
ord([], []).
ord([X | L], L1):- ord(L, L2), insercion(X, L2, L1).

insercion(X, [], [X]).
insercion(X, [Y |L], [X, Y|L]):- X =< Y.
insercion(X, [Y | L1], [Y | L2]):- X > Y, insercion(X, L1, L2).
%-------------------------------------------------------------------------------

%---------------------------- EXERCICE 15 --------------------------------------
% Sea n la longitud de la lista.

% Insertar un elemento en una lista ordenada tiene complejidad lineal, ya
% que en el peor caso hay que compararlo con los n elementos de la lista.

% Ordenaci�n por inserci�n inserta el �ltimo elemento en la lista vac�a,
% el pen�ltimo en una lista de un elemento, y as� sucesivamente. Se hacen
% 1 + 2 + ... + n-1 = n(n-1)/2 comparaciones en el peor caso. Complejidad
% cuadr�tica.

% En el mejor caso (la lista ya est� ordenada) la complejidad es lineal.
%-------------------------------------------------------------------------------

%---------------------------- EXERCICE 16 --------------------------------------
/** split: Función que divide una lista en dos, de longitud igual o como mucho con
* una diferéncia de 1 elemento (depende de si la lista es par o impar).
*/
split([], [], []).
split([X], [X], []).
split([X|[Y|L]], [X | L1], [Y | L2]):- split(L, L1, L2).

/** mergesort: Función que hace un mergesort de la lista inicial
*
* La idea tras esta función es la misma que hay tras el mergesort. Primero, dividimos la lista
* inicial en dos sublistas. Después, aplicamos recursivamente mergesort sobre cada una de las
* sublistas. Finalmente, las juntamos.
*/
mergesort([], []):- !.
mergesort([X], [X]):- !.
mergesort(Li, Lf):- split(Li, L1i, L2i), mergesort(L1i, L1f), mergesort(L2i, L2f), merge(L1f, L2f, Lf).

/** merge: Función que une dos listas en una de forma ordenada (siempre y cuando las sublistas estén
* ordenadas)
*
* Funcionamiento -> Mientras tengamos elementos en las dos listas vamos poniendo el elemento menor de
* las dos listas en la lista final. Cuando nos acabemos una de las dos listas, ponemos en la lista final
* el resto de la lista que nos queda, ya que sabemos que está ordenada.
*
* NOTE: Tener en cuenta que ! no acaba la ejecución del código. ! lo que hace es limpiar la pila de
* backtrack (lo que equivale a decir: si hemos llegado hasta aqui, esta forma de hacer las cosas es buena
* y no me interesa que busques otra forma de hacer lo mismo)
*/
merge(L, [], L):- !.
merge([], L, L).
merge([X | L1], [Y | L2], [X | L]):- X =< Y, !, merge(L1, [Y | L2], L).
merge([X | L1], [Y | L2], [Y | L]):- merge([X | L1], L2, L).
%-------------------------------------------------------------------------------

%---------------------------- EXERCICE 17 --------------------------------------
/** diccionario: Programa que genera totas las palabras posibles de longitud N a partir de un alfabeto
* A, ordenadas de forma alfabética.
*
* Funcionamiento -> Lo que se hace es ir cogiendo los elementos de L (los símbolos del alfabeto),
* para ir permutando los elementos e imprimiendo los resultados.
*
* NOTE: nl Significa que saltamos de linea al escribir.
*/
diccionario(A,N):-  nperts(A,N,S), escribir(S), fail.

nperts(_,0,[]):-!.
nperts(L,N,[X|S]):- pertinence(X,L), N1 is N-1, nperts(L,N1,S).

escribir([]):-write(' '),nl,!.
escribir([X|L]):- write(X), escribir(L).
%-------------------------------------------------------------------------------

%---------------------------- EXERCICE 18 --------------------------------------
/** palindromos: Programa que genera todos los palindromos posibles para una lista de símbolos
* dada.
*
* Funcionamiento -> La idea es ir haciendo permutaciones sobre la lista inicial, y tras cada permutación
* comprobar si la lista resultado es capicua.
*
* NOTE: Una forma de acceder al último elemento de una lista es mediante un concat de una lista ficticia
* con el último elemento de la misma.
*/
palindromos(L) :- generarCapicua(L, C), escribir(C), fail.

generarCapicua(L, L1) :- permutacion(L, L1), comprobarCapicua(L1).

comprobarCapicua([]).
comprobarCapicua([_]):- !.
comprobarCapicua([X | L1]):- concat(L, [X], L1), comprobarCapicua(L).

% NOTE: Si no queremos que escriba repetidos se puede usar setof.
palindroms(L) :- setof(P,(permutacion(L,P), comprobarCapicua(P)),S), write(S).
%-------------------------------------------------------------------------------

%---------------------------- EXERCICE 19 --------------------------------------
suma([],[],[],C,C).
suma([X1|L1],[X2|L2],[X3|L3],Cin,Cout) :-
	X3 is (X1 + X2 + Cin) mod 10,
	C  is (X1 + X2 + Cin) //  10,
	suma(L1,L2,L3,C,Cout).


send_more_money1 :-

	L = [S, E, N, D, M, O, R, Y, _, _],
	permutacion(L, [0,1,2,3,4,5,6,7,8,9]),
	suma([D, N, E, S], [E, R, O, M], [Y, E, N, O], 0, M),

	write('S = '), write(S), nl,
	write('E = '), write(E), nl,
	write('N = '), write(N), nl,
	write('D = '), write(D), nl,
	write('M = '), write(M), nl,
	write('O = '), write(O), nl,
	write('R = '), write(R), nl,
	write('Y = '), write(Y), nl,
	write('  '), write([S,E,N,D]), nl,
	write('  '), write([M,O,R,E]), nl,
	write('-------------------'), nl,
	write([M,O,N,E,Y]), nl.


send_more_money2 :-

	L = [0,1,2,3,4,5,6,7,8,9],
	pert_con_resto(M,  [0,1], _),
	pert_con_resto(M,  L,  L0),
	pert_con_resto(O, L0, L1),
	pert_con_resto(R, L1, L2),
	pert_con_resto(Y, L2, L3),
	pert_con_resto(S, L3, L4),
	pert_con_resto(E, L4, L5),
	pert_con_resto(N, L5, L6),
	pert_con_resto(D, L6, _),
	suma([D, N, E, S], [E, R, O, M], [Y, E, N, O], 0, M),

	write('S = '), write(S), nl,
	write('E = '), write(E), nl,
	write('N = '), write(N), nl,
	write('D = '), write(D), nl,
	write('M = '), write(M), nl,
	write('O = '), write(O), nl,
	write('R = '), write(R), nl,
	write('Y = '), write(Y), nl,
	write('  '), write([S,E,N,D]), nl,
	write('  '), write([M,O,R,E]), nl,
	write('-------------------'), nl,
	write([M,O,N,E,Y]), nl.

%-------------------------------------------------------------------------------

%---------------------------- EXERCICE 20 --------------------------------------
% simplif: solucion ya venia en la lista de ejemplos
%-------------------------------------------------------------------------------

%---------------------------- EXERCICE 21 --------------------------------------
mis:- camino( [lado1,3,3], [lado2,0,0], [[lado1,3,3]] ).

camino(Fin,Fin,Cam):- inverso(Cam,Sol), write(Sol), nl.
camino(Ini,Fin,Cam):- paso(Ini,E), novisitado(E,Cam), camino(E,Fin,[E|Cam]).

novisitado(E,Cam):- pert(E,Cam), !,fail.
novisitado(_,_).

paso( [lado1,M1,C1], [lado2,M2,C2] ):- pasan(M,C), M2 is M1-M, C2 is C1-C, safe(M2,C2).
paso( [lado2,M1,C1], [lado1,M2,C2] ):- pasan(M,C), M2 is M1+M, C2 is C1+C, safe(M2,C2).

pasan(M,C):- member( [M,C], [ [0,1], [0,2], [1,0], [1,1], [2,0] ] ).

safe(M,C):- M>=0, M=<3, C>=0, C=<3, nocomen( M, C),
            M1 is 3-M,  C1 is 3-C,  nocomen(M1,C1).

nocomen(0,_).
nocomen(M,C):- M>=C.
%-------------------------------------------------------------------------------
