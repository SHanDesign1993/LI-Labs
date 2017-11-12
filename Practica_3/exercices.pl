concat([],L,L).
concat([X|L1],L2,[X|L3]):- concat(L1,L2,L3).

pertinence(X, [X|_]).
pertinence(X, [_|L]):- pertinence(X, L).

%---------------------------- EXERCICE 1 ---------------------------------------
/** Delete repetitions: Borra repeticiones de una lista
  *
  * Caso base -> Una lista vacía retorna una lista vacía
  *
  * Caso recursivo -> Si el primer elemento de una lista se encuentra en el resto de la lista,
  * no lo añadimos a la lista resultado. En caso contrario si lo hacemos
*/
delete_repetitions([], []).
delete_repetitions([X | L], L2):- pertinence(X, L), !, delete_repetitions(L, L2).
delete_repetitions([X | L], [X | L2]):- delete_repetitions(L, L2).

delete_element(_, [], []).
delete_element(X, [Y | L], L2):- X is Y, delete_element(X, L, L2).
delete_element(X, [Y | L], [Y | L2]):- delete_element(X, L, L2).
/** Flatten L: Funcion que aplana listas (convierte listas de listas en listas normales).
  *
  * Caso base -> Una lista vacía retorna una lista vacía
  *
  * Caso recursivo -> Hay dos casos. Si el primer elemento de la lista grande es una lista, lo hemos de aplanar
  * antes de concatenarlo a la lista resultado. Si el primer elemento no es una lista, lo concatenamos directamente
  * a la lista resultado
  *
  * NOTE: is_list(L) devuelve true si L es lista (incluye lista vacía). Sino devuelve false.
*/
flatten_l([], []).
flatten_l([X | L1], L):- is_list(X), flatten_l(X, L2), flatten_l(L1, L3), concat(L2, L3, L).
flatten_l([X | L1], L):- flatten_l(L1, L2), concat([X], L2, L).

%Combinación de los dos anteriores. Si flatten_l unifica, podemos eliminar la pila de backtrack
flatten_nr(L1, L2):- flatten_l(L1, L), !, reverse(L, L3), delete_repetitions(L3, L4), reverse(L4, L2).
%-------------------------------------------------------------------------------

%---------------------------- EXERCICE 2 ---------------------------------------
left_house(L, [[Z | Y] | _], X):- L = [Z | Y], Z > 1, X is Z - 1.
left_house(L, [_ | L1], X):- left_house(L, L1, X).
left_house(_, [], _):- fail.

near_house(L, [[Z | Y] | _], X):- L = [Z | Y], Z > 1, X is Z - 1.
near_house(L, [[Z | Y] | _], X):- L = [Z | Y], Z < 5, X is Z + 1.
near_house(L, [_ | L1], X):- near_house(L, L1, X).
near_house(_, [], _):- fail.

write_sol([]).
write_sol([X | L]):- write(X), nl, write_sol(L).

casas:-	Sol = [	[1,A1,B1,C1,D1,E1],
		[2,A2,B2,C2,D2,E2],
		[3,A3,B3,C3,D3,E3],
		[4,A4,B4,C4,D4,E4],
		[5,A5,B5,C5,D5,E5] ],
        member([_, 'rojo', _, _, _, 'Peru'], Sol), %1
        member([_, _, _, 'perro', _, 'Francia'], Sol), %2
        member([_, _, 'pintor', _, _, 'Japon'], Sol), %3
        member([_, _, _, _, 'ron', 'China'], Sol), %4
        member([1, _, _, _, _, 'Hungria'], Sol), %5
        member([_, 'verde', _, _, 'conyac', _], Sol), %6
        member([N, 'verde', _, _, _, _], Sol), left_house([_, 'blanca', _, _, _, _], Sol, N), %7 (?)
        member([_, _, 'escultor', 'caracol', _, _], Sol), %8
        member([_, 'amarillo', 'actor', _, _, _], Sol), %9
        member([3, _, _, _, 'cava', _], Sol), %10
        member([M, _, _, 'caballo', _, _], Sol), near_house([_, _, 'actor', _, _, _], Sol, M), %11 (?)
        member([K, _, _, _, _, 'Hungria'], Sol), near_house([_, 'azul', _, _, _, _], Sol, K), %12 (?)
        member([_, _, 'notario', _, 'whisky', _], Sol), %13
        member([X, _, _, 'ardilla', _, _], Sol), near_house([_, _, 'medico', _, _, _], Sol, X), %14 (?)
	    write_sol(Sol), nl.
%-------------------------------------------------------------------------------

%---------------------------- EXERCICE 3 ---------------------------------------
nqueens(N):- n_queens(1, 1, N, []).

%---- Doesn't work ----
n_queens(X, Y, N, L):-
	X < N + 1,
	Y < N + 1,
	safe_queen(Y, X, L, 1),
	concat(L, [Y], L1),
	X1 is X + 1,
	n_queens(X1, 1, N, L1).

n_queens(X, _, N, L):-
	X >= N + 1,
	%write(L).
	display_sol(1, N, L).

n_queens(X, Y, N, L):-
	Y < N + 1,
	X < N + 1,
	Y1 is Y + 1,
	n_queens(X, Y1, N, L).

%-------------------
%------ Works ------
safe_queen(Y, N, [], Z).
safe_queen(Y, Z, [X | L], N):-
	\+ X = Y,
	R1 is abs(Z - N),
	R2 is abs(Y - X),
	\+ R1 = R2,
	N1 is N + 1,
	safe_queen(Y, Z, L, N1).

display_sol(X, N, []).

display_sol(X, N, [_ | L]):-
	X >= N + 1,
	nl,
	display_sol(1, N, L).

display_sol(X, N, [Y | L]):-
	X = Y,
	write('X '),
	X1 is X + 1,
	display_sol(X1, N, [Y | L]).

display_sol(X, N, [Y | L]):-
	\+ X = Y,
	write('. '),
	X1 is X + 1,
	display_sol(X1, N, [Y | L]).

%-------------------------------------------------------------------------------
