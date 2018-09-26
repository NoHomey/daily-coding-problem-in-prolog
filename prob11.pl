% Problem 9:
% Implement an autocomplete system. That is, given a query string s and a set of all possible query strings,
% return all strings in the set that have s as a prefix.
% For example, given the query string de and the set of strings [dog, deer, deal], return [deer, deal].

% Direct solution:

prefix([], _).
prefix([PrefixHead | PrefixTail], [PrefixHead | ListTail]) :-
    prefix(PrefixTail, ListTail).

matchPrefix(_, [], []).
matchPrefix(Prefix, [Word | Rest], [Word | RestMatched]) :-
    prefix(Prefix, Word),
    matchPrefix(Prefix, Rest, RestMatched).
matchPrefix(Prefix, [Word | Rest], RestMatched) :-
    not(prefix(Prefix, Word)),
    matchPrefix(Prefix, Rest, RestMatched).

% Solution with Trie:

insertIntoOrderedList(Inserted, [], [Inserted]).
insertIntoOrderedList(Inserted, OrderedList, [Inserted | OrderedList]) :-
    Inserted = pair(Key, _),
    OrderedList = [Head | _],
    Head = pair(HeadKey, _),
    HeadKey > Key.
insertIntoOrderedList(Inserted, OrderedList, [Head | Rest]) :-
    Inserted = pair(Key, _),
    OrderedList = [Head | Tail],
    Head = pair(HeadKey, _),
    HeadKey < Key,
    insertIntoOrderedList(Inserted, Tail, Rest).

findChild(Letter, [Trie | _], Trie) :-
    Trie = pair(Letter, _).
findChild(Letter, [pair(HeadLetter, _) | Tail], Trie) :-
    Letter \= HeadLetter,
    findChild(Letter, Tail, Trie).

insertIntoTrieChildren(Head, Tail, [Child | Children], [ResultChild | Children]) :-
    Child = pair(Head, _),
    insertIntoTrie(Tail, Child, ResultChild).
insertIntoTrieChildren(Head, Tail, [Child | Children], [Child| ResultChildren]) :-
    Child = pair(HeadKey, _),
    Head \= HeadKey,
    insertIntoTrieChildren(Head, Tail, Children, ResultChildren).

insertIntoTrie([], pair(Key, node(_, Children)), pair(Key, node(1, Children))).
insertIntoTrie([Head | Tail], Root, pair(Key, node(End, ResultChildren))) :-
    Root = pair(Key, node(End, Children)),
    not(findChild(Head, Children, _)),
    insertIntoTrie(Tail, pair(Head, node(0, [])), Result),
    insertIntoOrderedList(Result, Children, ResultChildren).   
insertIntoTrie([Head | Tail], Root, pair(Key, node(End, ResultChildren))) :-
    Root = pair(Key, node(End, Children)),
    findChild(Head, Children, _),
    insertIntoTrieChildren(Head, Tail, Children, ResultChildren).

wordToCodes([], []).
wordToCodes([Letter | Tail], [Code | Rest]) :-
    char_code(Letter, Code),
    wordToCodes(Tail, Rest).

insertWordIntoTrie(Word, Trie, ResultTrie) :-
    wordToCodes(Word, Codes),
    insertIntoTrie(Codes, Trie, ResultTrie).

trie([], pair(0, node(0, []))).
trie([Word | Words], Trie) :-
    trie(Words, WordsTrie),
    insertWordIntoTrie(Word, WordsTrie, Trie).

matchTrie([], Trie, Trie).
matchTrie([Letter | Rest], pair(_, node(_, Children)), MatchedTrie) :-
    findChild(Letter, Children, Child),
    matchTrie(Rest, Child, MatchedTrie).
matchTrie([Letter | _], pair(_, node(_, Children)), pair(0, node(0, []))) :-
    not(findChild(Letter, Children, _)).

reverseList([], Reversed, Reversed).
reverseList([Head | Tail], Current, Reversed) :-
    reverseList(Tail, [Head | Current], Reversed).

reverseList(List, Reversed) :-
    reverseList(List, [], Reversed).

wordsInTrieChildren([], _, Words, Words).
wordsInTrieChildren([pair(Code, node(1, Children)) | Rest], Path, Words, [Word | WordsInChildren]) :-
    char_code(Letter, Code),
    CurrentPath = [Letter | Path],
    wordsInTrieChildren(Rest, Path, Words, WordsInRest),
    wordsInTrieChildren(Children, CurrentPath, WordsInRest, WordsInChildren),
    reverseList(CurrentPath, Word).
wordsInTrieChildren([pair(Code, node(0, Children)) | Rest], Path, Words, WordsInChildren) :-
    char_code(Letter, Code),
    CurrentPath = [Letter | Path],
    wordsInTrieChildren(Rest, Path, Words, WordsInRest),
    wordsInTrieChildren(Children, CurrentPath, WordsInRest, WordsInChildren).

match(Prefix, Words, Matched) :-
    trie(Words, Trie),
    wordToCodes(Prefix, SearchPrefix),
    matchTrie(SearchPrefix, Trie, pair(_, node(_, Children))),
    reverseList(Prefix, Path),
    wordsInTrieChildren(Children, Path, [], Matched).

prob11(Prefix, Words, Matched) :-
    match(Prefix, Words, Matched).