-module(classic).
-export([primes/1]).

iteration(Lim, N, I, S) when I =< Lim ->
    IsPrime = sieve:get(I,S),
    case IsPrime of
        true  -> iteration(Lim, N, I + 2, sieve:process(I * I, N, I, S));
        _ -> iteration(Lim, N, I + 2, S)
    end;
iteration(_, _, _, S) ->
    S.

primes(N) when N =< 31 ->
    Numbers = lists:seq(2,N),
    lists:filter(fun(I) ->
                    lists:all(fun(J) -> I rem J /= 0 end, lists:seq(2, trunc(math:sqrt(I))))
                end, Numbers);
primes(N) ->
    Lim          = trunc(math:sqrt(N)),
    Sieve        = iteration(Lim, N, 3, sieve:make(3,N)),
    [2 | sieve:to_list(Sieve)].
