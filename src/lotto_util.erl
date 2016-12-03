-module(lotto_util).

-export([ticket/1, bulk_ticket/1]).


ticket(ID) ->
    Ticket = lists:map(fun(_) -> rand:uniform(10) end, lists:seq(1, 5)),
    lotto_sup:start_ticket(ID, Ticket).

bulk_ticket(Num) ->
    generate_tickets(1, Num).

generate_tickets(Match, Match) ->
    ticket(Match);
generate_tickets(Count, Max) ->
    ticket(Count),
    generate_tickets(Count+1, Max).
