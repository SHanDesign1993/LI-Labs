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

intersec([],_,[]).
intersec([X|L1], L2, [X|L3]):- pertinence(X, L2),!,intersec(L1,L2,L3).
intersec([_|L1], L2, L3):- intersec(L1,L2,L3).
