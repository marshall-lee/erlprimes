-module(segmented).
-export([primes/3]).

process([], Sieve) ->
    Sieve;
process([Prime | PrimesTail], Sieve) ->
    First = sieve:first(Sieve),
    Last = sieve:last(Sieve),
    Start = case First rem Prime of
        0 -> First;
        _ ->
            X = (First div Prime + 1) * Prime,
            case X rem 2 of
                0 -> X + Prime;
                _ -> X
            end
    end,
    process(PrimesTail, sieve:process(Start, Last, Prime, Sieve)).

primes(_, First, Last) when First > Last -> [];
primes(SievingPrimes, First, Last) when First rem 2 == 0 ->
    primes(SievingPrimes, First + 1, Last);
primes(SievingPrimes, First, Last) ->
    Sieve = process(SievingPrimes, sieve:make(First, Last)),
    sieve:to_list(Sieve).
    
