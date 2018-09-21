% Problem 7:
% Given the mapping a = 1, b = 2, ... z = 26, and an encoded message, count the number of ways it can be decoded.
% For example, the message '111' would give 3, since it could be decoded as 'aaa', 'ka', and 'ak'.
% You can assume that the messages are decodable. For example, '001' is not allowed.

% Solution:

numberFromTwoDigits(D1, D2, Number) :-
    Number is D1 * 10 + D2.

countDecodings([], 1).
countDecodings([_], 1).
countDecodings([D1, D2 | RestDigits], Count) :-
    numberFromTwoDigits(D1, D2, 10),
    countDecodings(RestDigits, Count).
countDecodings([D1 | WithoutFirstDigit], Count) :-
    WithoutFirstDigit = [D2 | _],
    numberFromTwoDigits(D1, D2, Number),
    Number > 26,
    countDecodings(WithoutFirstDigit, Count).
countDecodings([D1 | WithoutFirstDigit], Count) :-
    WithoutFirstDigit = [D2 | RestDigits],
    numberFromTwoDigits(D1, D2, Number),
    Number \== 10,
    countDecodings(WithoutFirstDigit, WithoutFirstDigitCount),
    countDecodings(RestDigits, RestDigitsCount),
    Count is WithoutFirstDigitCount + RestDigitsCount.

prob7(Message, Count) :-
    countDecodings(Message, Count).