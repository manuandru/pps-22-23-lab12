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



% reduce(+L, +OP, -O)
% where OP=op(I1, I2, BINARY_OP, O)
% e.g. OP=op(X, Y, O is X + Y, O)
% reduce([10,20,30], 0, op(X, Y, O is X + Y, O), R). -> R / 60.
reduce([H|T], OP, O) :- reduce(T, H, OP, O).
reduce([], Acc, _, Acc).
reduce([H|T], Acc, Op, R) :- copy_term(Op, op(H, Acc, CopyOP, O)), call(CopyOP), reduce(T, O, Op, R).



% foldleft(+L, +D, +OP, -O)
% where D is the default value
% where OP=op(I1, I2, BINARY_OP, O)
% e.g. OP=op(X, Y, O is X + Y, O)
% foldleft([10, 20, 30], 0, op(X, Y, O is X + Y, O), R). -> R / 60
% foldleft([10, 20, 30], [],op(H, T, O = [H|T], O), R). -> R / [30, 20, 10]
foldleft([], Acc, _, Acc).
foldleft([H|T], Acc, OP, R) :- copy_term(OP, op(H, Acc, CopyOP, O)), call(CopyOP), foldleft(T, O, OP, R).



% foldright(+L, +D, +OP, -O)
% where D is the default value
% where OP=op(I1, I2, BINARY_OP, O)
% e.g. OP=op(X, Y, O is X + Y, O)
% foldright([10, 20, 30], 0, op(X, Y, O is X + Y, O), R). -> R / 60
% foldright([10, 20, 30], 0, op(X, Y, O is X - Y, O), R). -> R / 20
foldright([], D, _, D).
foldright([H|T], D, OP, R) :- foldright(T, D, OP, O), copy_term(OP, op(H, O, CopyOP, R)), call(CopyOP).