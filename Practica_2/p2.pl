/** This program multiplies a given list to obtain the product
  *
  * Base case -> Empty list returns 1 (doesn't return 0 because with 0 we are
  * going to obtain 0 anytime)
  *
  * Recursive case -> The product of a given list is the product of the first element
  * of the list with an integer & the product of the rest of the list
*/
prod([], 1).
prod([X|L], P1) :- prod(L, P), P1 is P*X.
