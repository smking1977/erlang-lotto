-module(lotto_util).

-export([ticket/1]).


ticket(ID) ->
    Ticket = lists:map(fun() -> rand:uniform(10) end, lists:seq(1, 6)),
    lotto_sup:start_ticket(ID, Ticket).
