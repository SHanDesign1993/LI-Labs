/** This program calculates the scalar pruduct for a pair of given list
  *
  * Base case -> The two lists are empty. The product is 0
  *
  * Recursive case -> The scalar product of a pair of lists is the multiplication of
  * the first element of each list plus the scalar product of the rest of the list
*/
pescalar([], [], 0).
pescalar([X1|L1], [X2|L2], P):- pescalar(L1, L2, P1), P is P1 + X1*X2.
