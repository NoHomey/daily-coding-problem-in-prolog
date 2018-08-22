% Problem 1:
% Given a list of numbers and a number k, return whether any two numbers from the list add up to k.
% For example, given [10, 15, 3, 7] and k of 17, return true since 10 + 7 is 17.
% Bonus: Can you do this in one pass?

% Solution:
% The problem is the famous 2Sum problem and has imperative O(n) solution. Well this one is O(n^2) but is in Prolog :)

hasElement([H], H).
hasElement([H|T], E) :- not(H =:= E), hasElement(T, E).

checkFor2Sum([H|_], L, K) :- E is K - H, hasElement(L, E).
checkFor2Sum([H|T], L, K) :- E is K - H, not(hasElement(L, E)), checkFor2Sum(T, [H|L], K).

sum2K(L, K) :- checkFor2Sum(L, [], K).