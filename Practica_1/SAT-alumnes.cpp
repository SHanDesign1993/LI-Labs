#include <iostream>
#include <stdlib.h>
#include <algorithm>
#include <vector>
using namespace std;

#define UNDEF -1
#define TRUE 1
#define FALSE 0

uint numVars;
uint numClauses;
vector<vector<int> > clauses;
vector<int> model;
vector<int> modelStack;
uint indexOfNextLitToPropagate;
uint decisionLevel;

vector<vector<int> > pos_lit_apparitions;
vector<vector<int> > neg_lit_apparitions;
vector<int> lit_score;

//-------------------------------- COSES A TOCAR -------------------------------
void readClauses( ){
  // Skip comments
  char c = cin.get();
  while (c == 'c') {
    while (c != '\n') c = cin.get();
    c = cin.get();
  }
  // Read "cnf numVars numClauses"
  string aux;
  cin >> aux >> numVars >> numClauses;
  clauses.resize(numClauses);
  pos_lit_apparitions.resize(numVars + 1);
  neg_lit_apparitions.resize(numVars + 1);
  lit_score.resize(numVars + 1);
  // Read clauses
  for (uint i = 0; i < numClauses; ++i) {
    int lit;
    while (cin >> lit and lit != 0) {
      clauses[i].push_back(lit);
      if (lit > 0) {
        pos_lit_apparitions[lit].push_back(i);
        ++lit_score[lit];
      }
      else {
        neg_lit_apparitions[-lit].push_back(i);
        ++lit_score[-lit];
      }
    }
  }
}

//------------------------------------------------------------------------------

//--------------------------------------- COSES QUE NO CAL TOCAR ---------------
int currentValueInModel(int lit){
  if (lit >= 0) return model[lit];
  else {
    if (model[-lit] == UNDEF) return UNDEF;
    else return 1 - model[-lit];
  }
}


void setLiteralToTrue(int lit){
  modelStack.push_back(lit);
  if (lit > 0) model[lit] = TRUE;
  else model[-lit] = FALSE;
}

void checkmodel(){
  for (uint i = 0; i < numClauses; ++i){
    bool someTrue = false;
    for (uint j = 0; not someTrue and j < clauses[i].size(); ++j)
      someTrue = (currentValueInModel(clauses[i][j]) == TRUE);
    if (not someTrue) {
      cout << "Error in model, clause is not satisfied:";
      for (uint j = 0; j < clauses[i].size(); ++j) cout << clauses[i][j] << " ";
      cout << endl;
      exit(1);
    }
  }
}


void backtrack(){
  uint i = modelStack.size() -1;
  int lit = 0;
  while (modelStack[i] != 0){ // 0 is the DL mark
    lit = modelStack[i];
    model[abs(lit)] = UNDEF;
    modelStack.pop_back();
    --i;
  }
  // at this point, lit is the last decision
  modelStack.pop_back(); // remove the DL mark
  --decisionLevel;
  indexOfNextLitToPropagate = modelStack.size();
  setLiteralToTrue(-lit);  // reverse last decision
}

//-------------------------------------------------------------------------------------------------------------------------------------
//--------------------------------------- COSES QUE CAL TOCAR -------------------------------------------------------------------------



//El segon dels punts a canviar. Actualment es mira TOT després de cada decisió, pero
//en realitat només cal mirar les clàusules a on hi influeix el valor sobre el que hem
//decidit
bool propagateGivesConflict() {
  cout << "propagateGivesConflict entered" << endl;
  /*int i = 0;
  while ( i < modelStack.size() ) {
    cout << modelStack[i] << " " << endl;
    ++i;
  }*/

  while ( indexOfNextLitToPropagate < modelStack.size() ) {
    ++indexOfNextLitToPropagate;
    //cout << "indexOfNextLitToPropagate: " << indexOfNextLitToPropagate << endl;
    /*for (uint i = 0; i < numClauses; ++i) {
      bool someLitTrue = false;
      int numUndefs = 0;
      int lastLitUndef = 0;
      for (uint k = 0; not someLitTrue and k < clauses[i].size(); ++k){
        int val = currentValueInModel(clauses[i][k]);
        if (val == TRUE) someLitTrue = true;
        else if (val == UNDEF){
            ++numUndefs;
            lastLitUndef = clauses[i][k]; }
      }
      if (not someLitTrue and numUndefs == 0) {
        return true; // conflict! all lits false
      }
      else if (not someLitTrue and numUndefs == 1) setLiteralToTrue(lastLitUndef);
    }*/
    if (modelStack[indexOfNextLitToPropagate] < 0) {
        cout << "Negative literal: " << modelStack[indexOfNextLitToPropagate] << endl;
        for (uint i = 0; i < pos_lit_apparitions[modelStack[indexOfNextLitToPropagate]].size(); ++i) {
          cout << "Travelling across apparitions" << endl;
          bool someLitTrue = false;
          int numUndefs = 0;
          int lastLitUndef = 0;
          for (uint k = 0; not someLitTrue and k < clauses[pos_lit_apparitions[modelStack[indexOfNextLitToPropagate] ][i]].size(); ++k){
            cout << "Travelling through a clause" << endl;
            int val = currentValueInModel(clauses[pos_lit_apparitions[modelStack[indexOfNextLitToPropagate] ][i]][k]);
            if (val == TRUE) someLitTrue = true;
            else if (val == UNDEF){
                ++numUndefs;
                lastLitUndef = clauses[pos_lit_apparitions[modelStack[indexOfNextLitToPropagate] ][i]][k]; }

          }
          if (not someLitTrue and numUndefs == 0) {
            lit_score[-modelStack[indexOfNextLitToPropagate]] += 3;
            cout << "propagateGivesConflict exited" << endl;
            return true; // conflict! all lits false
          }
          else if (not someLitTrue and numUndefs == 1) setLiteralToTrue(lastLitUndef);
        }
     }
     else if (modelStack[indexOfNextLitToPropagate] > 0){
       cout << "Positive literal: " << modelStack[indexOfNextLitToPropagate] << endl;
         for (uint i = 0; i < neg_lit_apparitions[-modelStack[indexOfNextLitToPropagate] ].size(); ++i) {
           cout << "Travelling across apparitions" << endl;
           bool someLitTrue = false;
           int numUndefs = 0;
           int lastLitUndef = 0;
           for (uint k = 0; not someLitTrue and k < clauses[neg_lit_apparitions[-modelStack[indexOfNextLitToPropagate] ][i]].size(); ++k){
             cout << "Travelling through a clause" << endl;
             int val = currentValueInModel(clauses[neg_lit_apparitions[-modelStack[indexOfNextLitToPropagate] ][i]][k]);
             if (val == TRUE) someLitTrue = true;
             else if (val == UNDEF){
                 ++numUndefs;
                 lastLitUndef = clauses[neg_lit_apparitions[-modelStack[indexOfNextLitToPropagate] ][i]][k]; }

           }
           if (not someLitTrue and numUndefs == 0) {
             lit_score[modelStack[indexOfNextLitToPropagate]] += 3;
             cout << "propagateGivesConflict exited" << endl;
             return true; // conflict! all lits false
           }
           else if (not someLitTrue and numUndefs == 1) setLiteralToTrue(lastLitUndef);
         }
     }
  }
  cout << "propagateGivesConflict exited" << endl;
  return false;
}




//Primera cosa a canviar, actualment agafa el primer literal que troba i no ha estat usat abans
// Heuristic for finding the next decision literal:
int getNextDecisionLiteral(){
  //cout << "getNextDecisionLiteral entered" << endl;
  int aux_score = -1;
  int aux_lit = 0;
  for (uint i = 1; i <= numVars; ++i) {
    if (lit_score[i] > aux_score && model[i] == UNDEF) {
      aux_score = lit_score[i];
      aux_lit = i;
    }
  }
  //cout << "getNextDecisionLiteral exited" << endl;
  return aux_lit; // returns 0 when all literals are defined
}
//-------------------------------------------------------------------------------------------------------------------------------------


int main(){
  //Llegeix el numVar, numClausules i les Clausules
  readClauses();
  //Adapta el tamany del model al del número de variables, i l'inicialitza a -1
  model.resize(numVars+1,UNDEF);
  //Index del següent valor sobre el que farem la propagació
  indexOfNextLitToPropagate = 0;
  //Enter que indica quantes decisions hem pres fins ara
  decisionLevel = 0;

  // Comprobació inicial de les clàusules amb un únic paràmetre. Si alguna fos falsa, la preposició sería directament insatisfactible
  for (uint i = 0; i < numClauses; ++i)
    //Agafem només les clausules amb un únic element
    if (clauses[i].size() == 1) {
      //Agafem l'element
      int lit = clauses[i][0];
      //Comprobem el seu valor al model
      int val = currentValueInModel(lit);
      //Si el valor es fals, la proposició és directament insatisfactible
      if (val == FALSE) {
          cout << "UNSATISFIABLE" << endl;
          return 10;
    }
      //Si el valor es indefinit, el posem a true.
      else if (val == UNDEF) setLiteralToTrue(lit);
    }

  //Nucli del SAT-Solver. Itera fins trobar que la proposició és satisfactible o no.
  while (true) {
    //Aquesta funció fa les propagacions adient per la decisió anterior, si en alguna d'aquestes propagacions troba un conflicte, retorna true (sino retorna false)
    while ( propagateGivesConflict() ) {
      //Si hi ha conflictes i no hem pres cap decisió, vol dir que el problema es insatisfactible
      if ( decisionLevel == 0) {
          cout << "UNSATISFIABLE" << endl;
          return 10;

    }
      //Si hi ha decisions preses amb anterioritat, desfem la última que haguem fet
      backtrack();
    }
    //Agafem el següent valor sobre el que prendrem una decisió
    int decisionLit = getNextDecisionLiteral();
    //Si el valor es 0, vol dir que no queden valors sobre els que prendre decisions, ergo ja haurem trobat un model que podria ser vàlid
    if (decisionLit == 0) {
        //Fem una comprobació de que el model sigui vàlid. Si no ho és ho indicarem per pantalla i s'acabara la execució del programa amb error
        checkmodel();
        //Si no s'ha acabat la execució del programa, voldrà dir que el programa és satisfactible
        cout << "SATISFIABLE" << endl;
        return 20;

    }
    //És fa push d'un 0, per indicar que ens trobem a un nou nivell de decisió (són "separadors")
    modelStack.push_back(0);
    //Augmentem l'index del següent literal que haurem de propagar
    ++indexOfNextLitToPropagate;
    //Augmentem les decisions preses
    ++decisionLevel;
    //Afegim el següent literal sobre el que prendrem la decisió a la pila
    setLiteralToTrue(decisionLit);    // now push decisionLit on top of the mark
} //*/
}
