% Problem 9:
% Given a list of integers, write a function that returns the largest sum of non-adjacent numbers. Numbers can be 0 or negative.
% For example, [2, 4, 6, 2, 5] should return 13, since we pick 2, 6, and 5. [5, 1, 1, 5] should return 10, since we pick 5 and 5.

% Solution:

max(A, B, A) :-
    A >= B.
max(A, B, B) :-
    B > A.

includingAndExcludingSums([], ExcludingLastSum, IncludingLastSum, ExcludingLastSum, IncludingLastSum).
includingAndExcludingSums([Current | Rest], ExcludingPrev, IncludingPrev, ExcludingSum, IncludingSum) :-
    max(ExcludingPrev, IncludingPrev, Excluding),
    Including is ExcludingPrev + Current,
    includingAndExcludingSums(Rest, Excluding, Including, ExcludingSum, IncludingSum).

maxSumOfNoneAdjacentIntegers([], 0).
maxSumOfNoneAdjacentIntegers([Head | Tail], Sum) :-
    includingAndExcludingSums(Tail, 0, Head, ExcludingLastSum, IncludingLastSum),
    max(ExcludingLastSum, IncludingLastSum, Sum).

prob9(Integers, MaxSumOfNoneAdjacentIntegers) :-
    maxSumOfNoneAdjacentIntegers(Integers, MaxSumOfNoneAdjacentIntegers).