-module(sieve).
-export([make/2, size/1, first/1, last/1, reset/2, get/2, to_list/1, process/4]).

make(First, Last) when First > Last -> {};
make(First, Last) when First rem 2 == 0 -> make(First + 1, Last);
make(First, Last) when Last  rem 2 == 0 -> make(First, Last - 1);
make(First, Last) ->
    Size = Last - First + 1,
    {First, array:from_list(lists:duplicate(Size div 2 + 1, true))}.

size({}) -> 0;
size({_, Array}) ->
    array:size(Array) * 2 - 1.

first({}) -> throw(empty_sieve);
first({First, _}) -> First.

last({}) -> throw(empty_sieve);
last({First, Array}) -> First + (array:size(Array) - 1) * 2.

reset(_, {}) -> throw(empty_sieve);
reset(I, S) ->
    {First, Array} = S,
    case I rem 2 of
        0 -> S;
        1 -> {First, array:reset((I - First) div 2, Array)}
    end.

get(_, {}) -> throw(empty_sieve);
get(I, S) ->
    {First, Array} = S,
    case I rem 2 of
        0 -> undefined;
        1 -> array:get((I - First) div 2, Array)
    end.

to_list({}) -> [];
to_list({First, Array}) ->
    array:sparse_to_list(array:sparse_map(fun(I,_) -> First + I * 2 end, Array)).

process(Index, Last, Step, Sieve) when Index =< Last ->
    process(Index + Step * 2, Last, Step, reset(Index, Sieve));
process(_, _, _, Sieve) ->
    Sieve.
