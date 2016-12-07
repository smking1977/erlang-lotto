-module(lotto_util).

-export([ticket/1, bulk_ticket/1, generate_tickets/2, ticket_worker/1]).
-define(BatchSize, 10000).


ticket(ID) ->
    Ticket = lists:map(fun(_) -> rand:uniform(10) end, lists:seq(1, 5)),
%    lotto_sup:start_ticket(ID, Ticket).
    lotto_ticket_server:start_link(ID,Ticket).

bulk_ticket(Num) when Num < ?BatchSize  ->
    spawn(lotto_util, generate_tickets, [1, Num]);
bulk_ticket(Num) ->
    Workers = round(Num/ ?BatchSize),
    lists:foreach(
      fun(E) ->  
	      %% io:format("~p : ~p ~n",[((E-1)* ?BatchSize)+1, E* ?BatchSize]) 
	      spawn(lotto_util, ticket_worker, [E])
		  
      end , 
      lists:seq(1, Workers)
     ).

generate_tickets(Match, Match) ->
    ticket(Match),
    io:fwrite('Bulk Creation Complete  ~n ');
generate_tickets(Count, Max) ->
    ticket(Count),
    generate_tickets(Count+1, Max).

ticket_worker(BatchNum) ->
    S1 = erlang:system_time(seconds),
    generate_tickets(((BatchNum -1) * ?BatchSize)+1, BatchNum * ?BatchSize),
    S2 = erlang:system_time(seconds),  
    io:fwrite("Batch Number - ~p, Processing time : ~w seconds ~n ", [BatchNum, (S2 - S1)]).
   
