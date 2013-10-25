-module(concurrent).
-export([primes/3]).

-define(CHUNKSIZE, 1000).

primes(SievingPrimes, First, Last) when First rem 2 == 0 ->
    primes(SievingPrimes, First + 1, Last);
primes(SievingPrimes, First, Last) ->
    Self = self(),
    Starts = lists:seq(First, Last, ?CHUNKSIZE),
    lists:foreach(fun(First_) ->
                          Last_ = case (First_ + ?CHUNKSIZE =< Last) of
                                      true -> First_ + ?CHUNKSIZE - 1;
                                      false -> Last
                                  end,
                          spawn(fun() ->
                                        Primes = segmented:primes(SievingPrimes, First_, Last_),
                                        Self ! Primes
                                end)
                  end, Starts),
    ListOfLists = lists:filter(fun(X) -> X /= [] end, [ receive Primes -> Primes end || _ <- Starts ]),
    lists:flatten(lists:sort(fun([ X1 | _ ], [ X2 | _ ]) -> X1 =< X2 end, ListOfLists)).

