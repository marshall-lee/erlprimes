#!/usr/bin/env escript
-mode(compile).

-export([benchmark/1, run_concurrent/1, run_segmented/1]).

main(_) ->
    true = code:add_pathz("../../ebin"),
    lists:foreach(fun(N) -> spawn(?MODULE, benchmark, [N]) end, [100, 2000, 40000, 800000]),
    benchmark(1000000).

stop(_State) ->
    ok.

seconds(M, F, A) ->
    {Seconds, _} = timer:tc(M, F, A),
    Seconds / 1000000.

run_concurrent(N) ->
    Border = trunc(math:sqrt(N)),
    [_ | SievingPrimes] = classic:primes(Border),
    Start = lists:last(SievingPrimes) + 1,
    Primes = concurrent:primes(SievingPrimes, Start, N),
    Answer = 2 + lists:sum(SievingPrimes) + lists:sum(Primes),
    io:format("% pi(~w) = ~w~n", [N, Answer]),
    Answer.

run_segmented(N) ->
    Border = trunc(math:sqrt(N)),
    [_ | SievingPrimes] = classic:primes(Border),
    Start = lists:last(SievingPrimes) + 1,
    Primes = segmented:primes(SievingPrimes, Start, N),
    Answer = 2 + lists:sum(SievingPrimes) + lists:sum(Primes),
    io:format("% pi(~w) = ~w~n", [N, Answer]),
    Answer.

benchmark(N) ->
    T1 = seconds(?MODULE, run_segmented, [N]),
    T2 = seconds(?MODULE, run_concurrent, [N]),
    io:format("N = ~w: ~f vs ~f seconds~n", [N, T1, T2]).
