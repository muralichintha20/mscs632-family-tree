% ============================================================
% family_tree.pl
% MSCS-632 Advanced Programming Languages
% Family Tree Program in Prolog
% Author: Murali Krishna Chintha
% ============================================================
%
% This program models a four-generation family using Prolog
% facts and derives higher-level relationships (grandparent,
% sibling, cousin, ancestor, descendant) through rules and
% recursion.
%
% Naming convention for the parent fact:
%   parent(Parent, Child)  ->  "Parent is a parent of Child"
% ============================================================


% ------------------------------------------------------------
% 1. BASIC RELATIONSHIPS (FACTS)
% ------------------------------------------------------------

% --- Gender facts ---
male(john).
male(michael).
male(robert).
male(david).
male(james).
male(thomas).

female(mary).
female(karen).
female(linda).
female(susan).
female(emma).
female(olivia).

% --- Parent facts: parent(Parent, Child) ---

% Generation 1 -> Generation 2 (john + mary)
parent(john,  michael).
parent(john,  linda).
parent(mary,  michael).
parent(mary,  linda).

% Generation 2 -> Generation 3 (michael + karen)
parent(michael, david).
parent(michael, susan).
parent(karen,   david).
parent(karen,   susan).

% Generation 2 -> Generation 3 (linda + robert)
parent(linda,  james).
parent(linda,  emma).
parent(robert, james).
parent(robert, emma).

% Generation 3 -> Generation 4 (david + olivia)
parent(david,  thomas).
parent(olivia, thomas).


% ------------------------------------------------------------
% 2. DERIVED RELATIONSHIPS (RULES)
% ------------------------------------------------------------

% father(X, Y): X is the father of Y
father(X, Y) :- parent(X, Y), male(X).

% mother(X, Y): X is the mother of Y
mother(X, Y) :- parent(X, Y), female(X).

% child(X, Y): X is a child of Y
child(X, Y) :- parent(Y, X).

% grandparent(X, Y): X is a grandparent of Y
% (a two-level chain through an intermediate parent Z)
grandparent(X, Y) :- parent(X, Z), parent(Z, Y).

% sibling(X, Y): X and Y share at least one parent and differ
sibling(X, Y) :- parent(P, X), parent(P, Y), X \== Y.

% cousin(X, Y): the parents of X and Y are siblings
cousin(X, Y) :- parent(PX, X), parent(PY, Y), sibling(PX, PY).


% ------------------------------------------------------------
% 3. RECURSIVE LOGIC
% ------------------------------------------------------------

% ancestor(X, Y): X is an ancestor of Y
% Base case: a parent is an ancestor.
ancestor(X, Y) :- parent(X, Y).
% Recursive case: a parent of an ancestor is also an ancestor.
ancestor(X, Y) :- parent(X, Z), ancestor(Z, Y).

% descendant(X, Y): X is a descendant of Y (inverse of ancestor)
descendant(X, Y) :- ancestor(Y, X).


% ------------------------------------------------------------
% 4. DUPLICATE-FREE HELPER QUERIES
% ------------------------------------------------------------
% Because both a mother and a father are recorded for each
% child, the plain sibling/2 and cousin/2 rules can succeed
% more than once for the same pair. The predicates below use
% setof/3 to return each related person exactly once.

% siblings_of(Person, List): unique siblings of Person
siblings_of(Person, List) :-
    setof(S, sibling(Person, S), List).

% cousins_of(Person, List): unique cousins of Person
cousins_of(Person, List) :-
    setof(C, cousin(Person, C), List).

% descendants_of(Person, List): unique descendants of Person
descendants_of(Person, List) :-
    setof(D, descendant(D, Person), List).
