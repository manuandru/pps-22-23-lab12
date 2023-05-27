init(s(0,0)). % initial condition
goal(s(3,3)). % goal

move(down, s(X, Y), s(X2, Y)) :- X>0, X2 is X-1.
move(up, s(X, Y), s(X2, Y)) :- X<3, X2 is X+1.
move(left, s(X, Y), s(X, Y2)) :- Y>0, Y2 is Y-1.
move(right, s(X, Y), s(X, Y2)) :- Y<3, Y2 is Y+1.

move(down2, s(X, Y), s(X2, Y)) :- X>0, X2 is X-2.
move(up2, s(X, Y), s(X2, Y)) :- X<3, X2 is X+2.
move(left2, s(X, Y), s(X, Y2)) :- Y>0, Y2 is Y-2.
move(right2, s(X, Y), s(X, Y2)) :- Y<3, Y2 is Y+2.

% robot spawn in (0,0), but it is surrounded by obstacle => certainly need to use move 2
obstacle(s(1,0)).
obstacle(s(1,1)).
obstacle(s(0,1)).


% plan(+MaxN, StartPos, -Trace)
% produce the Trace (i.e. a list of commands)
% that, starting from (0,0)
% moves the robot to (3,3)
plan(0, P, []) :- !, goal(P). % no more moves
plan(_, P, []) :- goal(P), !. % gol in less moves
plan(N, Pos, [D|T]) :-
	move(D, Pos, NewPos),
	not(obstacle(NewPos)),
	N2 is N - 1,
	plan(N2, NewPos, T).






