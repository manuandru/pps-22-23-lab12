% map(+L, +Mapper, -Lo)
% where Mapper=mapper(I,O,UNARY_OP)
% e.g. Mapper=mapper(X, Y, Y is X+1)
% map([10,20,30], mapper(X, Y, Y is X+1), L). -> L/[11,21,31]
map([], _, []).
map([H|T], M, [H2|T2]) :- map(T, M, T2), copy_term(M, mapper(H, H2, OP)), call(OP).



% filter(+L, +Predicate, -Lo)
% where Predicate=predicate(I, UNARY_OP)
% e.g. Predicate=predicate(X, X > 10)
% filter([10,20,30], predicate(X, X > 10), L). -> L/[20,30]
filter([], _, []).
filter([H|T], F, [H|T2]) :- filter(T, F, T2), copy_term(F, predicate(H, Test)), call(Test), !.
filter([H|T], F, T2) :- filter(T, F, T2).