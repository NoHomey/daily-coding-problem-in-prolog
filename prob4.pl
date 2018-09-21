% Problem 4:
% Given an array of integers, find the first missing positive integer in linear time and constant space.
% In other words, find the lowest positive integer that does not exist in the array.
% The array can contain duplicates and negative numbers as well.
% For example, the input [3, 4, -1, 1] should give 2. The input [1, 2, 0] should give 3.
% You can modify the input array in-place.

% Solution:

positiveIntegersOnly([], []).
positiveIntegersOnly([Head | Tail], [Head | Rest]) :-
    Head > 0,
    positiveIntegersOnly(Tail, Rest).
positiveIntegersOnly([Head | Tail], Rest) :-
    Head =< 0,
    positiveIntegersOnly(Tail, Rest).

member(Head, [Head | _]).
member(Element, [Head | Tail]) :-
    Element \= Head,
    member(Element, Tail).

firstPositiveNoneMemberInteger(PositiveIntegers, Integer, Integer) :-
    not(member(Integer, PositiveIntegers)).
firstPositiveNoneMemberInteger(PositiveIntegers, CurrentInteger, Integer) :-
    member(CurrentInteger, PositiveIntegers),
    NextCheckedInteger is CurrentInteger + 1,
    firstPositiveNoneMemberInteger(PositiveIntegers, NextCheckedInteger, Integer).

firstPositiveNoneMemberInteger(PositiveIntegers, Integer) :-
firstPositiveNoneMemberInteger(PositiveIntegers, 1, Integer).

firstPositiveMissingInteger(Integers, Integer) :-
    positiveIntegersOnly(Integers, PositiveIntegers),
    firstPositiveNoneMemberInteger(PositiveIntegers, Integer).

prob4(Integers, Integer) :-
    firstPositiveMissingInteger(Integers, Integer).
