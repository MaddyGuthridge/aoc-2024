% before(X,Y) -- this rule gets defined dynamically to make it possible to
% run the code on arbitrary input.
:- dynamic before/2.

% An ordering of pages (X,Y) is only allowed if there is no `before` rule
% stating they must be printed one before the other.
allowed(X,Y):- \+ before(Y,X).

% A list of pages is ordered if:
% ==============================

% It has two elements, and they are all allowed
ordered([A,B]):-allowed(A,B).

% It has >2 elements, the first two are ordered, and the remaining list remains
% ordered with both A and B removed from it.
ordered([A,B|Tail]):-
    allowed(A,B),
    ordered([A|Tail]),
    ordered([B|Tail]).

% Delete last element of a list
% =============================

deleteLast([_], []).
deleteLast([H|T], [H|LastDeleted]):-
    deleteLast(T, LastDeleted).

% Midpoint of a list
% ==================

% For a list with 1 or 2 elements, the midpoint is the first element
midpoint([X], X).
midpoint([X,_], X).

% For a list with more elements
% https://stackoverflow.com/a/42772613/6335363
midpoint([_|T], X):-
    deleteLast(T, TWithoutLast),
    midpoint(TWithoutLast, X).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% For part 2, we just need to determine how to fix the ordering of a sequence.

% A sequence with 1 element is already in-order
fix_sequence([X], [X]).
% A sequence that is in-order requires no modification
fix_sequence(Seq, Seq):-
    ordered(Seq).
% Otherwise, if the sequence has 2 elements, and they are out-of-order, swap
% them
fix_sequence([A, B], [B, A]).
% Finally, if A is `allowed` for all E of Tail, then the problem is later
% in the list, so recurse
fix_sequence([A|Tail], [A|TailFix]):-
    forall(member(E, Tail), allowed(A, E)),
    fix_sequence(Tail, TailFix).
% Otherwise, if the first element is causing the problems (ie it doesn't
% satisfy `allowed` for all elements in tail), shuffle it back further and
% recurse
fix_sequence([A,B|Tail], Fixed):-
    fix_sequence([A|Tail], FixedTail),
    fix_sequence([B|FixedTail], Fixed).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load ordering from input file
% FILENAME = name of file to read from
% RULES = list of rules, each in format `before(X,Y).`
% SEQUENCES = list of sequences to test -- each is a list of numbers
% Sources:
% * https://stackoverflow.com/a/37415937/6335363
% * https://www.swi-prolog.org/pldoc/man?predicate=split_string/4
load_text_from_input(FILENAME, TEXT):-
    % Read file
    open(FILENAME, read, Stream),
    read_string(Stream, _, TEXT),
    close(Stream).

% Given input text, split it into lines, and then split the lines into rules
% and sequences
split_rules_sequences(TEXT, RULE_LINES, SEQUENCE_LINES):-
    % Split into lines
    % Padding string is empty so that we intentionally get an empty lines
    string_lines(TEXT, Lines),
    % Find line index for splitting rules from sequences
    index_of(Lines, "", SplitIndex),
    % Split into rules lines and sequences lines
    split_at_index(SplitIndex, Lines, RULE_LINES, [_|SEQUENCE_LINES]).

% Split given list at index
% https://stackoverflow.com/a/64402279/6335363
split_at_index(Index,List,Left,Right) :-
    length(Left,Index),       % Actually CREATES a list of fresh variables if "Left" is unbound
    append(Left,Right,List).  % Demand that Left + Right = List.

% Find index of element in list
% https://stackoverflow.com/a/4381254/6335363
index_of([Element|_], Element, 0):- !.
index_of([_|Tail], Element, Index):-
    index_of(Tail, Element, Index1),
    !,
    Index is Index1+1.

% Parse rule text, turning it into an `assert`-able fact
% This converts a line like "47|53" into "before(47,53)"
parse_rule(RULE_PSV, RULE_PL):-
    split_string(RULE_PSV, "|", "", [First,Second]),
    atomic_list_concat(["before(", First, ", ", Second, ")."], RULE_PL).

% Convert a sequence into a list of numbers to check
parse_sequence(SEQ_LINE, SEQ_LIST):-
    split_string(SEQ_LINE, ",", "", SequenceStrings),
    maplist(atom_number, SequenceStrings, SEQ_LIST).

filter_valid_sequences(Sequences, ValidSequences):-
    include(ordered, Sequences, ValidSequences).

filter_invalid_sequences(Sequences, InvalidSequences):-
    exclude(ordered, Sequences, InvalidSequences).

load_data(InputFile, Rules, Sequences):-
    load_text_from_input(InputFile, Text),
    split_rules_sequences(Text, RuleLines, SequenceLines),
    maplist(parse_rule, RuleLines, Rules),
    maplist(parse_sequence, SequenceLines, Sequences).

% Assert all clauses
assert_clauses([]).
assert_clauses([Head|Tail]):-
    atom_to_term(Head, Term, []),
    assertz(Term),
    assert_clauses(Tail).

part1(InputFile, Answer):-
    % Remove all previous assertions
    abolish(before/2),
    load_data(InputFile, Rules, Sequences),
    % Assert all rules
    assert_clauses(Rules),
    filter_valid_sequences(Sequences, ValidSequences),
    maplist(midpoint, ValidSequences, Midpoints),
    sum_list(Midpoints, Answer).

part2(InputFile, Answer):-
    % Remove all previous assertions
    abolish(before/2),
    load_data(InputFile, Rules, Sequences),
    % Assert all rules
    assert_clauses(Rules),
    filter_invalid_sequences(Sequences, Invalid),
    maplist(fix_sequence, Invalid, Fixed),
    maplist(midpoint, Fixed, Midpoints),
    sum_list(Midpoints, Answer).

process_argv(Argv, Part, File):-
    length(Argv, 2),
    nth0(0, Argv, PartStr),
    atom_number(PartStr, Part),
    nth0(1, Argv, File),
    !.

process_argv(_Argv, _Part, _File):-
    writeln("Usage: main.pl -- [1|2] [input file]"),
    halt.

main(1, File, Answer):-
    writeln("Part 1..."),
    part1(File, Answer).

main(2, File, Answer):-
    writeln("Part 2..."),
    part2(File, Answer).

main(Part, File, Answer):-
    writeln("Unknown part"),
    writeln(Part),
    writeln(File),
    Answer is 42.

main():-
    % 32 GB stack size, yippee!
    set_prolog_flag(stack_limit, 34_359_738_368),
    writeln("AOC Day 5"),
    current_prolog_flag(argv, Argv),
    process_argv(Argv, Part, File),
    main(Part, File, Answer),
    format("Answer is ~a\n", [Answer]),
    halt.

:- initialization main.
