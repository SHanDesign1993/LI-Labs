# LI-Labs

In this repository the user can find all the practises made for the subject of Logic on the Informatics (LI) made on the Facultat de Informàtica de Barcelona on the autumn semester of 2017 - 2018.

The repository is divided into 6 practises, explained in the following sections.

### Dependencies:
For the practise 1 is needed a C++ compiler. In the case that the user doesn't know the compiler to use he can install g++ by using the following command:
```
sudo apt-get install g++
```
For the rest of the practises a prolog compiler is needed. To install one of them, use the following commands:
```
sudo add-apt-repository ppa:swi-prolog/stable
sudo apt-get update
sudo apt-get install swi-prolog
```

In nearly all the practises the SAT-Solver picosat is needed. To install it, use the following commands:
```
sudo apt-get update
sudo apt-get install picosat
```

### Practises:
##### · Practise 1:
This practise consists into modify a SAT-Solver in order to improve its performance. The way to do this is applying a soft version of VSIDS algorithm for conflict resolution in combination with the propagation of the clauses which contains the same literal with the opposite sign than the chosen. 
##### · Practise 2:
This practise consists into solving some simple Prolog problems. This problems can be found in the website of LI.
##### · Practise 3:
This practise consists into solving the problem of convert a bunch of lists into a single one, n-queens and the Einstein's problem.
##### · Practise 4:
This practise consists into generate the schedule of a group of nurses by generating clauses using Prolog that can be solved using a SAT-Solver (picosat).
##### · Practise 5:
This practise consists into fill a banner using some given pieces. To do that the idea is generate clauses using Prolog that can be solved using a SAT-Solver (picosat).
##### · Practise 6:
This practise consists into solving two problems (tomografias y squares) by using the clpfd library.
