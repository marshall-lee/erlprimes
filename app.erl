-module(app).
-export([main/0, benchmark/1]).
-export([run_concurrent/1, run_segmented/1]).

seconds(M, F, A) ->
    {Seconds, _} = timer:tc(M, F, A),
    Seconds / 1000000.

run_concurrent(N) ->
    Border = trunc(math:sqrt(N)),
    [_ | SievingPrimes] = classic:primes(Border),
    Start = lists:last(SievingPrimes) + 1,
    Primes = concurrent:primes(SievingPrimes, Start, N),
    Answer = 2 + lists:sum(SievingPrimes) + lists:sum(Primes),
    io:format("sum = ~w~n", [Answer]),
    Answer.

run_segmented(N) ->
    Border = trunc(math:sqrt(N)),
    [_ | SievingPrimes] = classic:primes(Border),
    Start = lists:last(SievingPrimes) + 1,
    Primes = segmented:primes(SievingPrimes, Start, N),
    Answer = 2 + lists:sum(SievingPrimes) + lists:sum(Primes),
    io:format("sum = ~w~n", [Answer]),
    Answer.

benchmark(N) ->
    T1 = seconds(app, run_segmented, [N]),
    T2 = seconds(app, run_concurrent, [N]),
    io:format("~f vs ~f seconds~n", [T1, T2]).

main() ->
    benchmark(2000000).
