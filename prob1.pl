% Problem 1:
% Given a list of numbers and a number k, return whether any two numbers from the list add up to k.
% For example, given [10, 15, 3, 7] and k of 17, return true since 10 + 7 is 17.
% Bonus: Can you do this in one pass?

% Solution:
% The problem is the famous 2Sum problem and has imperative O(n) solution. Well this one is O(n^2) but is in Prolog :)

hasElement([Head | _], Head).
hasElement([Head | Tail], Element) :-
    Head \== Element,
    hasElement(Tail, Element).

hasPairWithSum([Head | Tail], Sum) :-
    Element is Sum - Head,
    hasElement(Tail, Element).
hasPairWithSum([Head | Tail], Sum) :-
    Element is Sum - Head,
    \+(hasElement(Tail, Element)),
    hasPairWithSum(Tail, Sum).

% here is O(n.log(n)) solution

listLength([], 0).
listLength([_ | Tail], Length) :-
    listLength(Tail, TailLength), 
    Length is TailLength + 1.

mergeSortedLists([], List2, List2).
mergeSortedLists(List1, [], List1).
mergeSortedLists([Head1 | Tail1], [Head2 | Tail2], [Head1 | Rest]) :-
    Head1 =< Head2,
    mergeSortedLists(Tail1, [Head2 | Tail2], Rest).
mergeSortedLists([Head1 | Tail1], [Head2 | Tail2], [Head2 | Rest]) :-
    Head1 > Head2,
    mergeSortedLists([Head1 | Tail1], Tail2, Rest).

splitList(List, 0, [], List).
splitList([Head | Tail], Count, [Head | Tail1], List2) :-
    Count > 0,
    Count1 is Count - 1,
    splitList(Tail, Count1, Tail1, List2).

mergeSortList([], []).
mergeSortList([Head], [Head]).
mergeSortList(List, SortedList) :-
    listLength(List, Length),
    Length > 1,
    HalfLength is Length // 2,
    splitList(List, HalfLength, List1, List2),
    mergeSortList(List1, SortedList1),
    mergeSortList(List2, SortedList2),
    mergeSortedLists(SortedList1, SortedList2, SortedList).

splitList([Head | Tail], 0, Head, [], Tail).
splitList([Head | Tail], Count, MiddleElement, [Head | LeftListTail], RightList) :-
    Count > 0,
    Count1 is Count - 1,
    splitList(Tail, Count1, MiddleElement, LeftListTail, RightList).

buildBalancedBSTFromSortedList([], _, node()).
buildBalancedBSTFromSortedList([Head], Index, node(data(Head, Index), node(), node())).
buildBalancedBSTFromSortedList(List, LeftIndex, node(data(MiddleElement, MiddleIndex), LeftSubTree, RightSubTree)) :-
    listLength(List, Length),
    Length > 1,
    Middle is Length // 2,
    MiddleIndex is LeftIndex + Middle,
    RightIndex is MiddleIndex + 1,
    splitList(List, Middle, MiddleElement, LeftList, RightList),
    buildBalancedBSTFromSortedList(LeftList, LeftIndex, LeftSubTree),
    buildBalancedBSTFromSortedList(RightList, RightIndex, RightSubTree).

findInBST(Element, Index, node(data(Element, BSTIndex), _, _)) :-
    Index \== BSTIndex.
findInBST(Element, Index, node(data(Element, Index), LeftSubTree, RightSubTree)) :-
    (findInBST(Element, Index, LeftSubTree) ; findInBST(Element, Index, RightSubTree)).
findInBST(Element, Index, node(data(Root, _), LeftSubTree, RightSubTree)) :-
    Element \== Root,
    (findInBST(Element, Index, LeftSubTree) ; findInBST(Element, Index, RightSubTree)).

hasPairWithSumInBST([Head | _], Index, Sum, BST) :-
    Element is Sum - Head,
    findInBST(Element, Index, BST).
hasPairWithSumInBST([Head | Tail], Index, Sum, BST) :-
    Element is Sum - Head,
    \+(findInBST(Element, Index, BST)),
    Index1 is Index + 1,
    hasPairWithSumInBST(Tail, Index1, Sum, BST).

hasPairWithSumInList(List, Sum) :-
    mergeSortList(List, SortedList),
    !,
    buildBalancedBSTFromSortedList(SortedList, 0, BST),
    !,
    hasPairWithSumInBST(SortedList, 0, Sum, BST).