-module(concurrent).
-export([primes/3]).
-export([process/4]).

-define(CHUNKSIZE, 100000).

process(Pid, SievingPrimes, First, Last) ->
    process_flag(priority, max),
    Primes = segmented:primes(SievingPrimes, First, Last),
    Pid ! Primes.

primes_r(SievingPrimes, First, Last, ProcessCount) when First =< Last ->
    Last_ = if
        First + ?CHUNKSIZE =< Last -> First + ?CHUNKSIZE - 1;
        true                       -> Last
    end,
    spawn(concurrent, process, [self(), SievingPrimes, First, Last_]),
    primes_r(SievingPrimes, First + ?CHUNKSIZE, Last, ProcessCount + 1);
primes_r(_, _, _, ProcessCount) ->
    primes_r_collect(ProcessCount, []).
primes_r_collect(ProcessCount, Primes) when ProcessCount > 0 ->
    receive
        NewPrimes -> primes_r_collect(ProcessCount - 1, Primes ++ NewPrimes)
    end;
primes_r_collect(_, Primes) ->
    lists:sort(Primes).

primes(SievingPrimes, First, Last) when First rem 2 == 0 ->
    primes(SievingPrimes, First + 1, Last);
primes(SievingPrimes, First, Last) ->
    primes_r(SievingPrimes, First, Last, 0).
