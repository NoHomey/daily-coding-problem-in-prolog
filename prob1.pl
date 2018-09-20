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

mergeSortList([], 0, []).
mergeSortList([Head], 1, [Head]).
mergeSortList(List, Length, SortedList) :-
    Length > 1,
    List1Length is Length // 2,
    List2Length is Length - List1Length,
    splitList(List, List1Length, List1, List2),
    mergeSortList(List1, List1Length, SortedList1),
    mergeSortList(List2, List2Length, SortedList2),
    mergeSortedLists(SortedList1, SortedList2, SortedList).

splitList([Head | Tail], 0, Head, [], Tail).
splitList([Head | Tail], Count, MiddleElement, [Head | LeftListTail], RightList) :-
    Count > 0,
    Count1 is Count - 1,
    splitList(Tail, Count1, MiddleElement, LeftListTail, RightList).

buildBalancedBSTFromSortedList([], 0, _, node()).
buildBalancedBSTFromSortedList([Head], 1, Index, node(data(Head, Index), node(), node())).
buildBalancedBSTFromSortedList(List, Length, LeftIndex, node(data(MiddleElement, MiddleIndex), LeftSubTree, RightSubTree)) :-
    Length > 1,
    Middle is Length // 2,
    LeftListLength is Middle,
    RightListLength is Length - (Middle + 1),
    MiddleIndex is LeftIndex + Middle,
    RightIndex is MiddleIndex + 1,
    splitList(List, Middle, MiddleElement, LeftList, RightList),
    buildBalancedBSTFromSortedList(LeftList, LeftListLength, LeftIndex, LeftSubTree),
    buildBalancedBSTFromSortedList(RightList, RightListLength, RightIndex, RightSubTree).

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
    listLength(List, Length),
    !,
    mergeSortList(List, Length, SortedList),
    !,
    buildBalancedBSTFromSortedList(SortedList, Length, 0, BST),
    !,
    hasPairWithSumInBST(SortedList, 0, Sum, BST).