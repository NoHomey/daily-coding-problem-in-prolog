% Problem 9:
% There exists a staircase with N steps, and you can climb up either 1 or 2 steps at a time.
% Given N, write a function that returns the number of unique ways you can climb the staircase. The order of the steps matters.

% For example, if N is 4, then there are 5 unique ways:

% 1, 1, 1, 1
% 2, 1, 1
% 1, 2, 1
% 1, 1, 2
% 2, 2

% What if, instead of being able to climb 1 or 2 steps at a time, you could climb any number from a set of positive integers X?
% For example, if X = {1, 3, 5}, you could climb 1, 3, or 5 steps at a time.

% Solution:

sum([], _, _, 0).
sum([Step | Others], Climbs, Steps, Count) :-
    Step > Steps,
    sum(Others, Climbs, Steps, Count).
sum([Step | Others], Climbs, Steps, Count) :-
    Step =< Steps,
    sum(Others, Climbs, Steps, OthersCount),
    ReducedSteps is Steps - Step,
    ways(Climbs, ReducedSteps, CurrentCount),
    Count is CurrentCount + OthersCount.

ways(_, 0, 1).
ways(Climbs, Steps, Count) :-
    sum(Climbs, Climbs, Steps, Count).

prob12(Climbs, Steps, Count) :-
    ways(Climbs, Steps, Count).