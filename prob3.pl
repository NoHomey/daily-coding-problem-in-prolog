% Problem 3:
% Given the root to a binary tree, implement serialize(root), which serializes the tree into a string, and deserialize(s), which deserializes the string back into the tree.

% For example, given the following Node class

%  class Node:
%     def __init__(self, val, left=None, right=None):
%         self.val = val
%         self.left = left
%         self.right = right
% The following test should pass:

% node = Node('root', Node('left', Node('left.left')), Node('right'))
% assert deserialize(serialize(node)).left.left.val == 'left.left'

% Solution:

serialize(node(), CurrentResult, [[] | CurrentResult]).
serialize(node(Val, Left, Right), CurrentResult, RightResult) :-
    serialize(Left, [Val | CurrentResult], LeftResult),
    serialize(Right, LeftResult, RightResult).

reverse([], Reversed, Reversed).
reverse([Head | Tail], CurrentReverse, Reversed) :-
    reverse(Tail, [Head | CurrentReverse], Reversed).

reverse(List, Reversed) :-
    reverse(List, [], Reversed).

serialize(Tree, Result) :-
    serialize(Tree, [], ReversedResult),
    reverse(ReversedResult, Result).

deserialize([[] | Rest], Rest, node()).
deserialize([Val | Rest], AfterRight, node(Val, Left, Right)) :-
    Val \= [],
    deserialize(Rest, AfterLeft, Left),
    deserialize(AfterLeft, AfterRight, Right).

deserialize(Serialized, Root) :-
    deserialize(Serialized, _, Root).

prob3(Tree) :-
    serialize(Tree, Serialized),
    deserialize(Serialized, Deserialized),
    Tree = Deserialized.