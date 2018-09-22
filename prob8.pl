% Problem 8:
% A unival tree (which stands for "universal value") is a tree where all nodes under it have the same value.
% Given the root to a binary tree, count the number of unival subtrees.
% For example, the following tree has 5 unival subtrees:
%
%    0
%   / \
%  1   0
%     / \
%    1   0
%   / \
%  1   1

% Solution:

countUnivalTrees(Value, node(Value, _, _), node(Value, _, _), CountInLeftAndRight, Count, 1) :-
    Count is CountInLeftAndRight + 1.
countUnivalTrees(Value, node(Value, _, _), node(), CountInLeftAndRight, Count, 1) :-
    Count is CountInLeftAndRight + 1.
countUnivalTrees(Value, node(), node(Value, _, _), CountInLeftAndRight, Count, 1) :-
    Count is CountInLeftAndRight + 1.
countUnivalTrees(_, node(), node(), CountInLeftAndRight, Count, 1) :-
    Count is CountInLeftAndRight + 1.
countUnivalTrees(_, _, _, Count, Count, 0).

countUnivalTrees(Value, Left, Right, 1, 1, CountInLeftAndRight, Count, IsUnival) :-
    countUnivalTrees(Value, Left, Right, CountInLeftAndRight, Count, IsUnival).
countUnivalTrees(_, _, _, _, _, Count, Count, 0).

univalTrees(node(), 0, 1).
univalTrees(node(Value, Left, Right), Count, IsUnival) :-
    univalTrees(Left, LeftCount, IsLeftUnival),
    univalTrees(Right, RightCount, IsRightUnival),
    CountInLeftAndRight is LeftCount + RightCount,
    countUnivalTrees(Value, Left, Right, IsLeftUnival, IsRightUnival, CountInLeftAndRight, Count, IsUnival).

univalTrees(Root, Count) :-
    univalTrees(Root, Count, _).

prob8(Root, Count) :-
    univalTrees(Root, Count).